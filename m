Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0058F3B6C13
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439029; cv=none; b=ENVrV6Qy5i0YjAmJm2aTu+eTTXdPcNwkDxWeh/tFsAGLUQrYXNY8P6cOzTag99PJs7qz0/cF6NRK+tOkCoxSaEIsFRIiUiPIjIqqs60BWPN96mWsV0KTJuXBHINhtghQ486yzHRDlSzPk81ZtAcZiCKi2zbVuTTusEJQO6LgWfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439029; c=relaxed/simple;
	bh=s98xDuohFq6e2OKn9h6VaSyoJ+Ki9GbpIntWR9yGOWQ=;
	h=Date:To:From:Subject:Message-Id; b=u1+5C26+zzK7pK4cDXlDRWsVHycADDeCGWVx1vEKEmkdpo8nfA22ho7pHA7I0/AsCn496+6/0L3RbPworG+nNCF6HBN14DMdXD3PWctv6vAzixPMxd7rlzP0XSKp/jIj6SvE2Vo54IY+qMjGLyT4z+XZnyaMpI/GUougQorX7OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qpW/Sqfr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qpW/Sqfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84221F00893;
	Tue,  2 Jun 2026 22:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439027;
	bh=Px8/EzpQkrjvftQWlMXkU5hXZII0oKk8Svz/rf3TKH4=;
	h=Date:To:From:Subject;
	b=qpW/SqfrsJqqC1yHKEjbg4nhpoLw84xH9XD1Dh9EbeJWIrPEocM7XCCGp2Q8T79XA
	 6PRwFIIFpjUaqjK1NwA9BssLKNQrOUHA8x1xf/zm4OgIGya4OFDTJb/9az8cH4EOfG
	 dQUoW5i+1V6PNHgmc30tSWTh5WyhNi5JVFNhEQu0=
Date: Tue, 02 Jun 2026 15:23:47 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-validate-min_region_size-to-be-power-of-2.patch removed from -mm tree
Message-Id: <20260602222347.C84221F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: validate min_region_size to be power of 2
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-validate-min_region_size-to-be-power-of-2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri, 1 May 2026 09:37:49 +0800

Patch series "mm/damon: validate min_region_size to be power of 2", v5.

Problem
=======
When a user sets an invalid 'addr_unit' (e.g., 3) via DAMON_LRU_SORT or
DAMON_RECLAIM, 'min_region_sz' becomes a non-power-of-2 value. While
damon_commit_ctx() correctly detects this and returns -EINVAL, it sets
the 'maybe_corrupted' flag during this process.

This flag causes the running kdamond to terminate. While the termination
is a safety measure, it is suboptimal in this case because the error is
just a simple invalid input from the user, which shouldn't neccessitate
stopping the kdamond.

Solution
========
Add an early validation in damon_lru_sort_apply_parameters() and
damon_reclaim_apply_parameters() to check 'min_region_sz' before any
state change occurs. If it is non-power-of-2, return -EINVAL immediately,
preventing 'maybe_corrupted' from being set.

Patch 1 fixes the issue for DAMON_LRU_SORT.
Patch 2 fixes the issue for DAMON_RECLAIM.


This patch (of 2):

Problem
=======
When a user sets an invalid 'addr_unit' (e.g., 3) via DAMON_LRU_SORT,
'min_region_sz' becomes a non-power-of-2 value. While damon_commit_ctx()
correctly detects this and returns -EINVAL, it sets the
'maybe_corrupted' flag during this process.

This flag causes the running kdamond to terminate. While the termination
is a safety measure, it is suboptimal in this case because the error is
just a simple invalid input from the user, which shouldn't neccessitate
stopping the kdamond.

Reproduction
============
1. Enable DAMON_LRU_SORT
2. Set addr_unit=3
3. Commit inputs via 'commit_inputs'
4. Observe kdamond termination

Solution
========
Add an early validation in damon_lru_sort_apply_parameters() to check
'min_region_sz' before any state change occurs. If it is non-power-of-2,
return -EINVAL immediately, preventing 'maybe_corrupted' from being set.

Link: https://lore.kernel.org/20260501013750.71704-1-aethernet65535@gmail.com
Link: https://lore.kernel.org/20260501013750.71704-2-aethernet65535@gmail.com
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-validate-min_region_size-to-be-power-of-2
+++ a/mm/damon/lru_sort.c
@@ -286,6 +286,11 @@ static int damon_lru_sort_apply_paramete
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
_

Patches currently in -mm which might be from aethernet65535@gmail.com are


