Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C05879E5
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141591; cv=none; b=AZBrXeDjflbIShdR4PpFdvs90AGKozQTLCDqfBE36kFqWY7Vs7DfDINr33MWhfS2VK+rtUIaKjhf2t3eWwW/NoaVpQhBtKiNASKwSowv82ckGb8+kOZvHurMTx7aXvv3H7UEcg9MooIGy2bLXiJCzZ0+x0vCPjy6Ta7UxDtYtnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141591; c=relaxed/simple;
	bh=cj8lAteeSfNAORFfiNIbmojlyWNmRYEoLhsLQrLhPw0=;
	h=Date:To:From:Subject:Message-Id; b=senQQNqPwoBESuWdHd0yP9+P7CDc3OVECbWUt+KJxc+o8JuDGwLHFAR5PCuIDOkQOnSev0VWmhY9/5keZ+ZlmABbYSDDhY1gjIYUb177AZmXHtomQhiBTqUBGXjUN0MZMwk313UX2173OIINDgsybjavdOgHvMpFd48VB46dT/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sDUzpRj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sDUzpRj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46743C4AF07;
	Fri,  5 Jul 2024 01:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141591;
	bh=cj8lAteeSfNAORFfiNIbmojlyWNmRYEoLhsLQrLhPw0=;
	h=Date:To:From:Subject:From;
	b=sDUzpRj9xx9k9ojR+BGsLFUIpfAihTtUsDCa/4BrQBkD0s8YNUoF1KXbyO3lNOYyk
	 w1tXwFX70XEDpqmxbXLdYbT1AohvAtbv/9ZQ3FsE3o+P0MorTuz5KjyjWz4R2r1h69
	 wSYd6YFtfDdLYTSd5let3YrOqbDz3zOrenFIvzgQ=
Date: Thu, 04 Jul 2024 18:06:30 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,hyeongtak.ji@sk.com,honggyu.kim@sk.com,dan.carpenter@linaro.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-initialize-nr_succeeded-in-__damon_pa_migrate_folio_list.patch removed from -mm tree
Message-Id: <20240705010631.46743C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: initialize nr_succeeded in __damon_pa_migrate_folio_list()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-initialize-nr_succeeded-in-__damon_pa_migrate_folio_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: initialize nr_succeeded in __damon_pa_migrate_folio_list()
Date: Mon, 1 Jul 2024 09:53:32 -0700

The variable is supposed to be set via later migrate_pages() call. 
However, the function does not do that when CONFIG_MIGRATION is unset. 
Initialize the variable to zero.

Link: https://lkml.kernel.org/r/20240701165332.47495-1-sj@kernel.org
Fixes: 5311c0a2eee3 ("mm/damon/paddr: introduce DAMOS_MIGRATE_COLD action for demotion")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202406251102.GE07hqfQ-lkp@intel.com/
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-initialize-nr_succeeded-in-__damon_pa_migrate_folio_list
+++ a/mm/damon/paddr.c
@@ -332,7 +332,7 @@ static unsigned int __damon_pa_migrate_f
 		struct list_head *migrate_folios, struct pglist_data *pgdat,
 		int target_nid)
 {
-	unsigned int nr_succeeded;
+	unsigned int nr_succeeded = 0;
 	nodemask_t allowed_mask = NODE_MASK_NONE;
 	struct migration_target_control mtc = {
 		/*
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-fix-two-typos.patch
docs-mm-damon-design-clarify-regions-merging-operation.patch
docs-admin-guide-mm-damon-start-add-access-pattern-snapshot-example.patch
docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details.patch
docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section.patch
docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section.patch
docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc.patch
docs-mm-damon-index-add-links-to-design.patch
docs-mm-damon-index-add-links-to-admin-guide-doc.patch

