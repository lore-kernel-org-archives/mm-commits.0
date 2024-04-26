Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344D2381B9
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 22:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714169862; cv=none; b=BKsJl61+MlX6UhLGYGJYofMqIloGSarxq24c5VV9DamTRlIajONTqhyt8X/mThy2+vbIT7Jvw0JrQ4lPabLPT9Sj41aS/8wDETQ2Y6SzYuD/N28Z54XnGzRZbSnii/4Pl/BVN0gqZEnQ8P6XUEZKK+8zFOJgsaiC8J9BFVGlCAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714169862; c=relaxed/simple;
	bh=lTamf0zCBA30gyTFjD0zONYDzCb4w45gDwahjLUSqJs=;
	h=Date:To:From:Subject:Message-Id; b=hJgShCPhWDLDntJpZZZcfnS4QiD+fpRptQFWCvnVQq0Dsm36TX4laGClyCZmldVK07DFRW30fVktT8HzuqP6+aZrKzW0Lr/C/2rrnVsM1tDIYrFvq26q29Bnr6SdJetOb09j8nhuds1fNgr3dtu0aIQVdnsVe5AivltsKr8TDVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mUkMoUkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mUkMoUkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18E2C113CD;
	Fri, 26 Apr 2024 22:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714169861;
	bh=lTamf0zCBA30gyTFjD0zONYDzCb4w45gDwahjLUSqJs=;
	h=Date:To:From:Subject:From;
	b=mUkMoUkbkTLXd18yMiJx49+0/CYfIGJGhWGujsjr8wPP8BF31UYX8ZwfAsN49Nrli
	 P9fw72nBqsEwFNkv0/61hULlxs27MvcyjJl/TU6r+ifrWdBf9fbeEtEd5UEyS51r/S
	 TF8o50tiYQoXe/JSaJ2mlWM7DJrhlYJB7tH933TA=
Date: Fri, 26 Apr 2024 15:17:41 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-damos-filter-type-young.patch added to mm-unstable branch
Message-Id: <20240426221741.B18E2C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add DAMOS filter type YOUNG
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-add-damos-filter-type-young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-damos-filter-type-young.patch

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
Subject: mm/damon: add DAMOS filter type YOUNG
Date: Fri, 26 Apr 2024 12:52:42 -0700

Define yet another DAMOS filter type, YOUNG.  Like anon and memcg, the
type of filter will be applied to each page in the memory region, and see
if the page is accessed since the last check.  Based on the 'matching'
parameter, the page is filtered out or in.

Note that this commit is adding only the type definition.  The
implementation should be made by DAMON operations sets.  A commit for the
implementation on 'paddr' DAMON operations set will follow.

Link: https://lkml.kernel.org/r/20240426195247.100306-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |    2 ++
 mm/damon/sysfs-schemes.c |    1 +
 2 files changed, 3 insertions(+)

--- a/include/linux/damon.h~mm-damon-add-damos-filter-type-young
+++ a/include/linux/damon.h
@@ -297,6 +297,7 @@ struct damos_stat {
  * enum damos_filter_type - Type of memory for &struct damos_filter
  * @DAMOS_FILTER_TYPE_ANON:	Anonymous pages.
  * @DAMOS_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @DAMOS_FILTER_TYPE_YOUNG:	Recently accessed pages.
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
@@ -315,6 +316,7 @@ struct damos_stat {
 enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ANON,
 	DAMOS_FILTER_TYPE_MEMCG,
+	DAMOS_FILTER_TYPE_YOUNG,
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	NR_DAMOS_FILTER_TYPES,
--- a/mm/damon/sysfs-schemes.c~mm-damon-add-damos-filter-type-young
+++ a/mm/damon/sysfs-schemes.c
@@ -343,6 +343,7 @@ static struct damon_sysfs_scheme_filter
 static const char * const damon_sysfs_scheme_filter_type_strs[] = {
 	"anon",
 	"memcg",
+	"young",
 	"addr",
 	"target",
 };
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch

