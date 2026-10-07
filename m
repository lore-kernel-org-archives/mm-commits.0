Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BE24D599E
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 19:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791401760; cv=none; b=ka8JMVCOqgUmW/juE2yJWRPRsY+fVUWzp+5BdRk9wPtFA3wBoYOVKYpf6PmT4hq+2mCLBfax3EyHriQok5ABSHtdrwyUFUGYmQCwwk4/cu+o2JrxxcF3PLvxS5hOQ0D8z6ATlpctmzFGo2FHsfbo7INvCtCTb4PzJl/teurGfb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791401760; c=relaxed/simple;
	bh=r4ijabIq7U9Odda8pd+VhqNeOHnDncXFhpRR9ViLZSk=;
	h=Date:To:From:Subject:Message-Id; b=WDFn4vz0DvDNA9+d6rxRG7EInIn2G+HXDRodbGNyQZ2QBVpc2HXSizgsg9Iy3FehVMPSn0THb9ahtk8V3uRqo4pgshsxtyHGRL0cd/VUEMhXqw5x2FCwpKGQzW2h+5G23SsBtkAMHOAaU+eKEfVTI5TdVVrQer+QTpFOIKeEU1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iCPwFjlv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iCPwFjlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209101F000FF;
	Wed,  7 Oct 2026 19:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791401759;
	bh=dRLfDzfUmagkKtREFs9SJf86mFC2bYhwWPknbRhsO+g=;
	h=Date:To:From:Subject;
	b=iCPwFjlvbaGHaq4Tq8c95LhZs0wnQyGVzdCt8ZGTqt4z0HKg783a4rMiA49/uxXYD
	 jWBGmkOXFBgWQ7m+idmqVqiPejj3qT9EIzAq8tR1Dhaum090U2nNRE5+ewv6xP2FOj
	 Ev8BajD4OKKT+XaQQJ01C55wDnsWREapSxR6x6+I=
Date: Wed, 07 Oct 2026 12:35:58 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-fix-age_in_sec-overflow-on-32-bit.patch added to mm-unstable branch
Message-Id: <20261007193559.209101F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/ops-common: fix age_in_sec overflow on 32-bit
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-ops-common-fix-age_in_sec-overflow-on-32-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-fix-age_in_sec-overflow-on-32-bit.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: mm/damon/ops-common: fix age_in_sec overflow on 32-bit
Date: Mon,  5 Oct 2026 23:52:05 -0700

Patch series "mm/damon: fix a minor bug, clean code, and add a test".

Patch 1 from Jaeyeon Lee fixes a minor overflow issue in DAMOS.  Patch 2
from Gregory Price (Meta) cleans up the code for handling of hugetlb
pages.  Patch 3 from Liew Rui Yan adds a kunit test for a recently fixed
bug.


This patch (of 3):

damon_hot_score() calculates the age of a region by multiplying r->age and
the aggregation interval.  On 32-bit architectures, unsigned long is 32
bits, so the multiplication overflows once the age exceeds about 4295
seconds.  Then old regions are scored as if they were young.

Fix it by doing the calculation in 64-bit arithmetic using div_u64(). 
Also make age_in_sec u64, so the result is not truncated back to 32 bits.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20261006065209.41507-1-sj@kernel.org
Link: https://lore.kernel.org/20261006065209.41507-2-sj@kernel.org
Link: https://lore.kernel.org/20260623011652.1354-1-sj@kernel.org [1]
Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Assisted-by: LLM
---

 mm/damon/ops-common.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-fix-age_in_sec-overflow-on-32-bit
+++ a/mm/damon/ops-common.c
@@ -164,7 +164,7 @@ int damon_hot_score(struct damon_ctx *c,
 			struct damos *s)
 {
 	int freq_subscore;
-	unsigned int age_in_sec;
+	u64 age_in_sec;
 	int age_in_log, age_subscore;
 	unsigned int freq_weight = s->quota.weight_nr_accesses;
 	unsigned int age_weight = s->quota.weight_age;
@@ -174,7 +174,8 @@ int damon_hot_score(struct damon_ctx *c,
 			DAMON_MAX_SUBSCORE,
 			damon_nr_samples_per_aggr(&c->attrs));
 
-	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
+	age_in_sec = div_u64((u64)r->age * c->attrs.aggr_interval,
+			     USEC_PER_SEC);
 	if (age_in_sec)
 		age_in_log = min_t(int, ilog2(age_in_sec) + 1,
 				DAMON_MAX_AGE_IN_LOG);
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are

selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch
selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-fix-tap-plan-mismatches.patch
mm-damon-ops-common-fix-age_in_sec-overflow-on-32-bit.patch

