Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9086CC125
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 05:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720071015; cv=none; b=AOUtaH27LLPSNBRKuqJ9A3vNSGBgaakR2RLWWEIJjVpZsqJK4sUKulkfbcQezmQQKSnehZDHqiDMr6SkK/Mo+Rqp+JUlzwE6wk0FKkbBA6SepMo8IaFRz6Mt7aqhUMUaCmNJjL/nYp7J2dhwvv6qllJ8pPpNv2LsJ+ItrTwXcsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720071015; c=relaxed/simple;
	bh=CevNUB+oSFrGgQbf0cqvQMIJW47tn3ctXoTz6K+KfD8=;
	h=Date:To:From:Subject:Message-Id; b=d9MHrzQTuAKCi7OdGjJy5sNIJAQ+ukzD6GtOtNF/7rkwL7UPlzZFVHYcxwNf/VKbJTKevsDC7ZUEbHsp6n2m1dAWPBdp4BGHuaGQQ7Uen+7nqAdTk/8Pb+2gbGW0QMrAIUUwQ/OOkro36C5moqcV2/FV1+s1tXALMEFIekoGsL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TVT7jWbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TVT7jWbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07892C3277B;
	Thu,  4 Jul 2024 05:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720071015;
	bh=CevNUB+oSFrGgQbf0cqvQMIJW47tn3ctXoTz6K+KfD8=;
	h=Date:To:From:Subject:From;
	b=TVT7jWbtJrks9sbnbcYr5cHVwZ8t3c1MgbLuNAc9IVyIILpmjHClxZxeWnkB3waEm
	 X+gcvykI+sxBOVAhWVQOpG/eUl2U1PG/0xNSZPrjDhwbYW2EdwNkHlIpaBqqFOnPeA
	 JUZ6clOk2hvmitUMrlHzuQEbjGHjWOjOxCLjmIdE=
Date: Wed, 03 Jul 2024 22:30:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch removed from -mm tree
Message-Id: <20240704053015.07892C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: ensure max threshold attempt for max_nr_regions violation
has been removed from the -mm tree.  Its filename was
     mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch

This patch was dropped because it was folded into mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: ensure max threshold attempt for max_nr_regions violation
Date: Thu, 27 Jun 2024 09:31:52 -0700

Since commit ed6cb9d022c8 ("mm/damon/core: increase regions merge
aggressiveness while respecting min_nr_regions") of mm-unstable,
kdamond_merge_regions() stops the repeated merge attempts for meeting
max_nr_regions if the merge threshold that increased for next iteration is
higher than the possible maximum threshold.  Hence, it can skip a merge
attempt with the maximum threshold depending on the amount of the
threshold increase, the maximum threshold, and the last-used threshold
value.  In extreme situations (e.g., region 1 has 100% access frequency,
region 2 has 0% access frequency, so on), this can degrade the
max_nr_regions violation recovery.

Fix this by stopping the loop by comparing the last-used threshold instead
of the to-be-used threshold, and if the last-used threshold is same to or
higher than the maximum possible threshold.

Link: https://lkml.kernel.org/r/20240627163153.75969-1-sj@kernel.org
Fixes: ed6cb9d022c8 ("mm/damon/core: increase regions merge aggressiveness while respecting min_nr_regions") # mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Closes: https://lore.kernel.org/20240626214954.46143-1-sj@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2
+++ a/mm/damon/core.c
@@ -1382,7 +1382,7 @@ static void kdamond_merge_regions(struct
 		}
 		threshold = max(1, threshold * 2);
 	} while (nr_regions > c->attrs.max_nr_regions &&
-			threshold <= max_thres);
+			threshold / 2 < max_thres);
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
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

