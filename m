From: akpm@linux-foundation.org
Subject: - proper-prototype-for-vty_init.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:09 -0800
Message-ID: <200802070021.m170Lp8D006375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932528AbYBGAob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     proper prototype for vty_init()
has been removed from the -mm tree.  Its filename was
     proper-prototype-for-vty_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proper prototype for vty_init()
From: Adrian Bunk <bunk@kernel.org>

Add a proper prototype for vty_init() in include/linux/vt_kern.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c   |    4 ----
 include/linux/vt_kern.h |    1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/char/tty_io.c~proper-prototype-for-vty_init drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~proper-prototype-for-vty_init
+++ a/drivers/char/tty_io.c
@@ -4048,10 +4048,6 @@ void __init console_init(void)
 	}
 }
 
-#ifdef CONFIG_VT
-extern int vty_init(void);
-#endif
-
 static int __init tty_class_init(void)
 {
 	tty_class = class_create(THIS_MODULE, "tty");
diff -puN include/linux/vt_kern.h~proper-prototype-for-vty_init include/linux/vt_kern.h
--- a/include/linux/vt_kern.h~proper-prototype-for-vty_init
+++ a/include/linux/vt_kern.h
@@ -77,6 +77,7 @@ void change_console(struct vc_data *new_
 void reset_vc(struct vc_data *vc);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
+int vty_init(void);
 
 /*
  * vc_screen.c shares this temporary buffer with the console write code so that
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
