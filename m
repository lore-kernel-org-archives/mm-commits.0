From: akpm@linux-foundation.org
Subject: + mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks.patch added to -mm tree
Date: Wed, 14 Sep 2011 13:44:08 -0700
Message-ID: <201109142044.p8EKi8Ad012716@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143Ab1INUoL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2011 16:44:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com


The patch titled
     mm/mmap.c: eliminate the ret variable from mm_take_all_locks()
has been added to the -mm tree.  Its filename is
     mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/mmap.c: eliminate the ret variable from mm_take_all_locks()
From: Kautuk Consul <consul.kautuk@gmail.com>

The ret variable is really not needed in mm_take_all_locks().

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/mmap.c~trivial-eliminate-the-ret-variable-from-mm_take_all_locks mm/mmap.c
--- a/mm/mmap.c~trivial-eliminate-the-ret-variable-from-mm_take_all_locks
+++ a/mm/mmap.c
@@ -2558,7 +2558,6 @@ int mm_take_all_locks(struct mm_struct *
 {
 	struct vm_area_struct *vma;
 	struct anon_vma_chain *avc;
-	int ret = -EINTR;
 
 	BUG_ON(down_read_trylock(&mm->mmap_sem));
 
@@ -2579,13 +2578,12 @@ int mm_take_all_locks(struct mm_struct *
 				vm_lock_anon_vma(mm, avc->anon_vma);
 	}
 
-	ret = 0;
+	return 0;
 
 out_unlock:
-	if (ret)
-		mm_drop_all_locks(mm);
+	mm_drop_all_locks(mm);
 
-	return ret;
+	return -EINTR;
 }
 
 static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
_

Patches currently in -mm which might be from consul.kautuk@gmail.com are

mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch

