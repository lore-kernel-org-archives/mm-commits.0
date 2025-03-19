Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0CA24E4AF
	for <mm-commits@vger.kernel.org>; Wed, 19 Mar 2025 02:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742350471; cv=none; b=rIQfuWNRda1/kvpZ9RGXZbWU5PLBE/Czm7yMUgSDLlYQ4rObHe8pj+DEAh9XpbelQYT0mmNuI18BUNlRW6a2u82EdH7ZFQSdknNhG8s9HFSEOFfs09VL6A8Q5IFdevAaxNSB4zB9VGaeGbkum1tsqQLCgrzG2KvVAJh9H8a6T4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742350471; c=relaxed/simple;
	bh=iRAcANse2xqhFrJf5EhOCMI14hKJHt+swP0UG1K3mHQ=;
	h=Date:To:From:Subject:Message-Id; b=I/tH6HlZbMTXzLED78F3jvurgvnLvT1u/ay9XBCV1MRfI+8wuzOACUJgFgEk//AcizMVDLjfSrszotQCseIi/gqgsV5p3GY8fcDQDf9gTpXdrV6wqz8dUeaPgxTsTZZNOOR4rx1w4HBgMSRdWVVtLWH5grTyFwKgotJbSrvknmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n74Cc3yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n74Cc3yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33432C4CEDD;
	Wed, 19 Mar 2025 02:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742350471;
	bh=iRAcANse2xqhFrJf5EhOCMI14hKJHt+swP0UG1K3mHQ=;
	h=Date:To:From:Subject:From;
	b=n74Cc3yqaC2qhJOD7a4t2thWsTkwTF2OcqmIVl90FGD9pD6alhiel7m42Vx52gtjL
	 QmAwsAs/0jEQW0u/+58qDBp7HQAxVfoXrV0eMIl+kgfHP3o9xr9U991gewBH/tfcyY
	 cgNKSSXoUg71TTRf2RI1jZu7qvej78HUB0RAcdEM=
Date: Tue, 18 Mar 2025 19:14:30 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-implement-a-new-damos-filter-type-for-active-pages.patch added to mm-unstable branch
Message-Id: <20250319021431.33432C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: implement a new DAMOS filter type for active pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-implement-a-new-damos-filter-type-for-active-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-implement-a-new-damos-filter-type-for-active-pages.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm/damon: implement a new DAMOS filter type for active pages
Date: Tue, 18 Mar 2025 11:30:28 -0700

Patch series "mm/damon: introduce DAMOS filter type for active pages".

The memory reclaim algorithm categorizes pages into active and inactive
lists, separately for file and anon pages.  The system's performance
relies heavily on the (relative and absolute) accuracy of this
categorization.

This patch series add a new DAMOS filter for pages' activeness, giving us
visibility into the access frequency of the pages on each list.  This
insight can help us diagnose issues with the active-inactive balancing
dynamics, and make decisions to optimize reclaim efficiency and memory
utilization.

For instance, we might decide to enable DAMON_LRU_SORT, if we find that
there are pages on the active list that are infrequently accessed, or less
frequently accessed than pages on the inactive list.


This patch (of 2):

Implement a DAMOS filter type for active pages on DAMON kernel API, and
add support of it from the physical address space DAMON operations set
(paddr).

Link: https://lkml.kernel.org/r/20250318183029.2062917-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20250318183029.2062917-2-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |    2 ++
 mm/damon/paddr.c         |    3 +++
 mm/damon/sysfs-schemes.c |    1 +
 3 files changed, 6 insertions(+)

--- a/include/linux/damon.h~mm-damon-implement-a-new-damos-filter-type-for-active-pages
+++ a/include/linux/damon.h
@@ -334,6 +334,7 @@ struct damos_stat {
 /**
  * enum damos_filter_type - Type of memory for &struct damos_filter
  * @DAMOS_FILTER_TYPE_ANON:	Anonymous pages.
+ * @DAMOS_FILTER_TYPE_ACTIVE:	Active pages.
  * @DAMOS_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  * @DAMOS_FILTER_TYPE_YOUNG:	Recently accessed pages.
  * @DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
@@ -355,6 +356,7 @@ struct damos_stat {
  */
 enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ANON,
+	DAMOS_FILTER_TYPE_ACTIVE,
 	DAMOS_FILTER_TYPE_MEMCG,
 	DAMOS_FILTER_TYPE_YOUNG,
 	DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
--- a/mm/damon/paddr.c~mm-damon-implement-a-new-damos-filter-type-for-active-pages
+++ a/mm/damon/paddr.c
@@ -217,6 +217,9 @@ static bool damos_pa_filter_match(struct
 	case DAMOS_FILTER_TYPE_ANON:
 		matched = folio_test_anon(folio);
 		break;
+	case DAMOS_FILTER_TYPE_ACTIVE:
+		matched = folio_test_active(folio);
+		break;
 	case DAMOS_FILTER_TYPE_MEMCG:
 		rcu_read_lock();
 		memcg = folio_memcg_check(folio);
--- a/mm/damon/sysfs-schemes.c~mm-damon-implement-a-new-damos-filter-type-for-active-pages
+++ a/mm/damon/sysfs-schemes.c
@@ -344,6 +344,7 @@ static struct damon_sysfs_scheme_filter
 /* Should match with enum damos_filter_type */
 static const char * const damon_sysfs_scheme_filter_type_strs[] = {
 	"anon",
+	"active",
 	"memcg",
 	"young",
 	"hugepage_size",
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-damon-implement-a-new-damos-filter-type-for-active-pages.patch
docs-mm-damon-design-document-active-damos-filter-type.patch

