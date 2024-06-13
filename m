Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C9212EBF3;
	Thu, 13 Jun 2024 20:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309947; cv=none; b=tukD9Kqtt6Du0xiuyl2krAOyjUlVUf59qXrvQL3+CGMW/CXdTRV/UgS+JyVIWAr9pWO2TFUTnlWmeZKDsOFnYimcUFJol9kyZ9GFBMPfjralulq3TYH4WhnS0a2MUb/L8fuDWkqRNNQkw/7HhgKBtaAhn8sC9eRYj1xL9t9WuNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309947; c=relaxed/simple;
	bh=CJD/qsrIVAqenAItFnfsKYHk707iyt7Yr4lXqxz2M9c=;
	h=Date:To:From:Subject:Message-Id; b=DxASHFh6HnSyeT0YTAD/tvtbxwPnePtprjyzAWkFmEK32qfJuLtlml2v5GMrp4i/kwKeSZDYjo57vstQ4VAWSWeOjg8YvGnqZs1ILZA/0nAoq/N7FcOm4EirGqDdfSwGbQwnr/H6/WimjxNhpJQWwiFtU2B0C1ig7kgrT/dmvtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V5a7DW/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V5a7DW/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E4CC32789;
	Thu, 13 Jun 2024 20:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718309946;
	bh=CJD/qsrIVAqenAItFnfsKYHk707iyt7Yr4lXqxz2M9c=;
	h=Date:To:From:Subject:From;
	b=V5a7DW/Mizax2fxW6jsusA6YbiuVsghfVqVyYi5qklsEcrt4F2WuNCBuOXBq1LlFO
	 dHSV4cxfOXCllM2QNwsIW+cUyR8dTF1Zq8UPX85eMdp+uIA2lkgOIh7Rj9oYekry19
	 zrvwOcJN6aHSVjG3MI3d+SC+yHtONGQay969qwuw=
Date: Thu, 13 Jun 2024 13:19:06 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,tglx@linutronix.de,stable@vger.kernel.org,lstoakes@gmail.com,hch@infradead.org,hailong.liu@oppo.com,bhe@redhat.com,zhaoyang.huang@unisoc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-incorrect-vbq-reference-in-purge_fragmented_block.patch added to mm-hotfixes-unstable branch
Message-Id: <20240613201906.A2E4CC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix incorrect vbq reference in purge_fragmented_block
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-incorrect-vbq-reference-in-purge_fragmented_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-incorrect-vbq-reference-in-purge_fragmented_block.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: fix incorrect vbq reference in purge_fragmented_block
Date: Fri, 7 Jun 2024 10:31:16 +0800

vmalloc area runs out in our ARM64 system during an erofs test as
vm_map_ram failed[1].  By following the debug log, we find that
vm_map_ram()->vb_alloc() will allocate new vb->va which corresponding to
4MB vmalloc area as list_for_each_entry_rcu returns immediately when
vbq->free->next points to vbq->free.  That is to say, 65536 times of page
fault after the list's broken will run out of the whole vmalloc area. 
This should be introduced by one vbq->free->next point to vbq->free which
makes list_for_each_entry_rcu can not iterate the list and find the BUG.

[1]
PID: 1        TASK: ffffff80802b4e00  CPU: 6    COMMAND: "init"
 #0 [ffffffc08006afe0] __switch_to at ffffffc08111d5cc
 #1 [ffffffc08006b040] __schedule at ffffffc08111dde0
 #2 [ffffffc08006b0a0] schedule at ffffffc08111e294
 #3 [ffffffc08006b0d0] schedule_preempt_disabled at ffffffc08111e3f0
 #4 [ffffffc08006b140] __mutex_lock at ffffffc08112068c
 #5 [ffffffc08006b180] __mutex_lock_slowpath at ffffffc08111f8f8
 #6 [ffffffc08006b1a0] mutex_lock at ffffffc08111f834
 #7 [ffffffc08006b1d0] reclaim_and_purge_vmap_areas at ffffffc0803ebc3c
 #8 [ffffffc08006b290] alloc_vmap_area at ffffffc0803e83fc
 #9 [ffffffc08006b300] vm_map_ram at ffffffc0803e78c0

For detailed descri[ption of the broken list, please see
https://lore.kernel.org/all/20240531024820.5507-1-hailong.liu@oppo.com/

Link: https://lkml.kernel.org/r/20240607023116.1720640-1-zhaoyang.huang@unisoc.com
Fixes: fc1e0d980037 ("mm/vmalloc: prevent stale TLBs in fully utilized blocks")
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Suggested-by: Hailong.Liu <hailong.liu@oppo.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~mm-fix-incorrect-vbq-reference-in-purge_fragmented_block
+++ a/mm/vmalloc.c
@@ -2498,6 +2498,7 @@ struct vmap_block {
 	struct list_head free_list;
 	struct rcu_head rcu_head;
 	struct list_head purge;
+	unsigned int cpu;
 };
 
 /* Queue of free and dirty vmap blocks, for allocation and flushing purposes */
@@ -2625,8 +2626,15 @@ static void *new_vmap_block(unsigned int
 		free_vmap_area(va);
 		return ERR_PTR(err);
 	}
-
-	vbq = raw_cpu_ptr(&vmap_block_queue);
+	/*
+	 * list_add_tail_rcu could happened in another core
+	 * rather than vb->cpu due to task migration, which
+	 * is safe as list_add_tail_rcu will ensure the list's
+	 * integrity together with list_for_each_rcu from read
+	 * side.
+	 */
+	vb->cpu = raw_smp_processor_id();
+	vbq = per_cpu_ptr(&vmap_block_queue, vb->cpu);
 	spin_lock(&vbq->lock);
 	list_add_tail_rcu(&vb->free_list, &vbq->free);
 	spin_unlock(&vbq->lock);
@@ -2654,9 +2662,10 @@ static void free_vmap_block(struct vmap_
 }
 
 static bool purge_fragmented_block(struct vmap_block *vb,
-		struct vmap_block_queue *vbq, struct list_head *purge_list,
-		bool force_purge)
+		struct list_head *purge_list, bool force_purge)
 {
+	struct vmap_block_queue *vbq = &per_cpu(vmap_block_queue, vb->cpu);
+
 	if (vb->free + vb->dirty != VMAP_BBMAP_BITS ||
 	    vb->dirty == VMAP_BBMAP_BITS)
 		return false;
@@ -2704,7 +2713,7 @@ static void purge_fragmented_blocks(int
 			continue;
 
 		spin_lock(&vb->lock);
-		purge_fragmented_block(vb, vbq, &purge, true);
+		purge_fragmented_block(vb, &purge, true);
 		spin_unlock(&vb->lock);
 	}
 	rcu_read_unlock();
@@ -2841,7 +2850,7 @@ static void _vm_unmap_aliases(unsigned l
 			 * not purgeable, check whether there is dirty
 			 * space to be flushed.
 			 */
-			if (!purge_fragmented_block(vb, vbq, &purge_list, false) &&
+			if (!purge_fragmented_block(vb, &purge_list, false) &&
 			    vb->dirty_max && vb->dirty != VMAP_BBMAP_BITS) {
 				unsigned long va_start = vb->va->va_start;
 				unsigned long s, e;
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-fix-incorrect-vbq-reference-in-purge_fragmented_block.patch
mm-optimization-on-page-allocation-when-cma-enabled.patch

