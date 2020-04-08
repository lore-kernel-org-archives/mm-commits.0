From: akpm@linux-foundation.org
Subject: [merged] proc-inline-m_next_vma-into-m_next.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 19:00:23 -0700
Message-ID: <20200408020023.3HO8MCgLP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgDHCA1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: proc: inline m_next_vma into m_next
has been removed from the -mm tree.  Its filename was
     proc-inline-m_next_vma-into-m_next.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: inline m_next_vma into m_next

It's clearer to just put this inline.

Link: http://lkml.kernel.org/r/20200317193201.9924-5-adobriyan@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/fs/proc/task_mmu.c~proc-inline-m_next_vma-into-m_next
+++ a/fs/proc/task_mmu.c
@@ -123,14 +123,6 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-static struct vm_area_struct *
-m_next_vma(struct proc_maps_private *priv, struct vm_area_struct *vma)
-{
-	if (vma == priv->tail_vma)
-		return NULL;
-	return vma->vm_next ?: priv->tail_vma;
-}
