Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E21D274658
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 02:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437645; cv=none; b=Z73NyH8DtK2HTfmT9loK4RtUti+OD9vkD7I6a6jaTmkpmQGDWxIYOTK08ljyfsR4MhjpgaDzHlCAzDxaPciciNXoIcux01XNh1O9gz5eMHMaBLgoSep0BSt7NhNUGmwf15d1j2u3XS5eoX1g64SLYxnAVBE2ps0ucfCkZdBz+Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437645; c=relaxed/simple;
	bh=OSEUpxwEbnfsezZysXXaAv1epVDFX5M6lC/xFcy0yGQ=;
	h=Date:To:From:Subject:Message-Id; b=rsOrsflFmEYRJpAaj1T5hqvo5d46wOJ48ImZGQed1sCoxEETeoOpX0z4lmlNDxUp2VIshuR+Mx719pJeTsl0bOOxkSzwNgEiS7zpCh+UB/vhVFw6LD4IONFatF6J99kHe63QrFmZHY9lsAU/rvlFoJo0VI+7PTAbhuzzdEO4msQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j9772mQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j9772mQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242C61F000FF;
	Tue, 15 Sep 2026 02:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789437644;
	bh=ttI2l+PS5BfdGe3pTsZ8oScrFhNitkCLxcAHAMOMJM4=;
	h=Date:To:From:Subject;
	b=j9772mQKXJRfM2wTLdIE0Xqh0zh5t0HH6i3IsVDoCDwHHttVSFg10GZ4Iqt875Q7Z
	 BI87XAvvdBcvXbj0qDFGahGMYcp7gEHY6aPRTE4LYGYhBaeMJCJ1yeNOetT7GxsuD2
	 mAnx4kI1HWT3D4wKj4IbQg2ItjlxWfL3s9vs8fLM=
Date: Mon, 14 Sep 2026 19:00:43 -0700
To: mm-commits@vger.kernel.org,kunwu.chan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-improve-nr_samples_per_aggr-test-isolation.patch added to mm-new branch
Message-Id: <20260915020044.242C61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-improve-nr_samples_per_aggr-test-isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-improve-nr_samples_per_aggr-test-isolation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kunwu Chan <kunwu.chan@gmail.com>
Subject: mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation
Date: Mon, 14 Sep 2026 07:19:49 -0700

Test the zero sample interval case with a non-zero aggregation interval,
and keep the zero/zero case to cover the zero-result fallback.

Also make the overflow case use an explicit sample interval so that it
does not depend on the zero sample interval fallback.

Link: https://lore.kernel.org/20260914141952.91465-5-sj@kernel.org
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
---

 mm/damon/tests/core-kunit.h |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-improve-nr_samples_per_aggr-test-isolation
+++ a/mm/damon/tests/core-kunit.h
@@ -627,12 +627,20 @@ static void damon_test_set_regions(struc
 
 static void damon_test_nr_samples_per_aggr(struct kunit *test)
 {
-	struct damon_attrs attrs = {
+	struct damon_attrs attrs;
+
+	/* Zero sample interval is treated as one. */
+	attrs = (struct damon_attrs){
 		.sample_interval = 0,
-		.aggr_interval = 0,
+		.aggr_interval = 5000,
 	};
+	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 5000);
 
-	/* Zero aggregation interval doesn't cause division by zero */
+	/* Zero sample and aggregation intervals cover the zero-result fallback. */
+	attrs = (struct damon_attrs){
+		.sample_interval = 0,
+		.aggr_interval = 0,
+	};
 	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 1);
 
 	/*
@@ -640,7 +648,10 @@ static void damon_test_nr_samples_per_ag
 	 * overflow
 	 */
 	if (ULONG_MAX > UINT_MAX) {
-		attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
+		attrs = (struct damon_attrs){
+			.sample_interval = 1,
+			.aggr_interval = (unsigned long)UINT_MAX + 1,
+		};
 		KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs),
 				UINT_MAX);
 	}
_

Patches currently in -mm which might be from kunwu.chan@gmail.com are

mm-damon-tests-core-kunit-improve-nr_samples_per_aggr-test-isolation.patch

