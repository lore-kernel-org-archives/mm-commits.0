Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216633B7752
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068125; cv=none; b=dQS63BKVjuJme4E8BZ5ht4Hiltuqv3t8OmhQuzgGHOnzC3N8G8S0XVJEwQ/VAIYr/k54yAqSihLSxV9majpJ6OiWM0p4HTwjJioDErwqd0qD+4djBwBgKkfH7nZSdVpB16z2ewfscRARgyeQ/farqr3wR4SdOpqw3j0pbT1N7dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068125; c=relaxed/simple;
	bh=15SvW1DMmxYiqtlnjyQPju0X6vX+XUuuEQ6WqKw9lZE=;
	h=Date:To:From:Subject:Message-Id; b=IghKkQFEE6s/aRqJeVQQdQwS9q1G59AfvWJQJHbomBw5SeoZGlDR2n7pBxdh88ZmWssnSaKFPbUty6yRgLpn1p9OA7p1+Cjf434kcd3vNs8fbqIZNAtrZVSBl68Zbp9Qe2aoMDjjjCVv27bOAZY+5P3WEzGUjyYTBf1aE5BVghE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qce4perJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qce4perJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED90B1F000E9;
	Fri,  7 Aug 2026 02:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068124;
	bh=N4IhmoPLKRGsgFhIbYaP1WsnacsxOY/Iob50A8NrtVk=;
	h=Date:To:From:Subject;
	b=qce4perJpQlEMZdkzFU9C7MSZMZ5eNZ79GzYtXcEih9ladZfEDWo1pxEAprJCi4R7
	 6009+XUF+f8+2O3yPPtdltKNdBvY08N6HA7ivaMXCRTdp3gG2FuRvCPQjuscH2lrGe
	 GsCdQGKOp/wksmoFmNaqqmps75C5wtcmiqa+hA6E=
Date: Thu, 06 Aug 2026 19:02:03 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-ops-common-remove-redundant-local-variable-in-damon_migrate_folio_list.patch removed from -mm tree
Message-Id: <20260807020203.ED90B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/ops-common: remove redundant local variable in damon_migrate_folio_list()
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-common-remove-redundant-local-variable-in-damon_migrate_folio_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon/ops-common: remove redundant local variable in damon_migrate_folio_list()
Date: Sat, 18 Jul 2026 08:21:25 +0800

In damon_migrate_folio_list(), we're redeclaring folio inside the first
while loop, but it just shadows the outer one.  Since the second loop uses
the outer folio anyway, the inner declaration is pointless.

Remove it to consistently reuse the same variable throughout the
function and improve readability.

Link: https://lore.kernel.org/20260718002125.637104-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-remove-redundant-local-variable-in-damon_migrate_folio_list
+++ a/mm/damon/ops-common.c
@@ -339,8 +339,6 @@ static unsigned int damon_migrate_folio_
 	LIST_HEAD(migrate_folios);
 
 	while (!list_empty(folio_list)) {
-		struct folio *folio;
-
 		cond_resched();
 
 		folio = lru_to_folio(folio_list);
_

Patches currently in -mm which might be from lienze@kylinos.cn are


