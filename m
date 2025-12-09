Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0118130649A
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308394; cv=none; b=BBSBenBu5zhwreQHWSzKrn4ZiZwCm8Xuq+5z6uaYVg/o8cS2NgoE0rPKpSj9tfzICtlo4pu0HosW3/thHGeF0JJKM9nSc+G1KbrkWNeu3O36EgPranBNLF10Q0OB80xTrw9shF/E5cuwbUb3nwQIONMBZycSjke7WUQ65qlNLyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308394; c=relaxed/simple;
	bh=N0HLWq1IgfANo1s3n2hSs+Q3sIOQh+5xA8XDFCUYoE4=;
	h=Date:To:From:Subject:Message-Id; b=oNNg//fjw4XfsrdnlLd9wvt07CHkwdzZflPZ2/joVGrRlkwSNTHr/e6q556x5mM0GI6l9Op7jilCrOz2Y/3QjprQThzn4xkXDFdgIS0/CLfW0soBYIIGytCfUQjyyoyb0O2AgNUze75sZggzyOLjpEgfpar24jxL+rLx7AEGoaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pYMVUty3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pYMVUty3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92A7C4CEF5;
	Tue,  9 Dec 2025 19:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308393;
	bh=N0HLWq1IgfANo1s3n2hSs+Q3sIOQh+5xA8XDFCUYoE4=;
	h=Date:To:From:Subject:From;
	b=pYMVUty3l5SMbiEh4RSXMAzt9BrGBS5rznIA2754Q8LEgPAa+Ab4CX9RTfVG82TGz
	 OFcAbF6kOENBcU9osC/Xuo+EFiGGvjYf+dO0rx8fredoli0d2FWVoyMUhcpkA2cRCB
	 DwgmJpEAmJZXV4myc3rwsjJd7j2tI7S9l9NMAGP4=
Date: Tue, 09 Dec 2025 11:26:33 -0800
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,sj@kernel.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-avoid-damos_test_commit-stack-warning.patch removed from -mm tree
Message-Id: <20251209192633.A92A7C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: avoid damos_test_commit stack warning
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-avoid-damos_test_commit-stack-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-shmem-avoid-build-warning-for-config_shmem=n.patch
mm-memfd_luo-add-config_shmem-dependency.patch

