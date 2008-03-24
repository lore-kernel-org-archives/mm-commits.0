From: akpm@linux-foundation.org
Subject: + edac-use-the-shorter-list_head-for-brevity.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:25:41 -0700
Message-ID: <200803242225.m2OMPfDu028469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474AbYCXW0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:26:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, norsk5@yahoo.com


The patch titled
     edac: use the shorter LIST_HEAD for brevity
has been added to the -mm tree.  Its filename is
     edac-use-the-shorter-list_head-for-brevity.patch

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
Subject: edac: use the shorter LIST_HEAD for brevity
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Doug Thompson <norsk5@yahoo.com>
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
git-ieee1394.patch
lapb-use-the-shorter-list_head-form-for-brevity.patch
bluetooth-replace-deprecated-rw_lock_unlocked-macros.patch
git-nfsd.patch
git-sparc64.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch

