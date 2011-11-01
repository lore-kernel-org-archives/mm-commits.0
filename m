From: akpm@linux-foundation.org
Subject: [merged] mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:11:06 -0700
Message-ID: <201111012111.pA1LB6mx017596@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29185 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:11:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: consul.kautuk@gmail.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: eliminate the ret variable from mm_take_all_locks()
has been removed from the -mm tree.  Its filename was
     mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: mm/mmap.c: eliminate the ret variable from mm_take_all_locks()

The ret variable is really not needed in mm_take_all_locks().

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks
+++ a/mm/mmap.c
@@ -2558,7 +2558,6 @@ int mm_take_all_locks(struct mm_struct *
 {
 	struct vm_area_struct *vma;
 	struct anon_vma_chain *avc;
-	int ret = -EINTR;
 
 	BUG_ON(down_read_trylock(&mm->mmap_sem));
 
@@ -2579,13 +2578,11 @@ int mm_take_all_locks(struct mm_struct *
 				vm_lock_anon_vma(mm, avc->anon_vma);
 	}
 
-	ret = 0;
+	return 0;
 
 out_unlock:
-	if (ret)
-		mm_drop_all_locks(mm);
