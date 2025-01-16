Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913C129A1
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006014; cv=none; b=Ft+KQlCOBhdCK2x9XhfNg7F5MC5kWUYyJzhpOerJFQYgUHP8FRqiKJKDexPa5S0nqZ+LFB+Ivh/5G51r2jf4D4enXOwR7DqiOVNGXeOvdeWNyCQ4jwVy4Q20GfITVXICCzhRnWzLNCUO6APdGsTbjAeW6ZqoXye1S4WQFDaAp5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006014; c=relaxed/simple;
	bh=KDyYdKSUIO7HzPuI/tdcnY5XOSiwpv6Gre6W5+3DJQM=;
	h=Date:To:From:Subject:Message-Id; b=Oa8/EGT3cH1J0ZdShAd2r6orxM5XY1RT6WJqiacHrLL/0/UGvv5Zcxco1j9jbKL2p7y8GwDFoMYpyuhG8W1s5m6du7tLQB/gkZG1kLeZZlnyi6r8VldCEE1iQ6XIozwhQuHc5aSLYyI6JdRfVP6rm9OEyA5OJo6WhOlCdStEWII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YbGLt/Ys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YbGLt/Ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A16C4CED6;
	Thu, 16 Jan 2025 05:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006014;
	bh=KDyYdKSUIO7HzPuI/tdcnY5XOSiwpv6Gre6W5+3DJQM=;
	h=Date:To:From:Subject:From;
	b=YbGLt/Ys+LNID2TLJ2yO6ya1DRl/dOo5kiMTs+8z4zDoMnhSSYXawpXBekdXQuIZd
	 kdWrKry2UxSBI9B4l2Chdty+GhxWfoF9t0oEx7LyLurSzxsW2j51d4ezyzkxWp/Agl
	 IP3mUK5IwlwtXVyf0ig1lAq5ZeERf2ym8yjyHLbU=
Date: Wed, 15 Jan 2025 21:40:13 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,anshuman.khandual@arm.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-cow-modify-the-incorrect-checking-parameters-v2.patch removed from -mm tree
Message-Id: <20250116054014.16A16C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-cow-modify-the-incorrect-checking-parameters-v2
has been removed from the -mm tree.  Its filename was
     selftests-mm-cow-modify-the-incorrect-checking-parameters-v2.patch

This patch was dropped because it was folded into selftests-mm-cow-modify-the-incorrect-checking-parameters.patch

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: selftests-mm-cow-modify-the-incorrect-checking-parameters-v2
Date: Mon, 13 Jan 2025 13:09:08 +0800

fix other errant sites, per Anshuman

Link: https://lkml.kernel.org/r/20250113050908.93638-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-modify-the-incorrect-checking-parameters-v2
+++ a/tools/testing/selftests/mm/cow.c
@@ -1490,7 +1490,7 @@ static void run_with_zeropage(non_anon_t
 	}
 
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANON, -1, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1591,7 +1591,7 @@ static void run_with_memfd(non_anon_test
 		goto close;
 	}
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1642,7 +1642,7 @@ static void run_with_tmpfile(non_anon_te
 		goto close;
 	}
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
_

Patches currently in -mm which might be from gehao@kylinos.cn are

selftests-mm-cow-modify-the-incorrect-checking-parameters.patch

