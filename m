From: akpm@linux-foundation.org
Subject: - edac-use-the-shorter-list_head-for-brevity.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:44 -0700
Message-ID: <200804300548.m3U5micC029906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757570AbYD3GL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:11:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     edac: use the shorter LIST_HEAD for brevity
has been removed from the -mm tree.  Its filename was
     edac-use-the-shorter-list_head-for-brevity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: use the shorter LIST_HEAD for brevity
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |    2 +-
 drivers/edac/edac_mc.c     |    2 +-
 drivers/edac/edac_pci.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/edac/edac_device.c~edac-use-the-shorter-list_head-for-brevity drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edac-use-the-shorter-list_head-for-brevity
+++ a/drivers/edac/edac_device.c
@@ -36,7 +36,7 @@
  * is protected by the 'device_ctls_mutex' lock
  */
 static DEFINE_MUTEX(device_ctls_mutex);
-static struct list_head edac_device_list = LIST_HEAD_INIT(edac_device_list);
+static LIST_HEAD(edac_device_list);
 
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
diff -puN drivers/edac/edac_mc.c~edac-use-the-shorter-list_head-for-brevity drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~edac-use-the-shorter-list_head-for-brevity
+++ a/drivers/edac/edac_mc.c
@@ -36,7 +36,7 @@
 
 /* lock to memory controller's control array */
 static DEFINE_MUTEX(mem_ctls_mutex);
-static struct list_head mc_devices = LIST_HEAD_INIT(mc_devices);
+static LIST_HEAD(mc_devices);
 
 #ifdef CONFIG_EDAC_DEBUG
 
diff -puN drivers/edac/edac_pci.c~edac-use-the-shorter-list_head-for-brevity drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~edac-use-the-shorter-list_head-for-brevity
+++ a/drivers/edac/edac_pci.c
@@ -29,7 +29,7 @@
 #include "edac_module.h"
 
 static DEFINE_MUTEX(edac_pci_ctls_mutex);
-static struct list_head edac_pci_list = LIST_HEAD_INIT(edac_pci_list);
+static LIST_HEAD(edac_pci_list);
 
 /*
  * edac_pci_alloc_ctl_info
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-dvb.patch
git-mtd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

