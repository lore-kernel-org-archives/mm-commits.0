Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C99F1AF0CB
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 06:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860861; cv=none; b=eHD4YF/WDUZsJHk1a904Ws1iF1p1SEWlI+sBBX92QGStr80D18492bEGVnKODIrlH8DbGKkFvpiVf0Yc9g4ZagA9EyCtIwHxpqqrvYNRjyAcF2nbVLJqZpcxOc0h+yBScrBrcyqVz7qyj7AU/ua0SUHmBjNAkX6ZGfS3mVD2GTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860861; c=relaxed/simple;
	bh=kK7sbMxyyevbRYjwk88X5/0Eq+yFnkDNVo1zWuW+uEw=;
	h=Date:To:From:Subject:Message-Id; b=HAQofr3r5JeQby5razeZxI0EwbLMTdz3rjSGVXlHJk0XiDydtJNKAiSyFc1sITO3P6yyqkqUPxqGd8Nm+6SMeOIqKmE1aem5xFVnuQS1BGkDKRTa298Mp9Zg/KVguRHTh+ZGi4qBxlE+f+IZZZb5yx+hqGRJoKK11vaMBBQs54g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GI5Yj6b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GI5Yj6b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51395C4CEE2;
	Tue, 18 Feb 2025 06:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860861;
	bh=kK7sbMxyyevbRYjwk88X5/0Eq+yFnkDNVo1zWuW+uEw=;
	h=Date:To:From:Subject:From;
	b=GI5Yj6b0uWX+zEzptstRf93c9NBzFBi+L8X82ZlMtENiYu+eGLUfj32f7VS5AIkEv
	 pgodCAm271KuAEydmmMSpbj8PNZcUAYTGLSJUJMMPRUtghnoMohTSpDM/sJe8BQaIx
	 03ML1Yb4PsgvtIRm3gqPDocoJ5ylpQSE308NEDXo=
Date: Mon, 17 Feb 2025 22:41:00 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,npache@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-check-for-running-thp-tests.patch removed from -mm tree
Message-Id: <20250218064101.51395C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix check for running THP tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-check-for-running-thp-tests.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: fix check for running THP tests
Date: Wed, 12 Feb 2025 17:44:25 +0000

When testing if we should try to compact memory or drop caches before we
run the THP or HugeTLB tests we use | as an or operator.  This doesn't
work since run_vmtests.sh is written in shell where this is used to pipe
the output of the first argument into the second.  Instead use the shell's
-o operator.

Link: https://lkml.kernel.org/r/20250212-kselftest-mm-no-hugepages-v1-1-44702f538522@kernel.org
Fixes: b433ffa8dbac ("selftests: mm: perform some system cleanup before using hugepages")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-fix-check-for-running-thp-tests
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -220,7 +220,7 @@ run_test() {
 	if test_selected ${CATEGORY}; then
 		# On memory constrainted systems some tests can fail to allocate hugepages.
 		# perform some cleanup before the test for a higher success rate.
-		if [ ${CATEGORY} == "thp" ] | [ ${CATEGORY} == "hugetlb" ]; then
+		if [ ${CATEGORY} == "thp" -o ${CATEGORY} == "hugetlb" ]; then
 			echo 3 > /proc/sys/vm/drop_caches
 			sleep 2
 			echo 1 > /proc/sys/vm/compact_memory
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-fix-thuge-gen-test-name-uniqueness.patch
selftests-mm-allow-tests-to-run-with-no-huge-pages-support.patch

