From: akpm@linux-foundation.org
Subject: [merged] arch-ia64-kernel-ia64_ksymsc-dont-export-copy_page-twice.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:18:08 -0800
Message-ID: <200901161918.n0GJI8u1026746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249AbZAPTTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:19:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, prarit@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     arch/ia64/kernel/ia64_ksyms.c: don't export copy_page twice
has been removed from the -mm tree.  Its filename was
     arch-ia64-kernel-ia64_ksymsc-dont-export-copy_page-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/ia64/kernel/ia64_ksyms.c: don't export copy_page twice
From: Andrew Morton <akpm@linux-foundation.org>

Revert linux-next's

commit 7aed50e09223e7623c7ab826efd53f097bed2f73
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Sat Jan 10 02:25:44 2009 +0000
Commit:     David Howells <dhowells@redhat.com>
CommitDate: Sat Jan 10 02:25:44 2009 +0000

    CacheFiles: Add missing copy_page export for ia64

arch/ia64/kernel/ia64_ksyms.c:65: error: redefinition of '__kcrctab_copy_page'
arch/ia64/kernel/ia64_ksyms.c:43: error: previous definition of '__kcrctab_copy_page' was here
arch/ia64/kernel/ia64_ksyms.c:65: error: redefinition of '__kstrtab_copy_page'
arch/ia64/kernel/ia64_ksyms.c:43: error: previous definition of '__kstrtab_copy_page' was here
arch/ia64/kernel/ia64_ksyms.c:65: error: redefinition of '__ksymtab_copy_page'
arch/ia64/kernel/ia64_ksyms.c:43: error: previous definition of '__ksymtab_copy_page' was here

Cc: Prarit Bhargava <prarit@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/ia64_ksyms.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/ia64/kernel/ia64_ksyms.c~arch-ia64-kernel-ia64_ksymsc-dont-export-copy_page-twice arch/ia64/kernel/ia64_ksyms.c
--- a/arch/ia64/kernel/ia64_ksyms.c~arch-ia64-kernel-ia64_ksymsc-dont-export-copy_page-twice
+++ a/arch/ia64/kernel/ia64_ksyms.c
@@ -40,7 +40,6 @@ EXPORT_SYMBOL(__do_clear_user);
 EXPORT_SYMBOL(__strlen_user);
 EXPORT_SYMBOL(__strncpy_from_user);
 EXPORT_SYMBOL(__strnlen_user);
-EXPORT_SYMBOL(copy_page);
 
 /* from arch/ia64/lib */
 extern void __divsi3(void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
i-need-old-gcc.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-net-mlx4-profilec-fix-min-warning.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
regulator-minor-cleanup-of-virtual-consumer-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

