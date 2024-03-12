Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D450E1428ED
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274071; cv=none; b=dozaWTfJwxE3A1JwbvlpfFN5Y9YB3X2xLr8Z7feZjG5+egvF0KDBkV47zJN2cNHHpO2c19ZPv2xFnYXqgxrkNp9zLrKvdf6T7/HRraPRU8t3+XVZx+98Ms3m+hJ/g5zteJcyrMM0SpWkM4JgC1g6/beuHUKPSVRDTdmO7gJwMpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274071; c=relaxed/simple;
	bh=mn2pMqyZTZ/dD3KqjzjR9Ka9PzxazClaUCsB1ysUlxE=;
	h=Date:To:From:Subject:Message-Id; b=UFmntSzqZxJ6pgY0WwKwNWg2xz3GvqXV8Bt+kDNBSMuu8Ifwz68fvP4E0V+l2TkBZGIdylm/Js1Hq4S4ZQyvBBB1Mh+gStQwKBp73teUI3Qwma2t+hfVuu1NWQumbmkglLXLpu2fq9/uawmBiChHRthSXfqm9e3VYtPMmtWGVB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ku+qA43U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ku+qA43U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FFBC433C7;
	Tue, 12 Mar 2024 20:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274071;
	bh=mn2pMqyZTZ/dD3KqjzjR9Ka9PzxazClaUCsB1ysUlxE=;
	h=Date:To:From:Subject:From;
	b=Ku+qA43U1rxvUsC4Qf/dJYgnYCpXR3C+QCzRr85jhh8maK6bL5IeBGhoI/r1zVCki
	 iEz1D/pBFzsveOv3RcZ3Zv5b57I3503zXIUlWuf5Gt9gpLp5h+TNfA9QqPCqslLe/T
	 6sYkv9xWS+3Lzf/yQr3dcig2wuaU7vxwPpb5ESTA=
Date: Tue, 12 Mar 2024 13:07:50 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,muchun.song@linux.dev,ben@decadent.org.uk,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-dont-fail-testsuite-due-to-a-lack-of-hugepages.patch removed from -mm tree
Message-Id: <20240312200751.54FFBC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: dont fail testsuite due to a lack of hugepages
has been removed from the -mm tree.  Its filename was
     selftests-mm-dont-fail-testsuite-due-to-a-lack-of-hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: selftests/mm: dont fail testsuite due to a lack of hugepages
Date: Wed, 6 Mar 2024 15:37:12 -0700

Patch series "selftests/mm: Improve Hugepage Test Handling in MM
Selftests", v2.

This series addresses issues related to hugepage requirements in the MM
selftests, ensuring tests are skipped rather than failing when the
necessary hugepage count is not met.

This adjustment allows for a more graceful handling for systems with
insufficient hugepages, preventing unnecessary test failures and improving
the overall robustness of the test suite.


This patch (of 3):

On systems that have large core counts and large page sizes, but limited
memory, the userfaultfd test hugepage requirement is too large.

Exiting early due to missing one test's requirements is a rather
aggressive strategy, and prevents a lot of other tests from running. 
Remove the early exit to prevent this.

Link: https://lkml.kernel.org/r/20240306223714.320681-1-npache@redhat.com
Link: https://lkml.kernel.org/r/20240306223714.320681-2-npache@redhat.com
Fixes: ee00479d6702 ("selftests: vm: Try harder to allocate huge pages")
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-dont-fail-testsuite-due-to-a-lack-of-hugepages
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -175,7 +175,6 @@ if [ -n "$freepgs" ] && [ -n "$hpgsize_K
 	if [ "$freepgs" -lt "$needpgs" ]; then
 		printf "Not enough huge pages available (%d < %d)\n" \
 		       "$freepgs" "$needpgs"
-		exit 1
 	fi
 else
 	echo "no hugetlbfs support in kernel?"
_

Patches currently in -mm which might be from npache@redhat.com are


