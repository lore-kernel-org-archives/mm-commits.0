From: akpm@linux-foundation.org
Subject: +
 ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch added to -mm tree
Date: Thu, 10 Dec 2015 17:29:40 -0800
Message-ID: <566a2704.+QgvNwm0hOLrut3r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbLKB3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Dec 2015 20:29:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2
has been added to the -mm tree.  Its filename is
     ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch

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
Subject: ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2

fix non-NUMA build

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2 mm/ksm.c
--- a/mm/ksm.c~ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2
+++ a/mm/ksm.c
@@ -557,7 +557,7 @@ static struct stable_node *alloc_stable_
 		INIT_HLIST_HEAD(&chain->hlist);
 		chain->chain_prune_time = jiffies;
 		chain->rmap_hlist_len = STABLE_NODE_CHAIN;
-#ifdef CONFIG_DEBUG_VM
+#if defined (CONFIG_DEBUG_VM) && defined(CONFIG_NUMA)
 		chain->nid = -1; /* debug */
 #endif
 		ksm_stable_node_chains++;
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
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-printk-introduce-new-format-string-for-flags-fix-2.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
include-linux-propertyh-fix-build-issues-with-gcc-444.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch

