From: akpm@linux-foundation.org
Subject: + mm-support-madvisemadv_free-fix-2-fix.patch added to -mm tree
Date: Fri, 04 Dec 2015 16:51:23 -0800
Message-ID: <5662350b.lQbzmVR9GfgEnhb8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbbLEAvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 19:51:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-support-madvisemadv_free-fix-2-fix
has been added to the -mm tree.  Its filename is
     mm-support-madvisemadv_free-fix-2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-support-madvisemadv_free-fix-2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-support-madvisemadv_free-fix-2-fix.patch

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
Subject: mm-support-madvisemadv_free-fix-2-fix

small cleanups

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-support-madvisemadv_free-fix-2-fix mm/rmap.c
--- a/mm/rmap.c~mm-support-madvisemadv_free-fix-2-fix
+++ a/mm/rmap.c
@@ -1605,7 +1605,7 @@ int try_to_unmap(struct page *page, enum
 
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
-		.arg = (void *)&rp,
+		.arg = &rp,
 		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 	};
@@ -1651,7 +1651,6 @@ int try_to_unmap(struct page *page, enum
 int try_to_munlock(struct page *page)
 {
 	int ret;
-
 	struct rmap_private rp = {
 		.flags = TTU_MUNLOCK,
 		.lazyfreed = 0,
@@ -1659,7 +1658,7 @@ int try_to_munlock(struct page *page)
 
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
-		.arg = (void *)&rp,
+		.arg = &rp,
 		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
oom-kill-init-lead-panic-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
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
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
mm-support-madvisemadv_free-fix-2-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
linux-next-git-rejects.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

