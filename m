Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D62D182B4
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733877514; cv=none; b=sXvQ/nxPyZUTWWCf9fdG/uUuoUE/h9PPY2sKs+OqR0+mQDRaE3tRUT1kgbMXic37z0gTZOugMk3lLnAQ+nqH6tA8DLvopmNWFZ3taH9m8T19U2DW5M5YlIstqTDrT/5xVqYBnOjwsA3IiOyqsuNTF/e/FAFAwsv9bvozVNLEuho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733877514; c=relaxed/simple;
	bh=jwDmopD87p9E+C65NrJFHEAjE8WHtuL0dM0pVxItoo0=;
	h=Date:To:From:Subject:Message-Id; b=YZ/AilyMBhsOOod9Xkxqp1FiCvibVPCkxMOkeTn5xQ8ewxrlKGQ/ad+DSDHSSMqdDJgpsM+tY4e0jk8wtrMxzffWJOjH01N1DmPQeIsIeweVuG8jOho5tqrdZ2jCS9DRuPa1zbhxDRJlykre4LxW6/RpO4aFEg4b2QtWUyCzyAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ng3yigp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ng3yigp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F10C4CED6;
	Wed, 11 Dec 2024 00:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733877514;
	bh=jwDmopD87p9E+C65NrJFHEAjE8WHtuL0dM0pVxItoo0=;
	h=Date:To:From:Subject:From;
	b=2ng3yigpsJOO2l8dAiV/3SMOTQX3UpBoU5rKjzd0xA+xxiSIhTbp4E7D2vz0B2w+H
	 POMR60O0OX649S5TIQIaaTaQN1e9Onmq12fHiPg4sJQyv/b2jMXryYdTDzCnv6UNVc
	 44ByHJDi1WexjYlUPZh9D/F6tw6TLZfi1XVPXJkg=
Date: Tue, 10 Dec 2024 16:38:33 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-prcl-implement-schemes-setup.patch added to mm-unstable branch
Message-Id: <20241211003834.22F10C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/prcl: implement schemes setup
has been added to the -mm mm-unstable branch.  Its filename is
     samples-damon-prcl-implement-schemes-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-prcl-implement-schemes-setup.patch

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
Subject: samples/damon/prcl: implement schemes setup
Date: Tue, 10 Dec 2024 13:50:30 -0800

Implement a proactive cold memory regions reclaiming logic of prcl sample
module using DAMOS.  The logic treats memory regions that not accessed at
all for five or more seconds as cold, and reclaim those as soon as found.

Link: https://lkml.kernel.org/r/20241210215030.85675-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/samples/damon/prcl.c~samples-damon-prcl-implement-schemes-setup
+++ a/samples/damon/prcl.c
@@ -49,6 +49,7 @@ static int damon_sample_prcl_after_aggre
 static int damon_sample_prcl_start(void)
 {
 	struct damon_target *target;
+	struct damos *scheme;
 
 	pr_info("start\n");
 
@@ -75,6 +76,25 @@ static int damon_sample_prcl_start(void)
 
 	ctx->callback.after_aggregation = damon_sample_prcl_after_aggregate;
 
+	scheme = damon_new_scheme(
+			&(struct damos_access_pattern) {
+			.min_sz_region = PAGE_SIZE,
+			.max_sz_region = ULONG_MAX,
+			.min_nr_accesses = 0,
+			.max_nr_accesses = 0,
+			.min_age_region = 50,
+			.max_age_region = UINT_MAX},
+			DAMOS_PAGEOUT,
+			0,
+			&(struct damos_quota){},
+			&(struct damos_watermarks){},
+			NUMA_NO_NODE);
+	if (!scheme) {
+		damon_destroy_ctx(ctx);
+		return -ENOMEM;
+	}
+	damon_set_schemes(ctx, &scheme, 1);
+
 	return damon_start(&ctx, 1, true);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch

