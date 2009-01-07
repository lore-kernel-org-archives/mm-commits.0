From: akpm@linux-foundation.org
Subject: - mm-check-for-no-mmaps-in-exit_mmap.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:55 -0800
Message-ID: <200901072214.n07MEt5S014773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761207AbZAGWPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, akinobu.mita@gmail.com, hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: check for no mmaps in exit_mmap()
has been removed from the -mm tree.  Its filename was
     mm-check-for-no-mmaps-in-exit_mmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: check for no mmaps in exit_mmap()
From: Johannes Weiner <hannes@cmpxchg.org>

When dup_mmap() ooms we can end up with mm->mmap == NULL.  The error
path does mmput() and unmap_vmas() gets a NULL vma which it
dereferences.

In exit_mmap() there is nothing to do at all for this case, we can
cancel the callpath right there.

[akpm@linux-foundation.org: add sorely-needed comment]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/mmap.c~mm-check-for-no-mmaps-in-exit_mmap mm/mmap.c
--- a/mm/mmap.c~mm-check-for-no-mmaps-in-exit_mmap
+++ a/mm/mmap.c
@@ -2090,6 +2090,9 @@ void exit_mmap(struct mm_struct *mm)
 	arch_exit_mmap(mm);
 	mmu_notifier_release(mm);
 
+	if (!mm->mmap)	/* Can happen if dup_mmap() received an OOM */
+		return;
+
 	if (mm->locked_vm) {
 		vma = mm->mmap;
 		while (vma) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch

