From: akpm@linux-foundation.org
Subject: +
 ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix.patch
 added to -mm tree
Date: Thu, 10 Dec 2015 16:35:01 -0800
Message-ID: <566a1a35.EzzNgQouc4jfbX3H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbbLKAfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Dec 2015 19:35:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix
has been added to the -mm tree.  Its filename is
     ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix.patch

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
Subject: ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix

these BUILD_BUG_ONs are triggering

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/ksm.c~ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix mm/ksm.c
--- a/mm/ksm.c~ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix
+++ a/mm/ksm.c
@@ -629,8 +629,8 @@ static void remove_node_from_stable_tree
 	 * from &migrate_nodes. This will verify that future list.h changes
 	 * don't break STABLE_NODE_DUP_HEAD.
 	 */
-	BUILD_BUG_ON(STABLE_NODE_DUP_HEAD <= &migrate_nodes);
-	BUILD_BUG_ON(STABLE_NODE_DUP_HEAD >= &migrate_nodes + 1);
+	WARN_ON_ONCE(STABLE_NODE_DUP_HEAD <= &migrate_nodes);
+	WARN_ON_ONCE(STABLE_NODE_DUP_HEAD >= &migrate_nodes + 1);
 
 	if (stable_node->head == &migrate_nodes)
 		list_del(&stable_node->list);
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
include-linux-propertyh-fix-build-with-gcc-444.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

