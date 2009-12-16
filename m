From: akpm@linux-foundation.org
Subject: [merged] gru-check-for-valid-vma.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:37 -0800
Message-ID: <200912162040.nBGKebh2013658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965015AbZLPUkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: check for valid vma
has been removed from the -mm tree.  Its filename was
     gru-check-for-valid-vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: check for valid vma
From: Jack Steiner <steiner@sgi.com>

Fix bug caused by failure to allocate a GRU gts structure.  The old code
failed to handle the case where the vma was invalid.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-check-for-valid-vma drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-check-for-valid-vma
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -90,19 +90,22 @@ static struct gru_thread_state *gru_allo
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct gru_thread_state *gts = NULL;
+	struct gru_thread_state *gts = ERR_PTR(-EINVAL);
 
 	down_write(&mm->mmap_sem);
 	vma = gru_find_vma(vaddr);
-	if (vma)
-		gts = gru_alloc_thread_state(vma, TSID(vaddr, vma));
-	if (!IS_ERR(gts)) {
-		mutex_lock(&gts->ts_ctxlock);
-		downgrade_write(&mm->mmap_sem);
-	} else {
-		up_write(&mm->mmap_sem);
-	}
+	if (!vma)
+		goto err;
 
+	gts = gru_alloc_thread_state(vma, TSID(vaddr, vma));
+	if (IS_ERR(gts))
+		goto err;
+	mutex_lock(&gts->ts_ctxlock);
+	downgrade_write(&mm->mmap_sem);
+	return gts;
+
+err:
+	up_write(&mm->mmap_sem);
 	return gts;
 }
 
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

