From: akpm@linux-foundation.org
Subject: + fusion-mpt-convert-inactive_list_mutex-in-a-mutex.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:24:36 -0700
Message-ID: <200803102024.m2AKOawl003802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034AbYCJUZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:25:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net, Eric.Moore@lsil.com


The patch titled
     Fusion MPT: convert inactive_list_mutex in a mutex
has been added to the -mm tree.  Its filename is
     fusion-mpt-convert-inactive_list_mutex-in-a-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fusion MPT: convert inactive_list_mutex in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

Fusion MPT driver: the semaphore inactive_list_mutex is used as a
mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c  |   10 +++++-----
 drivers/message/fusion/mptbase.h  |    3 ++-
 drivers/message/fusion/mptscsih.c |    8 ++++----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~fusion-mpt-convert-inactive_list_mutex-in-a-mutex drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~fusion-mpt-convert-inactive_list_mutex-in-a-mutex
+++ a/drivers/message/fusion/mptbase.c
@@ -2143,7 +2143,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		/*
 		 * Initalize link list for inactive raid volumes.
 		 */
-		init_MUTEX(&ioc->raid_data.inactive_list_mutex);
+		mutex_init(&ioc->raid_data.inactive_list_mutex);
 		INIT_LIST_HEAD(&ioc->raid_data.inactive_list);
 
 		if (ioc->bus_type == SAS) {
@@ -5129,13 +5129,13 @@ mpt_inactive_raid_list_free(MPT_ADAPTER 
 	if (list_empty(&ioc->raid_data.inactive_list))
 		return;
 
-	down(&ioc->raid_data.inactive_list_mutex);
+	mutex_lock(&ioc->raid_data.inactive_list_mutex);
 	list_for_each_entry_safe(component_info, pNext,
 	    &ioc->raid_data.inactive_list, list) {
 		list_del(&component_info->list);
 		kfree(component_info);
 	}
-	up(&ioc->raid_data.inactive_list_mutex);
+	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
 }
 
 /**
@@ -5194,7 +5194,7 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *i
 	if (!handle_inactive_volumes)
 		goto out;
 
-	down(&ioc->raid_data.inactive_list_mutex);
+	mutex_lock(&ioc->raid_data.inactive_list_mutex);
 	for (i = 0; i < buffer->NumPhysDisks; i++) {
 		if(mpt_raid_phys_disk_pg0(ioc,
 		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
@@ -5214,7 +5214,7 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *i
 		list_add_tail(&component_info->list,
 		    &ioc->raid_data.inactive_list);
 	}
-	up(&ioc->raid_data.inactive_list_mutex);
+	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
 
  out:
 	if (buffer)
diff -puN drivers/message/fusion/mptbase.h~fusion-mpt-convert-inactive_list_mutex-in-a-mutex drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h~fusion-mpt-convert-inactive_list_mutex-in-a-mutex
+++ a/drivers/message/fusion/mptbase.h
@@ -51,6 +51,7 @@
 
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/mutex.h>
 
 #include "lsi/mpi_type.h"
 #include "lsi/mpi.h"		/* Fusion MPI(nterface) basic defs */
@@ -531,7 +532,7 @@ struct inactive_raid_component_info {
 typedef	struct _RaidCfgData {
 	IOCPage2_t	*pIocPg2;		/* table of Raid Volumes */
 	IOCPage3_t	*pIocPg3;		/* table of physical disks */
-	struct semaphore	inactive_list_mutex;
+	struct mutex	inactive_list_mutex;
 	struct list_head	inactive_list; /* link list for physical
 						disk that belong in
 						inactive volumes */
diff -puN drivers/message/fusion/mptscsih.c~fusion-mpt-convert-inactive_list_mutex-in-a-mutex drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~fusion-mpt-convert-inactive_list_mutex-in-a-mutex
+++ a/drivers/message/fusion/mptscsih.c
@@ -2295,14 +2295,14 @@ mptscsih_is_phys_disk(MPT_ADAPTER *ioc, 
 	if (list_empty(&ioc->raid_data.inactive_list))
 		goto out;
 
-	down(&ioc->raid_data.inactive_list_mutex);
+	mutex_lock(&ioc->raid_data.inactive_list_mutex);
 	list_for_each_entry(component_info, &ioc->raid_data.inactive_list,
 	    list) {
 		if ((component_info->d.PhysDiskID == id) &&
 		    (component_info->d.PhysDiskBus == channel))
 			rc = 1;
 	}
-	up(&ioc->raid_data.inactive_list_mutex);
+	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
 
  out:
 	return rc;
@@ -2332,14 +2332,14 @@ mptscsih_raid_id_to_num(MPT_ADAPTER *ioc
 	if (list_empty(&ioc->raid_data.inactive_list))
 		goto out;
 
-	down(&ioc->raid_data.inactive_list_mutex);
+	mutex_lock(&ioc->raid_data.inactive_list_mutex);
 	list_for_each_entry(component_info, &ioc->raid_data.inactive_list,
 	    list) {
 		if ((component_info->d.PhysDiskID == id) &&
 		    (component_info->d.PhysDiskBus == channel))
 			rc = component_info->d.PhysDiskNum;
 	}
-	up(&ioc->raid_data.inactive_list_mutex);
+	mutex_unlock(&ioc->raid_data.inactive_list_mutex);
 
  out:
 	return rc;
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

cosa-srp-convert-channel_datarsem-to-mutex.patch
alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch
fusion-mpt-convert-inactive_list_mutex-in-a-mutex.patch
convert-acl-sem-in-a-mutex.patch
convert-stats_sem-in-a-mutex.patch
convert-wpa_sem-in-a-mutex.patch
fs-inodec-use-hlist_for_each_entry.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch

