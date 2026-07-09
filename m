Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0781D6195
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 22:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783636000; cv=none; b=q6P9lGOo65rE375419s2cKmRMmZqy4KFsCAItLccWHI65//qo5t1EhLranKg5bT5w6qpM4MW0Racr2xeisvY1OpGcrbE2jNgtcn6W1yC+lcsjewiKU5Q0MHakPtCxFuf09aYTn93xapSURKVxTgqew/lfGxzd3mU5R4chN+7PiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783636000; c=relaxed/simple;
	bh=n8x55Y6GoUIhj1WjAiP45+G9tUZugDKodusScoALqT0=;
	h=Date:To:From:Subject:Message-Id; b=ej/AurotJxp+/n0/SrAwrfVAH608Fiwuap3TO4Dkt2OA/HMadKG773jVhwW5hRoI5e747vmy1Zrd0kxarOxzaPlNPz7SD6MP2EuI7t7P8bQcN69Jqht3mdVSLhpYiAn23jpUkrOae9xR7AC/UjWujy8ZtSa44bV2jA7tLj1QJ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=simywHF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="simywHF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F361F000E9;
	Thu,  9 Jul 2026 22:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783635999;
	bh=NP6xise93ordlQAWBTGRC7NrMyccGjS2+GWUNe3KBAM=;
	h=Date:To:From:Subject;
	b=simywHF51HqdDwTt4tjqtALngGq36rMQ2iCnAR0unM9Em12jHkWVAMJyoQow5LLu9
	 GIje4hN24HR/LXheYV77D9crmPCBfzkvwdO66X/bAciIZnKqd3QY/KvCZ+aa85pyrY
	 rCu70oCKp/V6Fba4YjeWh9FYi89M2ghpf4W5XIBA=
Date: Thu, 09 Jul 2026 15:26:38 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-use-precise-linear_page_index-instead-of-the-whole-address-space.patch added to mm-new branch
Message-Id: <20260709222639.38F361F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: Use precise linear_page_index instead of the whole address space
has been added to the -mm mm-new branch.  Its filename is
     ksm-use-precise-linear_page_index-instead-of-the-whole-address-space.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-use-precise-linear_page_index-instead-of-the-whole-address-space.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: Use precise linear_page_index instead of the whole address space
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

ksm-add-linear_page_index-into-ksm_rmap_item.patch
ksm-optimize-rmap_walk_ksm-by-passing-a-suitablepage-index.patch
ksm-add-mremap-selftests-for-ksm_rmap_walk.patch
mm-ksm-initialize-the-addr-only-once-in-collect_procs_ksm.patch
ksm-use-precise-linear_page_index-instead-of-the-whole-address-space.patch

