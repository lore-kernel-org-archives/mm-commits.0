From: akpm@linux-foundation.org
Subject: [merged] mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:14 -0700
Message-ID: <20121009180814.B8E05100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:41752 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:08:15 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so660436ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:08:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix potential anon_vma locking issue in mprotect()
has been removed from the -mm tree.  Its filename was
     mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: fix potential anon_vma locking issue in mprotect()

Fix an anon_vma locking issue in the following situation:

- vma has no anon_vma
- next has an anon_vma
- vma is being shrunk / next is being expanded, due to an mprotect call

We need to take next's anon_vma lock to avoid races with rmap users (such
as page migration) while next is being expanded.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-fix-potential-anon_vma-locking-issue-in-mprotect mm/mmap.c
--- a/mm/mmap.c~mm-fix-potential-anon_vma-locking-issue-in-mprotect
+++ a/mm/mmap.c
@@ -573,8 +573,12 @@ again:			remove_next = 1 + (end > next->
 	 */
 	if (vma->anon_vma && (importer || start != vma->vm_start)) {
 		anon_vma = vma->anon_vma;
+		VM_BUG_ON(adjust_next && next->anon_vma &&
+			  anon_vma != next->anon_vma);
+	} else if (adjust_next && next->anon_vma)
+		anon_vma = next->anon_vma;
+	if (anon_vma)
 		anon_vma_lock(anon_vma);
-	}
 
 	if (root) {
 		flush_dcache_mmap_lock(mapping);
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

