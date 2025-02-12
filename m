Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D3B200138
	for <mm-commits@vger.kernel.org>; Wed, 12 Feb 2025 21:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739396273; cv=none; b=L61lPaGZhkXy7v63sCKvLjyNq7McvvZPlWifSqhQ+bCIWalQUPvfYAY2I0nCODEt+8saaNTE3P/1k+nvZ95XhwkgIMjkhTQhm/5Dv9E1d79drt08SAMZy83mqgQLRUFL/9cch9EVo++yavZqckdxrI/5DqzYWffFbb2j6V1mpiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739396273; c=relaxed/simple;
	bh=+T5Io9AZZiYZW6inu/hU9b3qctG59AMPMRRS8PsmWno=;
	h=Date:To:From:Subject:Message-Id; b=fZuXUXhKMwSU5e4bGxbrEMHblGDrHX2OJJfjguD3ZZjeNM95lWHo9yjJKCoxhkyMyDkqxIshI5i1PLsQ2b+E0+o+l4ys36FaqQDofLKjPv9TUgIi3MJe9A8ovVls3lX1zvomUHF8rjWLd6Oo2qJco7TdtQuaRHAEphXm4EwoqZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AFsHy0gB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AFsHy0gB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57184C4CEDF;
	Wed, 12 Feb 2025 21:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739396273;
	bh=+T5Io9AZZiYZW6inu/hU9b3qctG59AMPMRRS8PsmWno=;
	h=Date:To:From:Subject:From;
	b=AFsHy0gBjHu8231YbBb05dsa/WxJI3uDId4T6p+P4YjXS5r7G26sU3eIGdFiMKFok
	 i3mpLST/yC0p8K7mPeHG92ax7+ca98Dr9m6n+zrKhak8S3gDlzx4PxS1MKfq4HyKaV
	 0dZnVz+xQ1Q9PHU8vMI+EUKmhS454IXd/SMFY0IY=
Date: Wed, 12 Feb 2025 13:37:52 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,npache@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-check-for-running-thp-tests.patch added to mm-hotfixes-unstable branch
Message-Id: <20250212213753.57184C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix check for running THP tests
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-check-for-running-thp-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-check-for-running-thp-tests.patch

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
Cc: Mariano Pache <npache@redhat.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
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

selftests-mm-fix-check-for-running-thp-tests.patch
selftests-mm-fix-thuge-gen-test-name-uniqueness.patch
selftests-mm-allow-tests-to-run-with-no-huge-pages-support.patch

