Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058459;
	b=k7t+thVTlrOmjRI4q0kRMp1gEV2atgTcDqyWA2Ijavj9FHI9/NiPV98u+OaLucSduqP8
	 kQMxLjpCGgGnVnJz6BnjMlmZQ7moCuuOO1iSyMkwe10mMuVPqfU7HM3RxW2KgsdPkTDrv
	 bPU/BnzBQl0wWfRGV36osveKtWP7ryjOEzyXcjp9wrmABfFpm+tVbUgJW96ZgwYpm6NQy
	 5zilwLAT+PhltXAsSciVSRuigf8BnZ1MvkD0GxFJb9aNeOrqkyXDUjAb8INSjBJkqdmis
	 nbLWzM6zougJFmbMbqN5Z2w9AVqNUdkeMsqs8exbctlbTs5/156AFKasmWkZ4TddNQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058459;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=rmDdWseqj5cKGJ0WA3TtYF8iR0TeKDpMLIjDI6xUm5s=;
	b=HC33iIVa7wurTA5h4/z4AUZ8cnexTLV4Eo/IeObiJjJhS+5BjD7PgHUj1Mg+q6D/ZNOl
	 xWUZtpVG9ljN1yguRj4iVmq9Q26+2YsU1m5zCSBSPqSLmb3LpMjHPE2xat3C+Qm/o7RMm
	 9F23vyOUsbjLUQO0dyYZ+P1Ay7jxGyaEgGJOcDm+cAL8UpFYzUaAfiniIba0GXI3VZrLb
	 W41cfKpmaXNjZ9ua4FjEwi7pJJ9uoYzaDrqZ4EpkWZ6/ccS2z18j1YszLtO20iibvyOI6
	 57CZNkDY1GbCfiYtHusj9+TM7/IeSjeRU37sOB7UvKn5ZnDSsgGh++v6vsEyPQJfdMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="kX/W7/0J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9149606A33E
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 03:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kX/W7/0J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EA11F000C5;
	Thu, 19 Nov 2026 03:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795058459;
	bh=rmDdWseqj5cKGJ0WA3TtYF8iR0TeKDpMLIjDI6xUm5s=;
	h=Date:To:From:Subject;
	b=kX/W7/0JaQrwD3I9/akqjTpFW4cYWMT6vr9HaWTnqQoryfw6p+V8I6yvoHg9JOLdM
	 xroHsG6q9kf1bGlNkm7uAGmEPrLkIDN439TJet+LlGOmmlpI0xAV2alu9IWgNtuJZt
	 aINxYAfOMgfkJaOBcS6Lk4U1hjDGvr5XC3l0c4nY=
Date: Wed, 18 Nov 2026 19:20:58 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	shakeel.butt@linux.dev,qi.zheng@linux.dev,mhocko@kernel.org,
	kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,
	baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-use-pte_table_clamped_end-helper-to-calculate-the-end.patch added to mm-new branch
Message-Id: <20261119032059.54EA11F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: mglru: use pte_table_clamped_end() helper to calculate the end
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-use-pte_table_clamped_end-helper-to-calculate-the-end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-use-pte_table_clamped_end-helper-to-calculate-the-end.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: mglru: use pte_table_clamped_end() helper to calculate the end
Date: Thu, 12 Nov 2026 19:12:39 +0800

Use pte_table_clamped_end() to clamp the range to the PTE table and VMA
boundaries when batch-checking young flags, making the code more readable.

No functional changes intended.

Link: https://lore.kernel.org/b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-use-pte_table_clamped_end-helper-to-calculate-the-end
+++ a/mm/vmscan.c
@@ -4343,7 +4343,7 @@ bool lru_gen_look_around(struct page_vma
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
 
 	start = max(addr & PMD_MASK, vma->vm_start);
-	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
+	end = pte_table_clamped_end(addr, vma->vm_end);
 
 	if (end - start == PAGE_SIZE)
 		return true;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-mglru-use-pte_table_clamped_end-helper-to-calculate-the-end.patch

