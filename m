Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA881318EFF
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486689; cv=none; b=eXbxMP5l8bcoL207XA+MSUu8tsz/726AB02hPx98v9Z+h+jzf+iEnL4ZOwXeyvqb+PLwE2YQZUXNgW8Zg1Op1dKftuT9oXDJNXpj3Ag3eaGfJFiYQofFcjQjF9OIgNWTn2mo40iZnKub+IQP0B+c+cDKxh8q5elb8bK5obH5lsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486689; c=relaxed/simple;
	bh=3Q11+kAxwTQ3PRrWK0M9QgyRo97bpPKEaDb3pGX0jjQ=;
	h=Date:To:From:Subject:Message-Id; b=qjrIugTUtGEYcxS5sc2ugOIK56aMau8UNDLZpuZsH8Yvud94GSHknS238HvjM63rHCc0FYf/w8WYmGko+TBcWbG9X4M1HyvsOJLDdc6HCKNwv4zMnObkQ1huuuVzS1P0xvD0t/whjgYAxqxVIMkPNs9AxBDdUsgxbB9eVHLaDN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bVBfiCoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bVBfiCoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98564C116C6;
	Tue, 27 Jan 2026 04:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486689;
	bh=3Q11+kAxwTQ3PRrWK0M9QgyRo97bpPKEaDb3pGX0jjQ=;
	h=Date:To:From:Subject:From;
	b=bVBfiCoPqxvpg1q0gt3RQOTRwjEAOufJnf9gZdpYgfSKMR7U3Q5B22IOrlILEp/kt
	 AIvNLlct+0ZC1FxKRNVPkbG91SeS4Ql5bZIF9ti+Pxgh7D9WsIaWDKcmKOmNV5suMB
	 rbP3QLtlNLCOCmJXy6TBAPCGAwYo5Edeqhz5h7Wc=
Date: Mon, 26 Jan 2026 20:04:49 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,yangqixiao@inspur.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-initialize-folio-variables-to-null-for-clarity.patch removed from -mm tree
Message-Id: <20260127040449.98564C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: initialize 'folio' variables to NULL for clarity
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-initialize-folio-variables-to-null-for-clarity.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aaron Yang <yangqixiao@inspur.com>
Subject: mm/damon/paddr: initialize 'folio' variables to NULL for clarity
Date: Wed, 7 Jan 2026 17:30:38 -0800

In damon_pa_mark_accessed_or_deactivate(), damon_pa_pageout(),
damon_pa_migrate(), and damon_pa_stat(), the local variable 'folio' is
declared but not initialized.

Initialize 'folio' to NULL to improve code readability and
maintainability.

Link: https://patch.msgid.link/20260104013255.16962-1-yangqixiao@inspur.com
Link: https://lkml.kernel.org/r/20260108013041.80601-1-sj@kernel.org
Signed-off-by: Aaron Yang <yangqixiao@inspur.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-initialize-folio-variables-to-null-for-clarity
+++ a/mm/damon/paddr.c
@@ -156,7 +156,7 @@ static unsigned long damon_pa_pageout(st
 	LIST_HEAD(folio_list);
 	bool install_young_filter = true;
 	struct damos_filter *filter;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	/* check access in page level again by default */
 	damos_for_each_ops_filter(filter, s) {
@@ -212,7 +212,7 @@ static inline unsigned long damon_pa_mar
 		unsigned long *sz_filter_passed)
 {
 	phys_addr_t addr, applied = 0;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
@@ -262,7 +262,7 @@ static unsigned long damon_pa_migrate(st
 {
 	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
@@ -295,7 +295,7 @@ static unsigned long damon_pa_stat(struc
 		unsigned long *sz_filter_passed)
 {
 	phys_addr_t addr;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	if (!damos_ops_has_filter(s))
 		return 0;
_

Patches currently in -mm which might be from yangqixiao@inspur.com are


