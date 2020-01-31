From: akpm@linux-foundation.org
Subject: [merged]
 mm-get-rid-of-odd-jump-labels-in-find_mergeable_anon_vma.patch removed from
 -mm tree
Date: Fri, 31 Jan 2020 15:19:11 -0800
Message-ID: <20200131231911.f2N6xXhbc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgAaXTM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, jhubbard@nvidia.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, rientjes@google.com


The patch titled
     Subject: mm/mmap.c: get rid of odd jump labels in find_mergeable_anon_vma()
has been removed from the -mm tree.  Its filename was
     mm-get-rid-of-odd-jump-labels-in-find_mergeable_anon_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are
