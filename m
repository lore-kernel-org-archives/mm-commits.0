From: akpm@linux-foundation.org
Subject: - ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:48:38 -0700
Message-ID: <200707101948.l6AJmcbx026017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504AbXGJTsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:48:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     PPC: remove dead code for preventing pread() and pwrite() calls
has been removed from the -mm tree.  Its filename was
     ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PPC: remove dead code for preventing pread() and pwrite() calls
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the deactivated code for checking for pread() and pwrite()
calls on the PPC-based BRIQ.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/briq_panel.c |   10 ----------
 1 files changed, 10 deletions(-)

diff -puN drivers/char/briq_panel.c~ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls drivers/char/briq_panel.c
--- a/drivers/char/briq_panel.c~ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls
+++ a/drivers/char/briq_panel.c
@@ -91,11 +91,6 @@ static ssize_t briq_panel_read(struct fi
 	unsigned short c;
 	unsigned char cp;
 
-#if 0	/*  Can't seek (pread) on this device  */
-	if (ppos != &file->f_pos)
-		return -ESPIPE;
-#endif
-
 	if (!vfd_is_open)
 		return -ENODEV;
 
@@ -139,11 +134,6 @@ static ssize_t briq_panel_write(struct f
 	size_t indx = len;
 	int i, esc = 0;
 
-#if 0	/*  Can't seek (pwrite) on this device  */
-	if (ppos != &file->f_pos)
-		return -ESPIPE;
-#endif
-
 	if (!vfd_is_open)
 		return -EBUSY;
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-net.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-sh.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
usb-remove-makefile-reference-to-obsolete-ohci_at91.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
frv-be-self-consistent-and-use-config_gdb_console-everywhere.patch
frv-remove-some-dead-code.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
remove-final-two-references-to-__obsolete_setup-macro.patch
cdrom-replace-hard-coded-constants-by-kernelh-macro.patch
nls-remove-obsolete-makefile-entries.patch
