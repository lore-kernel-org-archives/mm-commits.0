From: akpm@linux-foundation.org
Subject: [folded-merged]
 m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch
 removed from -mm tree
Date: Thu, 09 Oct 2014 13:46:40 -0700
Message-ID: <5436f430.jbkBxwgPLlnvD6bH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaJIUqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidlohr@hp.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2
has been removed from the -mm tree.  Its filename was
     m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch

This patch was dropped because it was folded into m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2

So I wasn't sure if we *really* required to serialize the entire address
space for this operation. However, looking at other archs, sh seems to
do exactly that, so I guess, at least for safety, we should hold the
lock until we exit the function. I guess taking it as a reader enables
us to guarantee it won't be removed underneath us. So here's v2.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/sys_m68k.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN arch/m68k/kernel/sys_m68k.c~m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2 arch/m68k/kernel/sys_m68k.c
--- a/arch/m68k/kernel/sys_m68k.c~m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2
+++ a/arch/m68k/kernel/sys_m68k.c
@@ -389,7 +389,6 @@ sys_cacheflush (unsigned long addr, int
 			goto out;
 	} else {
 		struct vm_area_struct *vma;
-		bool invalid;
 
 		/* Check for overflow.  */
 		if (addr + len < addr)
@@ -402,10 +401,8 @@ sys_cacheflush (unsigned long addr, int
 		ret = -EINVAL;
 		down_read(&current->mm->mmap_sem);
 		vma = find_vma(current->mm, addr);
-		invalid = !vma || addr < vma->vm_start || addr + len > vma->vm_end;
-		up_read(&current->mm->mmap_sem);
-		if (invalid)
-			goto out;
+		if (!vma || addr < vma->vm_start || addr + len > vma->vm_end)
+			goto out_unlock;
 	}
 
 	if (CPU_IS_020_OR_030) {
@@ -435,7 +432,7 @@ sys_cacheflush (unsigned long addr, int
 			__asm__ __volatile__ ("movec %0, %%cacr" : : "r" (cacr));
 		}
 		ret = 0;
-		goto out;
+		goto out_unlock;
 	} else {
 	    /*
 	     * 040 or 060: don't blindly trust 'scope', someone could
@@ -452,6 +449,8 @@ sys_cacheflush (unsigned long addr, int
 		ret = cache_flush_060 (addr, scope, cache, len);
 	    }
 	}
+out_unlock:
+	up_read(&current->mm->mmap_sem);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from davidlohr@hp.com are

m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch

