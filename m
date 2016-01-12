From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
 added to -mm tree
Date: Mon, 11 Jan 2016 20:36:31 -0800
Message-ID: <569482cf.xqn5qjcyKO72xU7C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761729AbcALEgc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 23:36:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@linux.intel.com, dave@stgolabs.net, hillf.zj@alibaba-inc.com, hughd@google.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch

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
Subject: mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix

move hugetlb_vmdelete_list()

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   76 ++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix
+++ a/fs/hugetlbfs/inode.c
@@ -324,6 +324,44 @@ static void remove_huge_page(struct page
 	delete_from_page_cache(page);
 }
 
+static void
+hugetlb_vmdelete_list(struct rb_root *root, pgoff_t start, pgoff_t end)
+{
+	struct vm_area_struct *vma;
+
+	/*
+	 * end == 0 indicates that the entire range after
+	 * start should be unmapped.
+	 */
+	vma_interval_tree_foreach(vma, root, start, end ? end : ULONG_MAX) {
+		unsigned long v_offset;
+		unsigned long v_end;
+
+		/*
+		 * Can the expression below overflow on 32-bit arches?
+		 * No, because the interval tree returns us only those vmas
+		 * which overlap the truncated area starting at pgoff,
+		 * and no vma on a 32-bit arch can span beyond the 4GB.
+		 */
+		if (vma->vm_pgoff < start)
+			v_offset = (start - vma->vm_pgoff) << PAGE_SHIFT;
+		else
+			v_offset = 0;
+
+		if (!end)
+			v_end = vma->vm_end;
+		else {
+			v_end = ((end - vma->vm_pgoff) << PAGE_SHIFT)
+							+ vma->vm_start;
+			if (v_end > vma->vm_end)
+				v_end = vma->vm_end;
+		}
+
+		unmap_hugepage_range(vma, vma->vm_start + v_offset, v_end,
+									NULL);
+	}
+}
+
 /*
  * remove_inode_hugepages handles two distinct cases: truncation and hole
  * punch.  There are subtle differences in operation for each case.
@@ -458,44 +496,6 @@ static void hugetlbfs_evict_inode(struct
 	clear_inode(inode);
 }
 
-static inline void
-hugetlb_vmdelete_list(struct rb_root *root, pgoff_t start, pgoff_t end)
-{
-	struct vm_area_struct *vma;
-
-	/*
-	 * end == 0 indicates that the entire range after
-	 * start should be unmapped.
-	 */
-	vma_interval_tree_foreach(vma, root, start, end ? end : ULONG_MAX) {
-		unsigned long v_offset;
-		unsigned long v_end;
-
-		/*
-		 * Can the expression below overflow on 32-bit arches?
-		 * No, because the interval tree returns us only those vmas
-		 * which overlap the truncated area starting at pgoff,
-		 * and no vma on a 32-bit arch can span beyond the 4GB.
-		 */
-		if (vma->vm_pgoff < start)
-			v_offset = (start - vma->vm_pgoff) << PAGE_SHIFT;
-		else
-			v_offset = 0;
-
-		if (!end)
-			v_end = vma->vm_end;
-		else {
-			v_end = ((end - vma->vm_pgoff) << PAGE_SHIFT)
-							+ vma->vm_start;
-			if (v_end > vma->vm_end)
-				v_end = vma->vm_end;
-		}
-
-		unmap_hugepage_range(vma, vma->vm_start + v_offset, v_end,
-									NULL);
-	}
-}
-
 static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 {
 	pgoff_t pgoff;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
fs-coredump-prevent-core-path-components-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-overlayfs-superc-needs-pagemaph.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

