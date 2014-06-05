From: akpm@linux-foundation.org
Subject: [merged]
 arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:42:22 -0700
Message-ID: <5390c81e.UFdyqToR1Leq5R6x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaFETmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gxt@mprc.pku.edu.cn, fabf@skynet.be

Subject: [merged] arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch removed from -mm tree
To: fabf@skynet.be,gxt@mprc.pku.edu.cn,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:22 -0700


The patch titled
     Subject: arch/unicore32/mm/ioremap.c: convert printk/warn_on to warn()
has been removed from the -mm tree.  Its filename was
     arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: arch/unicore32/mm/ioremap.c: convert printk/warn_on to warn()

Coalesce formats.

[akpm@linux-foundation.org: undo crazy long line]
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/mm/ioremap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/unicore32/mm/ioremap.c~arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1 arch/unicore32/mm/ioremap.c
--- a/arch/unicore32/mm/ioremap.c~arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1
+++ a/arch/unicore32/mm/ioremap.c
@@ -143,13 +143,11 @@ void __iomem *__uc32_ioremap_pfn_caller(
 	/*
 	 * Don't allow RAM to be mapped
 	 */
-	if (pfn_valid(pfn)) {
-		printk(KERN_WARNING "BUG: Your driver calls ioremap() on\n"
+	if (pfn_valid(pfn))
+		WARN(1, "BUG: Your driver calls ioremap() on\n"
 			"system memory.  This leads to architecturally\n"
 			"unpredictable behaviour, and ioremap() will fail in\n"
 			"the next kernel release. Please fix your driver.\n");
-		WARN_ON(1);
-	}
 
 	type = get_mem_type(mtype);
 	if (!type)
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch

