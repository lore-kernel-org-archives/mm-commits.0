From: akpm@linux-foundation.org
Subject: + lib-test_printfc-test-dentry-printing-fix.patch added to -mm
 tree
Date: Fri, 04 Dec 2015 00:47:14 -0800
Message-ID: <56615312.yVf1MnTgblz7BdxK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbbLDIrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 03:47:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-test_printfc-test-dentry-printing-fix
has been added to the -mm tree.  Its filename is
     lib-test_printfc-test-dentry-printing-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_printfc-test-dentry-printing-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_printfc-test-dentry-printing-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test_printfc-test-dentry-printing-fix

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_printf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/test_printf.c~lib-test_printfc-test-dentry-printing-fix lib/test_printf.c
--- a/lib/test_printf.c~lib-test_printfc-test-dentry-printing-fix
+++ a/lib/test_printf.c
@@ -329,16 +329,16 @@ uuid(void)
 
 static struct dentry test_dentry[4] __initdata = {
 	{ .d_parent = &test_dentry[0],
-	  .d_name = { .len = 3, .name = test_dentry[0].d_iname },
+	  .d_name = QSTR_INIT(test_dentry[0].d_iname, 3),
 	  .d_iname = "foo" },
 	{ .d_parent = &test_dentry[0],
-	  .d_name = { .len = 5, .name = test_dentry[1].d_iname },
+	  .d_name = QSTR_INIT(test_dentry[1].d_iname, 5),
 	  .d_iname = "bravo" },
 	{ .d_parent = &test_dentry[1],
-	  .d_name = { .len = 4, .name = test_dentry[2].d_iname },
+	  .d_name = QSTR_INIT(test_dentry[2].d_iname, 4),
 	  .d_iname = "alfa" },
 	{ .d_parent = &test_dentry[2],
-	  .d_name = { .len = 5, .name = test_dentry[3].d_iname },
+	  .d_name = QSTR_INIT(test_dentry[3].d_iname, 5),
 	  .d_iname = "romeo" },
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
oom-kill-init-lead-panic-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
linux-next-git-rejects.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

