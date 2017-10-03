From: akpm@linux-foundation.org
Subject: [patch 05/51] ksm: fix unlocked iteration over vmas in
 cmp_and_merge_page()
Date: Tue, 03 Oct 2017 16:14:27 -0700
Message-ID: <59d419d3.8kV0dpEAQJwl+4No%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58340 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXO3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:14:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ktkhai@virtuozzo.com, aarcange@redhat.com, hughd@google.com, imbrenda@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mingo@kernel.org, stable@vger.kernel.org, zhongjiang@huawei.com

From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: ksm: fix unlocked iteration over vmas in cmp_and_merge_page()

In this place mm is unlocked, so vmas or list may change.  Down read
mmap_sem to protect them from modifications.

Link: http://lkml.kernel.org/r/150512788393.10691.8868381099691121308.stgit@localhost.localdomain
Fixes: e86c59b1b12d ("mm/ksm: improve deduplication of zero pages with colouring")
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-fix-unlocked-iteration-over-vmas-in-cmp_and_merge_page mm/ksm.c
--- a/mm/ksm.c~ksm-fix-unlocked-iteration-over-vmas-in-cmp_and_merge_page
+++ a/mm/ksm.c
@@ -1990,6 +1990,7 @@ static void stable_tree_append(struct rm
  */
 static void cmp_and_merge_page(struct page *page, struct rmap_item *rmap_item)
 {
+	struct mm_struct *mm = rmap_item->mm;
 	struct rmap_item *tree_rmap_item;
 	struct page *tree_page = NULL;
 	struct stable_node *stable_node;
@@ -2062,9 +2063,11 @@ static void cmp_and_merge_page(struct pa
 	if (ksm_use_zero_pages && (checksum == zero_checksum)) {
 		struct vm_area_struct *vma;
 
-		vma = find_mergeable_vma(rmap_item->mm, rmap_item->address);
+		down_read(&mm->mmap_sem);
+		vma = find_mergeable_vma(mm, rmap_item->address);
 		err = try_to_merge_one_page(vma, page,
 					    ZERO_PAGE(rmap_item->address));
+		up_read(&mm->mmap_sem);
 		/*
 		 * In case of failure, the page was not really empty, so we
 		 * need to continue. Otherwise we're done.
_
