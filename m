Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5796F2F9D82
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 18:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559343; cv=none; b=HObd/Q2Ehmra83XMxuc9DITV94aNRfUJQK9cyY4ldM7E3LK1e87I7LfPgKFO4W7Z7vG3fSLzdDZ36EQH7l3bmnSwpMDPKNz3jawTPqwCRuXqn5jeWkZ2bAoO83jx9NshYCqDhNfv1nC9D+RmcPGbVmfyMq7Dyg86t4S5UU27XZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559343; c=relaxed/simple;
	bh=ZkA5mDwEZF6STGptjJEN0rsMZzBn4o2iSGaDm5BqG0o=;
	h=Date:To:From:Subject:Message-Id; b=d5sya0sduFO4ynYB2ddoB7CM/NYmlUofjBbvPjr0qqETlyvj0wAK8Jo7Nwix2ZAk9W5lLlGeutetj1BNv/Rmzg4lOCLSwXrJ3ls32CoZDv25FIMAAqTu4DMz5u3q9gvdPxzjk7ts0I3YLKqxbuZu52b2nUKYxUU8uL5ff5srGX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nb9S5Woe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nb9S5Woe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06AC1F000E9;
	Wed, 12 Aug 2026 18:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786559341;
	bh=FEbpDdDTHJC07PnMNSdmixI4bcNVy2+nu0Det4JrdaA=;
	h=Date:To:From:Subject;
	b=nb9S5WoeVvVxYyjhGPPeOXby9O8bQs4ZzcQ7y2AwDELlxos8BPGEQTSDrAjY37ZYJ
	 xRgWik4mcEGyLVg4t+QCadDvuOl6Qxl9pZalYguU5NU/wsHnL8Yl/lBA0pTvoj1BlI
	 HVwPFJ0Ik8JxCqSafXUGF9yGizPCucYQZXm7jTs0=
Date: Wed, 12 Aug 2026 11:29:01 -0700
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,hui.zhu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-young-counter-undercount-for-large-folios.patch added to mm-unstable branch
Message-Id: <20260812182901.C06AC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: Fix young counter undercount for large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-fix-young-counter-undercount-for-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-young-counter-undercount-for-large-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Hui Zhu" <hui.zhu@linux.dev>
Subject: mm/mglru: Fix young counter undercount for large folios
Date: Wed, 12 Aug 2026 14:59:33 +0800


In lru_gen_look_around(), the young counter tracks the number of young
PTEs.  The original folio's contribution is represented by the initial
value of young: test_and_clear_young_ptes_notify() is called on it at
function entry, and the function returns early if it is not young.  In
the subsequent loop, the original folio is skipped (its accessed bits
were already cleared), so it is not double-counted.

However, young is initialized to 1 regardless of the folio size.  When
the original folio is a large folio with nr PTEs, its young count is
underestimated by nr - 1.  This inconsistency can cause
suitable_to_scan() to return false, preventing the PMD from being added
to the bloom filter and reducing aging accuracy for mTHP workloads.

Initialize young to nr so the original folio is accounted the same way
as other young folios in the loop (young += nr).

Link: https://lore.kernel.org/20260812065933.103627-1-hui.zhu@linux.dev
Fixes: 56e5b60b2114 ("mm: support batched checking of the young flag for MGLRU")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-fix-young-counter-undercount-for-large-folios
+++ a/mm/vmscan.c
@@ -4261,7 +4261,7 @@ bool lru_gen_look_around(struct page_vma
 	unsigned long end;
 	struct lru_gen_mm_walk *walk;
 	struct folio *last = NULL;
-	int young = 1;
+	int young = nr;
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
_

Patches currently in -mm which might be from hui.zhu@linux.dev are

mm-mglru-fix-young-counter-undercount-for-large-folios.patch

