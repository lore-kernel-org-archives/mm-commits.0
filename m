Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDBD14265
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711479105; cv=none; b=mlkNn3E2YtcWo1urX0aVtwGe7Caa0+e+7RBJiZGHVLynobBbQmZJSqMotqj0/YxM5lJ1NXDRzaW0rplIOnkQLu5DuxUK1VM7XHDPfhh2bzWoVTUKqsUTpE4fbfBXTJUjWLpbEI3VbBebSFR12z0xiQ5g/2oeYqF6fi877fLIWa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711479105; c=relaxed/simple;
	bh=Dy5EJdZ2/6/LJtsuiiQ1xdgcql/469vpyjY4q+Y6exs=;
	h=Date:To:From:Subject:Message-Id; b=ryG55F1fHFoBpDzagBZ0gdcOq13ugF7u8wFwClmspsqgdPxEpyN9wWjvWDKUmhHq/HOzXOXjQJyHlH9sO8Y0HaoXhZBcW4mlbbFj6Quxw+bNwIkv7fRy/LPNXWuxA0F2oRXx9FTCIb4qXWZEIKEYj7ZYW5RLQ51AluelTNSzyPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pIXGCuom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pIXGCuom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A653C433F1;
	Tue, 26 Mar 2024 18:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711479105;
	bh=Dy5EJdZ2/6/LJtsuiiQ1xdgcql/469vpyjY4q+Y6exs=;
	h=Date:To:From:Subject:From;
	b=pIXGCuomUOJGD+WwHPJxl/mDx+gsJ/xNtRcdq/ZeLYHpuFacMiLdeUjqpOAAH+Y1h
	 MxovnX0f1Fw/1XhaCeNdK7/b5wHK1OMCNQO0Ufx8jmR3iqHm5CIgOGI/zamI/xVGgZ
	 FRMP1ue+rMZmNI7j62EN1rnsw6gAeCnf3Pe+rtvE=
Date: Tue, 26 Mar 2024 11:51:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,sj@kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,kirill.shutemov@linux.intel.com,fengwei.yin@intel.com,baolin.wang@linux.alibaba.com,zi.yan@sent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix.patch added to mm-unstable branch
Message-Id: <20240326185145.2A653C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix.patch

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
From: Zi Yan <zi.yan@sent.com>
Subject: mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix
Date: Tue, 26 Mar 2024 11:00:31 -0400

fix an error in migrate_misplaced_folio() reported by Baolin Wang

Link: https://lkml.kernel.org/r/20240326150031.569387-1-zi.yan@sent.com
Link: https://lore.kernel.org/linux-mm/df9a644c-a007-46ac-98e3-61d4014fcfff@linux.alibaba.com/
Fixes: 616b8371539a ("mm: thp: enable thp migration in generic path")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix
+++ a/mm/migrate.c
@@ -1668,7 +1668,7 @@ static int migrate_pages_batch(struct li
 			 */
 			if (nr_pages > 2 &&
 			   !list_empty(&folio->_deferred_list)) {
-				if (try_split_folio(folio, from) == 0) {
+				if (try_split_folio(folio, split_folios) == 0) {
 					stats->nr_thp_split += is_thp;
 					stats->nr_split++;
 					continue;
_

Patches currently in -mm which might be from zi.yan@sent.com are

mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix.patch

