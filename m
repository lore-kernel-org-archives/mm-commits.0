Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A794B3BED75
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896690; cv=none; b=W0u0GAX/+njQjhnYxuFF3wFAcGn6wDk9xrImFhYnKSnW3JLl0mfyxOX250CZ1rEA8jTdoMUxF04VyDKhS5xyeOjzxyTwzsn3O28CVtXbhvr799v8mw516h32Vmv1+G8Gpb5ALOPdOZLhhMM/qwwHSg1ob8QKaroPoMBmBI3N+mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896690; c=relaxed/simple;
	bh=yjoP7WdcTTL0ES9qyqCXQjsqWug4XC30yOR+laWa5es=;
	h=Date:To:From:Subject:Message-Id; b=cmrTMZxwn/qbU0Oc1NuOpEuVvl4WvX6wEJudh3In4hzxSidhdO5BGn4MkdBs3haw+WBCM6YmIL6y915cSf/f9n2w9pVbnaxm0QEstxfS53QnOGb4BIVI040j5u3Lc4heUijAlK8sgATduG+dUehWXQ8iLrinepSw6V8aPAoMURY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qw0FJXxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qw0FJXxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DDD1F000E9;
	Wed,  5 Aug 2026 02:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896689;
	bh=rV6Q1ISfuTtGUVh1Ej4JUvUvu7618tY5UGooF9CA1ug=;
	h=Date:To:From:Subject;
	b=qw0FJXxC6JQtjI9KWjKC4RcJFJOwse+YnWnFrS3o4+4NRrbEy9kvc0lpCflTEkwnm
	 9KsGZ+OjyyYamWsPIoWgwNOWGVO/Vau+jLLaPTuvEKPY365gSHgDNgq7aC7TunwWCE
	 QGF7MhISUaCS9rDbQ4vuSazFGEuQ/iIm6ZwRzczU=
Date: Tue, 04 Aug 2026 19:24:48 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-initialize-the-addr-only-once-in-collect_procs_ksm.patch removed from -mm tree
Message-Id: <20260805022449.70DDD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: initialize the addr only once in collect_procs_ksm
has been removed from the -mm tree.  Its filename was
     mm-ksm-initialize-the-addr-only-once-in-collect_procs_ksm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: mm/ksm: initialize the addr only once in collect_procs_ksm
Date: Thu, 9 Jul 2026 17:32:12 +0800 (CST)

Patch series "KSM: use linear_page_index in collect_procs_ksm()", v2.

In collect_procs_ksm() which is used to collect processes when the error
hit an ksm page, there is the same issue with rmap_walk_ksm (see the
previous discussion at [1]).  So we apply the similar logic changes to the
collect_procs_ksm().

The patch [1/2] move the initializaion of addr from the position inside
loop to the position before the loop, since the variable will not change
in the loop.

The patch [2/2] optimize collect_procs_ksm by passing a suitable page
offset range to the anon_vma_interval_tree_foreach loop to reduce
ineffective checks.


This patch (of 2):

Similar to 318d87b8fa7 ("ksm: initialize the addr only once in
rmap_walk_ksm"), only initialize the addr once in rmap_walk_ksm because
the addr variable doesn't change across iterations.

Link: https://lore.kernel.org/20260709173212190rZdwynySRyLr9EtPuXBRU@zte.com.cn
Link: https://lore.kernel.org/all/20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn/ [1]
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-initialize-the-addr-only-once-in-collect_procs_ksm
+++ a/mm/ksm.c
@@ -3289,7 +3289,7 @@ void collect_procs_ksm(const struct foli
 		rcu_read_lock();
 		for_each_process(tsk) {
 			struct anon_vma_chain *vmac;
-			unsigned long addr;
+			const unsigned long addr = rmap_item->address & PAGE_MASK;
 			struct task_struct *t =
 				task_early_kill(tsk, force_early);
 			if (!t)
@@ -3299,7 +3299,6 @@ void collect_procs_ksm(const struct foli
 			{
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
-					addr = rmap_item->address & PAGE_MASK;
 					add_to_kill_ksm(t, page, vma, to_kill,
 							addr);
 				}
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

mm-mm_sloth-add-a-helper-function-mm_slot_remove.patch
mm-mm_sloth-add-comments-for-mm_slot_lookup-insert.patch

