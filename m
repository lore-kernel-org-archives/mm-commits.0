From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-replace-zero-length-array-with-flexible-array-member-fix.patch removed
 from -mm tree
Date: Thu, 04 Jun 2020 16:19:26 -0700
Message-ID: <20200604231926.w2RVfRqRH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFDXT1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:19:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw, chenqiwu@xiaomi.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm-replace-zero-length-array-with-flexible-array-member-fix
has been removed from the -mm tree.  Its filename was
     mm-replace-zero-length-array-with-flexible-array-member-fix.patch

This patch was dropped because it was folded into mm-replace-zero-length-array-with-flexible-array-member.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-zero-length-array-with-flexible-array-member-fix

fix build:

./include/linux/mmzone.h:1143:16: error: flexible array member in a struct with no named members

Cc: Baoquan He <bhe@redhat.com>
Cc: chenqiwu <chenqiwu@xiaomi.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-replace-zero-length-array-with-flexible-array-member-fix
+++ a/include/linux/mmzone.h
@@ -1147,7 +1147,7 @@ struct mem_section_usage {
 	DECLARE_BITMAP(subsection_map, SUBSECTIONS_PER_SECTION);
 #endif
 	/* See declaration of similar field in struct zone */
-	unsigned long pageblock_flags[];
+	unsigned long pageblock_flags[0];
 };
 
 void subsection_map_init(unsigned long pfn, unsigned long nr_pages);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-zero-length-array-with-flexible-array-member.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
