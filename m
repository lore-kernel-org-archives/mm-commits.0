From: akpm@linux-foundation.org
Subject: [merged] lib-debugobjectsc-add-pr_fmt-to-logging.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:42:34 -0700
Message-ID: <5390c82a.ijQeeu1eMxbagJt9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaFETme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, fabf@skynet.be

Subject: [merged] lib-debugobjectsc-add-pr_fmt-to-logging.patch removed from -mm tree
To: fabf@skynet.be,josh@joshtriplett.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:34 -0700


The patch titled
     Subject: lib/debugobjects.c: add pr_fmt to logging
has been removed from the -mm tree.  Its filename was
     lib-debugobjectsc-add-pr_fmt-to-logging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: lib/debugobjects.c: add pr_fmt to logging

Add ODEBUG: prefix to pr_fmt

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN lib/debugobjects.c~lib-debugobjectsc-add-pr_fmt-to-logging lib/debugobjects.c
--- a/lib/debugobjects.c~lib-debugobjectsc-add-pr_fmt-to-logging
+++ a/lib/debugobjects.c
@@ -7,6 +7,9 @@
  *
  * For licencing details see kernel-base/COPYING
  */
+
+#define pr_fmt(fmt) "ODEBUG: " fmt
+
 #include <linux/debugobjects.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
@@ -218,7 +221,7 @@ static void debug_objects_oom(void)
 	unsigned long flags;
 	int i;
 
-	pr_warn("ODEBUG: Out of memory. ODEBUG disabled\n");
+	pr_warn("Out of memory. ODEBUG disabled\n");
 
 	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
 		raw_spin_lock_irqsave(&db->lock, flags);
@@ -292,9 +295,9 @@ static void debug_object_is_on_stack(voi
 
 	limit++;
 	if (is_on_stack)
-		pr_warn("ODEBUG: object is on stack, but not annotated\n");
+		pr_warn("object is on stack, but not annotated\n");
 	else
-		pr_warn("ODEBUG: object is not on stack, but annotated\n");
+		pr_warn("object is not on stack, but annotated\n");
 	WARN_ON(1);
 }
 
@@ -983,7 +986,7 @@ static void __init debug_objects_selftes
 	if (check_results(&obj, ODEBUG_STATE_NONE, ++fixups, ++warnings))
 		goto out;
 #endif
-	pr_info("ODEBUG: selftest passed\n");
+	pr_info("selftest passed\n");
 
 out:
 	debug_objects_fixups = oldfixups;
@@ -1088,7 +1091,7 @@ void __init debug_objects_mem_init(void)
 		debug_objects_enabled = 0;
 		if (obj_cache)
 			kmem_cache_destroy(obj_cache);
-		pr_warn("ODEBUG: out of memory.\n");
+		pr_warn("out of memory.\n");
 	} else
 		debug_objects_selftest();
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

