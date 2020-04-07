From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 100/166] proc: inline m_next_vma into m_next
Date: Mon, 06 Apr 2020 20:09:20 -0700
Message-ID: <20200407030920.VxxfFtpAV%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgDGDJV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:09:21 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org

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
