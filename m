Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47B83B8D60
	for <mm-commits@vger.kernel.org>; Sat,  6 Dec 2025 22:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765058753; cv=none; b=MSlzG/752PxVidBJovrfUVtxKR4DmQoBh+HfEJeRKC739olbRqXu9p2aaVuUHn6DhEGDYoMWBqNMqnwzeNeaWWaVKa4itfAs11J3Ngg/zkw5BFLJvm1VT1ioKCdFTWnMskqD1PVJ57SA3PdjOpuenvWRcve4TXu2hdRq7+sjenI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765058753; c=relaxed/simple;
	bh=H3z9Cnb9U7VfJgoDhRr0EpdZIUsQCyrVxxYoSsfl1iE=;
	h=Date:To:From:Subject:Message-Id; b=SduJZJsEvwKSnCEsfmW0WY04ctLAJtCTP2q5+OBswTUxSzrbdwjxEDxiok8un3159XI1oBrxvWND75M0T15rKi667eGhUDNLHgFe9z9edwn6uVCUpYtQYyQzOQN3vmk8pdx8cudDzVkTrflsMDrNaZbPr7e6KA3ocTKN9T39RvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KB3ITQZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KB3ITQZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CD5C4CEF5;
	Sat,  6 Dec 2025 22:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765058752;
	bh=H3z9Cnb9U7VfJgoDhRr0EpdZIUsQCyrVxxYoSsfl1iE=;
	h=Date:To:From:Subject:From;
	b=KB3ITQZrkajLnGZFi2QRgwyKXYOmbYH8PbHh9WfgBBUKthtXc/DdXBHN24oVOWFmo
	 nw/sZjTxMsnDtSHdEwqOM3X6AyOMLC1eyp8af+Vqkh3MMrFR9N+dQ99B9BYHehLW4l
	 xeHOx292+1L4/8hpt9f7yCLsYKyWlLtPHPVrbi5c=
Date: Sat, 06 Dec 2025 14:05:51 -0800
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,sj@kernel.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-avoid-damos_test_commit-stack-warning.patch added to mm-unstable branch
Message-Id: <20251206220552.55CD5C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: avoid damos_test_commit stack warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-tests-core-kunit-avoid-damos_test_commit-stack-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-avoid-damos_test_commit-stack-warning.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/damon/tests/core-kunit: avoid damos_test_commit stack warning
Date: Thu, 4 Dec 2025 11:03:54 +0100

The newly added damos_test_commit() constructs multiple large structures
on the stack, which exceeds the warning limit in some cases:

In file included from mm/damon/core.c:2941:
mm/damon/tests/core-kunit.h: In function 'damos_test_commit':
mm/damon/tests/core-kunit.h:965:1: error: the frame size of 1520 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]

Split this function up into two separate ones that are called
sequentially, so they can occupy the same stack slots.

Link: https://lkml.kernel.org/r/20251204100403.1034980-1-arnd@kernel.org
Fixes: 299a88f6ec13 ("mm/damon/tests/core-kunit: add damos_commit() test")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-avoid-damos_test_commit-stack-warning
+++ a/mm/damon/tests/core-kunit.h
@@ -924,7 +924,7 @@ static void damos_test_commit_for(struct
 	}
 }
 
-static void damos_test_commit(struct kunit *test)
+static void damos_test_commit_pageout(struct kunit *test)
 {
 	damos_test_commit_for(test,
 			&(struct damos){
@@ -945,6 +945,10 @@ static void damos_test_commit(struct kun
 					DAMOS_WMARK_FREE_MEM_RATE,
 					800, 50, 30},
 			});
+}
+
+static void damos_test_commit_migrate_hot(struct kunit *test)
+{
 	damos_test_commit_for(test,
 			&(struct damos){
 				.pattern = (struct damos_access_pattern){
@@ -1230,7 +1234,8 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_commit_quota),
 	KUNIT_CASE(damos_test_commit_dests),
 	KUNIT_CASE(damos_test_commit_filter),
-	KUNIT_CASE(damos_test_commit),
+	KUNIT_CASE(damos_test_commit_pageout),
+	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-damon-tests-core-kunit-avoid-damos_test_commit-stack-warning.patch
mm-shmem-avoid-build-warning-for-config_shmem=n.patch

