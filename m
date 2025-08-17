Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481FC199939;
	Sun, 17 Aug 2025 20:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755461352; cv=none; b=Nsk9u2hNYT0MLNLHxdyvfTnIEKXvtt81U5ONcMaMVFreD+QIVTiKDs9bqm/qFtwUJsJ8BVgsxD4QadOhRxzmKbWyYK5o098qm7NNsC7EuAkWWcO/JDzduFh0wHUJQs0QwhTQB/TaW76nt8WXONJb8Mmfp8qbhac1u0re99VZCyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755461352; c=relaxed/simple;
	bh=UXh8bq0QHER1dn2hDYhEqII1xbcPnDHjNT5sjJUZx4s=;
	h=Date:To:From:Subject:Message-Id; b=GX3cEOyRatXyZxWBu+YedQ43/pJw8UrAPcoEHZVvsSQz0S8WA2rxb+8x/5cu/HqzaeCcn74qLR2XJOArqqIyqEI0fZ5bfQtDBC8+CMDD78ykC8uaFNPBhctBEecDZKOC3sV3tKCWIY4cw2QtNNNtpxb9GUvw2e2zaCzLYT1Ara4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZSd7Lroh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZSd7Lroh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6DDC4CEEB;
	Sun, 17 Aug 2025 20:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755461351;
	bh=UXh8bq0QHER1dn2hDYhEqII1xbcPnDHjNT5sjJUZx4s=;
	h=Date:To:From:Subject:From;
	b=ZSd7LrohFp4krVC0QGOnWt9eCbWu78KftcA9eZVQMmrDC//ZP/pKfB5nWb44sQCy1
	 dXX0gERUc9WxtV9XdJyDoC/fDrswvfk813AeIaUBwFoFvAkz/ZND7YaumJHSdgVJ54
	 dAhq8TdOxVXTrtdg878dm5yF/bnBrlrNdUAaox9o=
Date: Sun, 17 Aug 2025 13:09:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-damos_commit_filter-not-changing-allow.patch added to mm-hotfixes-unstable branch
Message-Id: <20250817200911.8B6DDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix damos_commit_filter not changing allow
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-fix-damos_commit_filter-not-changing-allow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-damos_commit_filter-not-changing-allow.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/damon/core: fix damos_commit_filter not changing allow
Date: Sat, 16 Aug 2025 10:51:16 +0900

Current damos_commit_filter() does not persist the `allow' value of the
filter.  As a result, changing the `allow' value of a filter and
committing doesn't change the `allow' value.

Add the missing `allow' value update, so committing the filter
persistently changes the `allow' value well.

Link: https://lkml.kernel.org/r/20250816015116.194589-1-ekffu200098@gmail.com
Fixes: fe6d7fdd6249 ("mm/damon/core: add damos_filter->allow field")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.14.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-fix-damos_commit_filter-not-changing-allow
+++ a/mm/damon/core.c
@@ -883,6 +883,7 @@ static void damos_commit_filter(
 {
 	dst->type = src->type;
 	dst->matching = src->matching;
+	dst->allow = src->allow;
 	damos_commit_filter_arg(dst, src);
 }
 
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch
selftests-damon-fix-selftests-by-installing-drgn-related-script.patch
mm-damon-core-fix-damos_commit_filter-not-changing-allow.patch
mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch

