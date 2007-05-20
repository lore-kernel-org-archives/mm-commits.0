From: akpm@linux-foundation.org
Subject: - vdso-print-fatal-signals-use-ctl_unnumbered.patch removed from -mm tree
Date: Sat, 19 May 2007 23:43:19 -0700
Message-ID: <200705200643.l4K6hIUI017479@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59686 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763625AbXETGp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 02:45:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@infradead.org, ebiederm@xmission.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     vdso-print-fatal-signals-use-ctl_unnumbered
has been removed from the -mm tree.  Its filename was
     vdso-print-fatal-signals-use-ctl_unnumbered.patch

This patch was dropped because it was folded into vdso-print-fatal-signals.patch

------------------------------------------------------
Subject: vdso-print-fatal-signals-use-ctl_unnumbered
From: Andrew Morton <akpm@osdl.org>

Don't add new sysctl numbers.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    1 -
 kernel/sysctl.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/sysctl.h~vdso-print-fatal-signals-use-ctl_unnumbered include/linux/sysctl.h
--- a/include/linux/sysctl.h~vdso-print-fatal-signals-use-ctl_unnumbered
+++ a/include/linux/sysctl.h
@@ -106,7 +106,6 @@ enum
 	KERN_CAP_BSET=14,	/* int: capability bounding set */
 	KERN_PANIC=15,		/* int: panic timeout */
 	KERN_REALROOTDEV=16,	/* real root device to mount after initrd */
-	KERN_PRINT_FATAL=17,	/* int: print fatal signals (0/1) */
 
 	KERN_SPARC_REBOOT=21,	/* reboot command on Sparc */
 	KERN_CTLALTDEL=22,	/* int: allow ctl-alt-del to reboot */
diff -puN kernel/sysctl.c~vdso-print-fatal-signals-use-ctl_unnumbered kernel/sysctl.c
--- a/kernel/sysctl.c~vdso-print-fatal-signals-use-ctl_unnumbered
+++ a/kernel/sysctl.c
@@ -312,7 +312,7 @@ static ctl_table kern_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= KERN_PRINT_FATAL,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "print-fatal-signals",
 		.data		= &print_fatal_signals,
 		.maxlen		= sizeof(int),
_

Patches currently in -mm which might be from akpm@osdl.org are

update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
mm-implement-swap-prefetching.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
