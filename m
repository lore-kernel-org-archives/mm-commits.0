Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE6A480DFC
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865974; cv=none; b=TTvmSvBMs1spd0rcpottA5MBBuclCwm9z/kha44WuA/iRGE4XNHzdXpLwVCLqJFeof2rwsyAfTe44zuJtL7NkIELaVpg05dLKyyPtekIqjAzezVKNHgdIhlMFZkJ8/+p4w6jod53rlz5+AayVBBTr8nUOn/qfMBOmfP50zAZtRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865974; c=relaxed/simple;
	bh=g5AUQh8+KRm5cf0kWScfxuV4xNwJpeDyFoUaMVOUf7I=;
	h=Date:To:From:Subject:Message-Id; b=JZO1RnG4hW0rw5T32Es6+iMZinul4fHx8RJCy3S7u0jnRD2rt0L70M4XMhA0roFw2W8Z1eEDxUxjjQL0CYKATl6q1zyLMO8TNTRclwA73KeinoRR/vw+Y3fm/wzlmBlvHzCThDdOdr/YzMx5x41ZiBAb2Olbm8V0TKwLtkHsPgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hcvPq/wH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hcvPq/wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5550E1F000FF;
	Tue, 13 Oct 2026 04:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865972;
	bh=dX4RSDLOWHBo3gYzL/mr377iUTE8mu/YsE72P5zg4uA=;
	h=Date:To:From:Subject;
	b=hcvPq/wHuC2TzXzg2L1e7PU1F4BgpzftyDforwbutrKldsussPkI/sz9qyqvrtVKu
	 70kgWoXbQ8gH9Sgs0wSjxqtAHzy1SUwrFyvB/cXlGTmdSJqh/aAnz4SZtTBL3yPGDL
	 HK+2Z78WXmpf2KKuHWNr9l5PZd2EfDcfWKDEwMLY=
Date: Mon, 12 Oct 2026 21:32:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass.patch removed from -mm tree
Message-Id: <20261013043252.5550E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: remove pa parameter from damon_pa_filter_pass()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/paddr: remove pa parameter from damon_pa_filter_pass()
Date: Thu, 17 Sep 2026 07:22:04 -0700

damon_pa_filter_pass() receives the 'pa' parameter, but doesn't use it.
Remove the parameter from the function signature.

Link: https://lore.kernel.org/20260917142210.90829-7-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/paddr.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass
+++ a/mm/damon/paddr.c
@@ -163,8 +163,7 @@ static bool damon_pa_filter_match(struct
 	return matched == filter->matching;
 }
 
-static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
-		struct damon_probe *p)
+static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p)
 {
 	struct damon_filter *f;
 	bool pass = true;
@@ -200,7 +199,7 @@ static unsigned int damon_pa_apply_probe
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
 			damon_for_each_probe(p, ctx) {
-				if (damon_pa_filter_pass(pa, folio, p))
+				if (damon_pa_filter_pass(folio, p))
 					r->probe_hits[i]++;
 				i++;
 			}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

