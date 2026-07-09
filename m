Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B821D6195
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 22:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783635998; cv=none; b=CIt+pvDmxQ8MO+w+4bSid3UtvqMY8dtBHOYA8ajfkG/0PhRbTx/iki81vCDsjEv2SdpxohkG/idhlcYF8MDDYrocARkNLilLAJyfbtn4WryU7FBgi116XUppVvWK1us1nEtRSJksXwAm67Hg7VDeB+nE9UnNKYCREbDtW8VCU74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783635998; c=relaxed/simple;
	bh=E4sFzOBdvq/4q7QbXGjIano16fGTbE6IgUnv5SrOi/8=;
	h=Date:To:From:Subject:Message-Id; b=CcnQGQhFl3WI2ZP8hmJFfTCIqJy88iXh0AiUg5UilO3DxKQF3tqjROG1W3JvhJ0rpwT0s4RRfhm2721PdlrFO/mQLB4Y7VrtMNgQSKu5JQJv0o8KK2M4ziMJXz47OthOQCAbxQsVMrcR01BwpdyBrbq+vxYjKKOnL8o6bDDnAso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=srR+X2Zw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="srR+X2Zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2711F000E9;
	Thu,  9 Jul 2026 22:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783635997;
	bh=eACPQFAHYOQKsMTNMhbhi4uOr16bW1Xw4CeAomMrNiQ=;
	h=Date:To:From:Subject;
	b=srR+X2ZwT5msRyKoEC+dQyIl4isMmxq1+AowodZuYmQ/pb5eVmWfPnO/zGeb0Ij/8
	 V18XCA4m+keTDkM6Lk4ixxHQ7jd8iyQKNmt884iDPXOLGX/W9iwBIuyopV4a0kPoeG
	 Y6rUGVAm78AdrOv/jb+7W24Gkfj3sRl+wUcDCYzU=
Date: Thu, 09 Jul 2026 15:26:36 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-initialize-the-addr-only-once-in-collect_procs_ksm.patch added to mm-new branch
Message-Id: <20260709222637.4D2711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: Initialize the addr only once in collect_procs_ksm
has been added to the -mm mm-new branch.  Its filename is
     mm-ksm-initialize-the-addr-only-once-in-collect_procs_ksm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-initialize-the-addr-only-once-in-collect_procs_ksm.patch

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
Subject: mm/ksm: Initialize the addr only once in collect_procs_ksm
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

ksm-add-linear_page_index-into-ksm_rmap_item.patch
ksm-optimize-rmap_walk_ksm-by-passing-a-suitablepage-index.patch
ksm-add-mremap-selftests-for-ksm_rmap_walk.patch
mm-ksm-initialize-the-addr-only-once-in-collect_procs_ksm.patch
ksm-use-precise-linear_page_index-instead-of-the-whole-address-space.patch

