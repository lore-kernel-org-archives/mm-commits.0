From: akpm@linux-foundation.org
Subject: [alternative-merged] fs-execc-fix-minor-memory-leak.patch removed from -mm tree
Date: Tue, 17 May 2016 16:04:13 -0700
Message-ID: <573ba36d.eLxnHKt9w/5L+Z2v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbcEQXEP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2016 19:04:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jj.net@163.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exec.c: fix minor memory leak
has been removed from the -mm tree.  Its filename was
     fs-execc-fix-minor-memory-leak.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/exec.c: fix minor memory leak

When the to-be-removed argument's trailing '\0' is the final byte in the
page, remove_arg_zero()'s logic will avoid freeing the page, will break
from the loop and will then advance bprm->p to point at the first byte in
the next page.  Net result: the final page for the zeroeth argument is
unfreed.

It isn't a very important leak - that page will be freed later by the
bprm-wide sweep in free_arg_pages().

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=116841
Reported-by: hujunjie <jj.net@163.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~fs-execc-fix-minor-memory-leak fs/exec.c
--- a/fs/exec.c~fs-execc-fix-minor-memory-leak
+++ a/fs/exec.c
@@ -1482,8 +1482,15 @@ int remove_arg_zero(struct linux_binprm
 		kunmap_atomic(kaddr);
 		put_arg_page(page);
 
-		if (offset == PAGE_SIZE)
+		if (offset == PAGE_SIZE) {
 			free_arg_page(bprm, (bprm->p >> PAGE_SHIFT) - 1);
+		} else if (offset == PAGE_SIZE - 1) {
+			/*
+			 * The trailing '\0' is the last byte in a page - we're
+			 * about to advance past that byte so free its page now
+			 */
+			free_arg_page(bprm, (bprm->p >> PAGE_SHIFT));
+		}
 	} while (offset == PAGE_SIZE);
 
 	bprm->p++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
mm-slab-freelist-randomization-v5-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes.patch
vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch
allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

