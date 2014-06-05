From: akpm@linux-foundation.org
Subject: [merged] lib-bugc-convert-printk-to-pr_foo.patch removed from -mm tree
Date: Thu, 05 Jun 2014 13:05:31 -0700
Message-ID: <5390cd8b.IPL+icElpfJIJ3Nz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaFEUFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jeremy@goop.org, fabf@skynet.be

Subject: [merged] lib-bugc-convert-printk-to-pr_foo.patch removed from -mm tree
To: fabf@skynet.be,jeremy@goop.org,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:31 -0700


The patch titled
     Subject: lib/bug.c: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     lib-bugc-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: lib/bug.c: convert printk to pr_foo()

- Coalesce formats

- "WARNING:" prefix unchanged to keep bug format.

- printk(KERN_DEFAULT not converted.

- define pr_fmt without prefix to avoid any default prefix update
  (suggested by Joe Perches).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN lib/bug.c~lib-bugc-convert-printk-to-pr_foo lib/bug.c
--- a/lib/bug.c~lib-bugc-convert-printk-to-pr_foo
+++ a/lib/bug.c
@@ -37,6 +37,9 @@
 
     Jeremy Fitzhardinge <jeremy@goop.org> 2006
  */
+
+#define pr_fmt(fmt) fmt
+
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -153,15 +156,13 @@ enum bug_trap_type report_bug(unsigned l
 
 	if (warning) {
 		/* this is a WARN_ON rather than BUG/BUG_ON */
-		printk(KERN_WARNING "------------[ cut here ]------------\n");
+		pr_warn("------------[ cut here ]------------\n");
 
 		if (file)
-			printk(KERN_WARNING "WARNING: at %s:%u\n",
-			       file, line);
+			pr_warn("WARNING: at %s:%u\n", file, line);
 		else
-			printk(KERN_WARNING "WARNING: at %p "
-			       "[verbose debug info unavailable]\n",
-			       (void *)bugaddr);
+			pr_warn("WARNING: at %p [verbose debug info unavailable]\n",
+				(void *)bugaddr);
 
 		print_modules();
 		show_regs(regs);
@@ -174,12 +175,10 @@ enum bug_trap_type report_bug(unsigned l
 	printk(KERN_DEFAULT "------------[ cut here ]------------\n");
 
 	if (file)
-		printk(KERN_CRIT "kernel BUG at %s:%u!\n",
-		       file, line);
+		pr_crit("kernel BUG at %s:%u!\n", file, line);
 	else
-		printk(KERN_CRIT "Kernel BUG at %p "
-		       "[verbose debug info unavailable]\n",
-		       (void *)bugaddr);
+		pr_crit("Kernel BUG at %p [verbose debug info unavailable]\n",
+			(void *)bugaddr);
 
 	return BUG_TRAP_TYPE_BUG;
 }
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

