Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F6748A2A1;
	Tue,  1 Sep 2026 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282649; cv=none; b=FmhT3W2bpkVNbwiVY85wyL24hRLjgOAsXqOMbGzhGN/+kQhtVe3cdKLUa5nG7HUcHR9VvaYQMNFyuRDaHkPH1/9tqC/wj76xQA0pZnEOnotluWVFqsPeol3ADyydqggx2iNlRM+kbYHf3zlPLduWnqMx8mjUHsWI9Fer7WT5NmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282649; c=relaxed/simple;
	bh=bG0SJpd3ZPsk+nxrxdBe/YttPnaTHRCytJn4IXEVL8A=;
	h=Date:To:From:Subject:Message-Id; b=LWJt7tfSpw3g/4ASWg+54KNj82B0QITOnv8c5vtwBDtD9EFEpRmjjeOg6R7PGI1Yv0h8WjVaovcYIVbBN4Kibm6jKZGTYyZn5YKAcNjrAxm5XgvTR4ZDcIM3KBIsgjtHbDiIGgzrjucb1+SVgl4uwROMytM/h+p5PoKkpiN9iAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f4+PUwAv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f4+PUwAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425BE1F000E9;
	Tue,  1 Sep 2026 17:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788282648;
	bh=BM950h1WUdJGmX6/PQHW24C2sGqKTdv7962Ib7NlWKg=;
	h=Date:To:From:Subject;
	b=f4+PUwAvszCXV4Jtzw4Zt8vxZf6Mzyv0eQPbb9FDWQQtmkUzxEZUzH/FMDM2Juq2E
	 swHaou2QzvCSohz0FhkV1iH+8xrzNte3uA2nB3HtRQVuJr0xwWB8YShPUefA7OS4Up
	 cgGqHP2CdCdddMqx5PI0u8pZ122TXqiIK6EkfsdI=
Date: Tue, 01 Sep 2026 10:10:47 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch added to mm-new branch
Message-Id: <20260901171048.425BE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: handle extreme memory state in get_in_active_mem_bp()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: handle extreme memory state in get_in_active_mem_bp()
Date: Tue, 1 Sep 2026 06:18:49 -0700

damos_get_in_active_mem_bp() uses the sum of the active and inactive
memory amount as a denominator.  In an extreme and unlikely environment,
active and inactive memory might be zero.  In this case, hence, it results
in a divide by zero problem.  Avoid it by changing the denominator to one
if it is zero, before it is being used.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-9-sj@kernel.org
Link: https://lore.kernel.org/20260721034756.147011-1-sj@kernel.org [1]
Fixes: 4835e2871321 ("mm/damon/core: introduce [in]active memory ratio damos quota goal metric")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp
+++ a/mm/damon/core.c
@@ -3006,7 +3006,7 @@ static unsigned int damos_get_in_active_
 		global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_FILE);
 	inactive = global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_ANON) +
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
-	total = active + inactive;
+	total = max(active + inactive, 1);
 	if (active_ratio)
 		return mult_frac(active, 10000, total);
 	return mult_frac(inactive, 10000, total);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch

