From: akpm@linux-foundation.org
Subject: +
 driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch added
 to -mm tree
Date: Mon, 21 Apr 2014 14:20:45 -0700
Message-ID: <53558bad.jOTdpEXdyKvTbCCR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbaDUVUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 17:20:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sivanich@sgi.com, davidlohr@hp.com, zeus@gnu.org

Subject: + driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch added to -mm tree
To: zeus@gnu.org,davidlohr@hp.com,sivanich@sgi.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 14:20:45 -0700


The patch titled
     Subject: drivers,sgi-gru/grufault.c: call find_vma with the mmap_sem held
has been added to the -mm tree.  Its filename is
     driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

driverssgi-gru-grufaultc-call-find_vma-with-the-mmap_sem-held.patch
drm-exynos-call-find_vma-with-the-mmap_sem-held.patch

