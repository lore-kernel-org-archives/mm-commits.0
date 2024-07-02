Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF909473
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719887718; cv=none; b=ueasV9I/zQD8cCxXLLBZKIc5jOGlY+CEo6FcMVzlmPwaaGLev+ILgQOAwuxNveHcQxNf1NweLkbnZxlN980AfzojRwqIgtfVj73hvu6pjgZOwMqJ7prFhkLj6tRgSYHIjR4B5X3XdImMQmBrDfVYkTzwXipL2JVdFceEnz2sQLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719887718; c=relaxed/simple;
	bh=ze9w7kcfpt0lI57RlWQz9mhzOiLzwW0CFOQk/IB3Jlg=;
	h=Date:To:From:Subject:Message-Id; b=Y+kmw8JOLtsOlzcCc2pL59seAPv+weHWeVl9cu0p+L9eNGwABsRANJ/YxYHm7L5ct37mEEQQ2zfoPFa9ljSV7/HMGzGFV0x/JFhpuZkAuXW29JxsbvDUF+AZuaxDMDn+Yq1XeolSt7qE8idEDoOegXnDPnuyYTTamR3F0z7tTxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QX1JMLe/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QX1JMLe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609B2C116B1;
	Tue,  2 Jul 2024 02:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719887717;
	bh=ze9w7kcfpt0lI57RlWQz9mhzOiLzwW0CFOQk/IB3Jlg=;
	h=Date:To:From:Subject:From;
	b=QX1JMLe/wu+2VFXSAwBZuURMLatOQNce1WQMK0P7Xkvk0uGiltPLNM0TdHjlqhIiZ
	 YPrXX+rLHWgpA/3Z+oKUUZQAkmNtJiZkjyMeTabdLBiNLgEkZmufXdtGhE81tb2RQr
	 G1ginK+iMwfn8XnTWHg5GKC+Stj2JntlKPS0GIaI=
Date: Mon, 01 Jul 2024 19:35:16 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,hyeongtak.ji@sk.com,honggyu.kim@sk.com,dan.carpenter@linaro.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-initialize-nr_succeeded-in-__damon_pa_migrate_folio_list.patch added to mm-unstable branch
Message-Id: <20240702023517.609B2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: initialize nr_succeeded in __damon_pa_migrate_folio_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-initialize-nr_succeeded-in-__damon_pa_migrate_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-initialize-nr_succeeded-in-__damon_pa_migrate_folio_list.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch
mm-damon-paddr-initialize-nr_succeeded-in-__damon_pa_migrate_folio_list.patch
docs-mm-damon-design-fix-two-typos.patch
docs-mm-damon-design-clarify-regions-merging-operation.patch
docs-admin-guide-mm-damon-start-add-access-pattern-snapshot-example.patch
docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details.patch
docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section.patch
docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section.patch
docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc.patch
docs-mm-damon-index-add-links-to-design.patch
docs-mm-damon-index-add-links-to-admin-guide-doc.patch

