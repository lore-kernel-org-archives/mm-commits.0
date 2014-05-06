From: akpm@linux-foundation.org
Subject: + mm-update-comment-for-default_max_map_count.patch added to -mm
 tree
Date: Tue, 06 May 2014 14:47:10 -0700
Message-ID: <5369585e.Q0hLmKP/zDkgz8xw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaEFVrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 17:47:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: + mm-update-comment-for-default_max_map_count.patch added to -mm tree
To: kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 14:47:10 -0700


The patch titled
     Subject: mm: update comment for DEFAULT_MAX_MAP_COUNT
has been added to the -mm tree.  Its filename is
     mm-update-comment-for-default_max_map_count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-comment-for-default_max_map_count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-comment-for-default_max_map_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: update comment for DEFAULT_MAX_MAP_COUNT

With ELF extended numbering 16-bit bound is not hard limit any more.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/sysctl.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/sched/sysctl.h~mm-update-comment-for-default_max_map_count include/linux/sched/sysctl.h
--- a/include/linux/sched/sysctl.h~mm-update-comment-for-default_max_map_count
+++ a/include/linux/sched/sysctl.h
@@ -25,6 +25,10 @@ enum { sysctl_hung_task_timeout_secs = 0
  * Because the kernel adds some informative sections to a image of program at
  * generating coredump, we need some margin. The number of extra sections is
  * 1-3 now and depends on arch. We use "5" as safe margin, here.
+ *
+ * ELF extended numbering allows more then 65535 sections, so 16-bit bound is
+ * not hard limit any more. Although some userspace tools can be surprised by
+ * that.
  */
 #define MAPCOUNT_ELF_CORE_MARGIN	(5)
 #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
thp-consolidate-assert-checks-in-__split_huge_page.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-move-get_user_pages-related-code-to-separate-file.patch
mm-extract-in_gate_area-case-from-__get_user_pages.patch
mm-cleanup-follow_page_mask.patch
mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch
mm-cleanup-__get_user_pages.patch
mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch
mm-update-comment-for-default_max_map_count.patch
mm-update-comment-for-default_max_map_count-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

