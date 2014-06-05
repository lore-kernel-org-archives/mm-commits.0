From: akpm@linux-foundation.org
Subject: [merged] mm-slubc-convert-vnsprintf-static-to-va_format.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:43:14 -0700
Message-ID: <5390c852.WPlGaV063A6noBlr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFETnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, joe@perches.com, cl@linux.com, fabf@skynet.be

Subject: [merged] mm-slubc-convert-vnsprintf-static-to-va_format.patch removed from -mm tree
To: fabf@skynet.be,cl@linux.com,joe@perches.com,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:43:14 -0700


The patch titled
     Subject: mm/slub.c: convert vnsprintf-static to va_format
has been removed from the -mm tree.  Its filename was
     mm-slubc-convert-vnsprintf-static-to-va_format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/slub.c: convert vnsprintf-static to va_format

Inspired by Joe Perches suggestion in ntfs logging clean-up.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN mm/slub.c~mm-slubc-convert-vnsprintf-static-to-va_format mm/slub.c
--- a/mm/slub.c~mm-slubc-convert-vnsprintf-static-to-va_format
+++ a/mm/slub.c
@@ -578,28 +578,30 @@ static void print_page_info(struct page
 
 static void slab_bug(struct kmem_cache *s, char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
-	char buf[100];
 
 	va_start(args, fmt);
-	vsnprintf(buf, sizeof(buf), fmt, args);
-	va_end(args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	pr_err("=============================================================================\n");
-	pr_err("BUG %s (%s): %s\n", s->name, print_tainted(), buf);
+	pr_err("BUG %s (%s): %pV\n", s->name, print_tainted(), &vaf);
 	pr_err("-----------------------------------------------------------------------------\n\n");
 
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
+	va_end(args);
 }
 
 static void slab_fix(struct kmem_cache *s, char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
-	char buf[100];
 
 	va_start(args, fmt);
-	vsnprintf(buf, sizeof(buf), fmt, args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_err("FIX %s: %pV\n", s->name, &vaf);
 	va_end(args);
-	pr_err("FIX %s: %s\n", s->name, buf);
 }
 
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
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

