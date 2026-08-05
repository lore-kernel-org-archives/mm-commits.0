Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EF33BED18
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896692; cv=none; b=mAHNcfutOwKSZ6yLh7IAHJym06PUuRJGwv2DR/VoajSQoErWsyW87baoo0bFhGznGp2oiqtGAzT1idJ59pwskMKmB0PTL3tDMJxpSuhk+j3BGnaGLdsf78YxT5t/5MABVmbc82YT92DHuN6NcygOo+bnvouR9T4hwadtPxtHMPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896692; c=relaxed/simple;
	bh=pAbE/gYV4f8nZwEFtKB16JmBVAdymQhd0n3vAAUmxtA=;
	h=Date:To:From:Subject:Message-Id; b=WXiVVjphWVzuw41TQ7ZiTd50JuqwllFKlxg/XK0YumjmMCyEGvtDxRqSsTXQOfKITtJdxmX8wyRxls6nmI3t2tmOuTELufCLeI3Vj0UcqCCduFqYwdB5ITbiTxombRoBOHryvxzpmV2Al6xxCOKHrpgaMJ2N26FWmSPPt97zOTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=woVTx1TS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="woVTx1TS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0461F00A3A;
	Wed,  5 Aug 2026 02:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896690;
	bh=dLsQjXOTpMZmwDDT9Jh5PZF4m0NJwaWRFg1bOVZBpZE=;
	h=Date:To:From:Subject;
	b=woVTx1TS5ZRoh7D5d9/NxeD5I5sOciqPbb6rkWgdNQoPqloniSP7IpN0hZxWgSFrn
	 uwgkGk2gs69h/txeGemjJL2BhfvtVFLot0LQ9gLheZxPDlx49RShBcZVze9ux5pP12
	 VrlGj4m0IEhXB5dgzk2S6Pr3y/GD14CfTrfD4wKg=
Date: Tue, 04 Aug 2026 19:24:50 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-use-precise-linear_page_index-instead-of-the-whole-address-space.patch removed from -mm tree
Message-Id: <20260805022450.BE0461F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm: use precise linear_page_index instead of the whole address space
has been removed from the -mm tree.  Its filename was
     ksm-use-precise-linear_page_index-instead-of-the-whole-address-space.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: use precise linear_page_index instead of the whole address space
Date: Thu, 9 Jul 2026 17:33:12 +0800 (CST)

Since we now have linear_page_index available that we can use here,
allowing for optimizing the RMAP walk, we can also use it to locate more
precisely all related-processes when error hits the KSM page, which will
decrease a lot of invalid iterations.

Link: https://lore.kernel.org/20260709173312403qgj1Af6pRkFMDSsmc19sM@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~ksm-use-precise-linear_page_index-instead-of-the-whole-address-space
+++ a/mm/ksm.c
@@ -3290,12 +3290,13 @@ void collect_procs_ksm(const struct foli
 		for_each_process(tsk) {
 			struct anon_vma_chain *vmac;
 			const unsigned long addr = rmap_item->address & PAGE_MASK;
+			const unsigned long index = rmap_item->linear_page_index;
 			struct task_struct *t =
 				task_early_kill(tsk, force_early);
 			if (!t)
 				continue;
-			anon_vma_interval_tree_foreach(vmac, &av->rb_root, 0,
-						       ULONG_MAX)
+			anon_vma_interval_tree_foreach(vmac, &av->rb_root, index,
+						       index)
 			{
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

mm-mm_sloth-add-a-helper-function-mm_slot_remove.patch
mm-mm_sloth-add-comments-for-mm_slot_lookup-insert.patch

