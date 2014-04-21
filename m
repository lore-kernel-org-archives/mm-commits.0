From: akpm@linux-foundation.org
Subject: [nacked]
 driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch removed from -mm tree
Date: Mon, 21 Apr 2014 15:13:15 -0700
Message-ID: <535597fb.uG78PLOZdD7gBcVd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaDUWNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 18:13:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sivanich@sgi.com, davidlohr@hp.com, zeus@gnu.org

Subject: [nacked] driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch removed from -mm tree
To: zeus@gnu.org,davidlohr@hp.com,sivanich@sgi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 15:13:15 -0700


The patch titled
     Subject: drivers,sgi-gru/grufault.c: call find_vma with the mmap_sem held
has been removed from the -mm tree.  Its filename was
     driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Jonathan Gonzalez V <zeus@gnu.org>
Subject: drivers,sgi-gru/grufault.c: call find_vma with the mmap_sem held

Performing vma lookups without taking the mm->mmap_sem is asking for
trouble.  While doing the search, the vma in question can be modified or
even removed before returning to the caller.  Take the lock in order to
avoid races while iterating through the vmacache and/or rbtree.

Signed-off-by: Jonathan Gonzalez V <zeus@gnu.org>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Dimitri Sivanich <sivanich@sgi.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -266,6 +266,7 @@ static int gru_vtop(struct gru_thread_st
 	unsigned long paddr;
 	int ret, ps;
 
+	down_write(&mm->mmap_sem);
 	vma = find_vma(mm, vaddr);
 	if (!vma)
 		goto inval;
@@ -277,22 +278,26 @@ static int gru_vtop(struct gru_thread_st
 	rmb();	/* Must/check ms_range_active before loading PTEs */
 	ret = atomic_pte_lookup(vma, vaddr, write, &paddr, &ps);
 	if (ret) {
-		if (atomic)
-			goto upm;
+		if (atomic) {
+			up_write(&mm->mmap_sem);
+			return VTOP_RETRY;
+		}
 		if (non_atomic_pte_lookup(vma, vaddr, write, &paddr, &ps))
 			goto inval;
 	}
 	if (is_gru_paddr(paddr))
 		goto inval;
+
+	up_write(&mm->mmap_sem);
+
 	paddr = paddr & ~((1UL << ps) - 1);
 	*gpa = uv_soc_phys_ram_to_gpa(paddr);
 	*pageshift = ps;
 	return VTOP_SUCCESS;
 
 inval:
+	up_write(&mm->mmap_sem);
 	return VTOP_INVALID;
-upm:
-	return VTOP_RETRY;
 }
 
 
_

Patches currently in -mm which might be from zeus@gnu.org are

drm-exynos-call-find_vma-with-the-mmap_sem-held.patch

