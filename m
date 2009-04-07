From: akpm@linux-foundation.org
Subject: + edac-add-new-core-index-allocator.patch added to -mm tree
Date: Tue, 07 Apr 2009 16:54:52 -0700
Message-ID: <200904072354.n37Nsqjw005368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756225AbZDGX4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 19:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qingtao.cao@windriver.com, dougthompson@xmission.com


The patch titled
     edac: add new core index allocator
has been added to the -mm tree.  Its filename is
     edac-add-new-core-index-allocator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: add new core index allocator
From: Harry Ciao <qingtao.cao@windriver.com>

Add edac_device_alloc_index(), because for some platforms there may exist
several EDAC driver modules that could make use of edac_device_ctl_info
structure at the same time.  The index allocation for these structures
should be taken care of by EDAC core.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h   |    1 +
 drivers/edac/edac_device.c |   13 +++++++++++++
 2 files changed, 14 insertions(+)

diff -puN drivers/edac/edac_core.h~edac-add-new-core-index-allocator drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~edac-add-new-core-index-allocator
+++ a/drivers/edac/edac_core.h
@@ -840,6 +840,7 @@ extern void edac_device_handle_ue(struct
 				int inst_nr, int block_nr, const char *msg);
 extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
 				int inst_nr, int block_nr, const char *msg);
+extern int edac_device_alloc_index(void);
 
 /*
  * edac_pci APIs
diff -puN drivers/edac/edac_device.c~edac-add-new-core-index-allocator drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edac-add-new-core-index-allocator
+++ a/drivers/edac/edac_device.c
@@ -37,6 +37,7 @@
  */
 static DEFINE_MUTEX(device_ctls_mutex);
 static LIST_HEAD(edac_device_list);
+static atomic_t device_indexes = ATOMIC_INIT(0);
 
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
@@ -491,6 +492,18 @@ void edac_device_reset_delay_period(stru
 	mutex_unlock(&device_ctls_mutex);
 }
 
+/*
+ * edac_device_alloc_index: Allocate a unique device index number
+ *
+ * Return:
+ *	allocated index number
+ */
+int edac_device_alloc_index(void)
+{
+	return atomic_inc_return(&device_indexes) - 1;
+}
+EXPORT_SYMBOL_GPL(edac_device_alloc_index);
+
 /**
  * edac_device_add_device: Insert the 'edac_dev' structure into the
  * edac_device global list and create sysfs entries associated with
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

origin.patch
edac-add-new-core-index-allocator.patch

