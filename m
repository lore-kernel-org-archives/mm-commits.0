From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 069/118] mm/mmap.c: get rid of odd jump labels in
 find_mergeable_anon_vma()
Date: Thu, 30 Jan 2020 22:14:51 -0800
Message-ID: <20200131061451.xSfMSpwca%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGOw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:14:52 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, jhubbard@nvidia.com, linmiaohe@huawei.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, rientjes@google.com, torvalds@linux-foundation.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mmap.c: get rid of odd jump labels in find_mergeable_anon_vma()

The jump labels try_prev and none are not really needed in
find_mergeable_anon_vma(), eliminate them to improve readability.

Link: http://lkml.kernel.org/r/1574079844-17493-1-git-send-email-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/mm/mmap.c~mm-get-rid-of-odd-jump-labels-in-find_mergeable_anon_vma
+++ a/mm/mmap.c
@@ -1270,26 +1270,22 @@ static struct anon_vma *reusable_anon_vm
  */
 struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
 {
-	struct anon_vma *anon_vma;
-	struct vm_area_struct *near;
+	struct anon_vma *anon_vma = NULL;
 
-	near = vma->vm_next;
-	if (!near)
-		goto try_prev;
+	/* Try next first. */
+	if (vma->vm_next) {
+		anon_vma = reusable_anon_vma(vma->vm_next, vma, vma->vm_next);
+		if (anon_vma)
+			return anon_vma;
+	}
 
-	anon_vma = reusable_anon_vma(near, vma, near);
-	if (anon_vma)
-		return anon_vma;
-try_prev:
-	near = vma->vm_prev;
-	if (!near)
-		goto none;
+	/* Try prev next. */
+	if (vma->vm_prev)
+		anon_vma = reusable_anon_vma(vma->vm_prev, vma->vm_prev, vma);
 
-	anon_vma = reusable_anon_vma(near, near, vma);
-	if (anon_vma)
-		return anon_vma;
-none:
 	/*
+	 * We might reach here with anon_vma == NULL if we can't find
+	 * any reusable anon_vma.
 	 * There's no absolute need to look only at touching neighbours:
 	 * we could search further afield for "compatible" anon_vmas.
 	 * But it would probably just be a waste of time searching,
@@ -1297,7 +1293,7 @@ none:
 	 * We're trying to allow mprotect remerging later on,
 	 * not trying to minimize memory used for anon_vmas.
 	 */
-	return NULL;
+	return anon_vma;
 }
 
 /*
_
