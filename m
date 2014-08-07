From: akpm@linux-foundation.org
Subject: +
 m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch added
 to -mm tree
Date: Thu, 07 Aug 2014 15:49:55 -0700
Message-ID: <53e40293.jhSWx+EQKYBCo0S/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:59885 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaHGWt4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 18:49:56 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so875147oig.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 15:49:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidlohr@hp.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2
has been added to the -mm tree.  Its filename is
     m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch
shm-make-exit_shm-work-proportional-to-task-activity.patch
shm-allow-exit_shm-in-parallel-if-only-marking-orphans.patch
shm-remove-unneeded-extern-for-function.patch
linux-next.patch

