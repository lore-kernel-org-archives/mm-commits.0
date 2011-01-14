From: akpm@linux-foundation.org
Subject: [merged] thp-ksm-free-swap-when-swapcache-page-is-replaced.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:13 -0800
Message-ID: <201101142249.p0EMn3dM005260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab1ANWtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: ksm: free swap when swapcache page is replaced
has been removed from the -mm tree.  Its filename was
     thp-ksm-free-swap-when-swapcache-page-is-replaced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: ksm: free swap when swapcache page is replaced
From: Hugh Dickins <hughd@google.com>

When a swapcache page is replaced by a ksm page, it's best to free that
swap immediately.

Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/ksm.c~thp-ksm-free-swap-when-swapcache-page-is-replaced mm/ksm.c
--- a/mm/ksm.c~thp-ksm-free-swap-when-swapcache-page-is-replaced
+++ a/mm/ksm.c
@@ -800,6 +800,8 @@ static int replace_page(struct vm_area_s
 	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
 
 	page_remove_rmap(page);
+	if (!page_mapped(page))
+		try_to_free_swap(page);
 	put_page(page);
 
 	pte_unmap_unlock(ptep, ptl);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-vmap-area-cache-fix.patch
prio_tree-debugging-patch.patch

