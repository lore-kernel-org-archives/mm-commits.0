From: akpm@linux-foundation.org
Subject: - bluetooth-remove-the-redundant-non-seekable-llseek-method.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:32:59 -0700
Message-ID: <200707132232.l6DMWxZh025037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932165AbXGMWdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:33:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     BLUETOOTH: remove the redundant non-seekable llseek method
has been removed from the -mm tree.  Its filename was
     bluetooth-remove-the-redundant-non-seekable-llseek-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: BLUETOOTH: remove the redundant non-seekable llseek method
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the llseek method given that the open method already calls
nonseekable_open().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_vhci.c |    6 ------
 1 files changed, 6 deletions(-)

diff -puN drivers/bluetooth/hci_vhci.c~bluetooth-remove-the-redundant-non-seekable-llseek-method drivers/bluetooth/hci_vhci.c
--- a/drivers/bluetooth/hci_vhci.c~bluetooth-remove-the-redundant-non-seekable-llseek-method
+++ a/drivers/bluetooth/hci_vhci.c
@@ -180,11 +180,6 @@ static inline ssize_t vhci_put_user(stru
 	return total;
 }
 
-static loff_t vhci_llseek(struct file *file, loff_t offset, int origin)
-{
-	return -ESPIPE;
-}
-
 static ssize_t vhci_read(struct file *file,
 				char __user *buf, size_t count, loff_t *pos)
 {
@@ -334,7 +329,6 @@ static int vhci_fasync(int fd, struct fi
 
 static const struct file_operations vhci_fops = {
 	.owner		= THIS_MODULE,
-	.llseek		= vhci_llseek,
 	.read		= vhci_read,
 	.write		= vhci_write,
 	.poll		= vhci_poll,
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-sh.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
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
