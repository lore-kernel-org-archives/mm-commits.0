Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE76918BBA8
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006304; cv=none; b=J9FDUv7XZr/tnQLsHiFVWjnobygMRTjbW++XXOvuAyKNvGnDJSB8gE6gnXacSKPWrwdVDl5qISpBydz3Wf13oaur8aozaBaiqKdU3Sv8pC5WAl25BiU+4nHD6YthOdN6KEcSLzMN0Zv2Z3FncDbhp6Obblcoa53fglrNPNZQHSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006304; c=relaxed/simple;
	bh=R9gZlQcFm19g/tzZo0DHhmK4lPR0cmvjyhf5/rXglJ8=;
	h=Date:To:From:Subject:Message-Id; b=G2Ri0F6qwoBUzpHnLUxlCosMe1w/eoRAVpLv6foZmsQo/7tJbVWkOLMHnm2VP3BFqYvXs3n20L5SF+fA3Fopx9yC5707P4HntmLrhQwftoJvB/n53pJouA8dWKj33Ln1DInm44/FKbII3vykhoWaNokktqrulu8BLXZSDzScZzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SXeHlv+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SXeHlv+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7CAC4CED6;
	Thu, 16 Jan 2025 05:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006304;
	bh=R9gZlQcFm19g/tzZo0DHhmK4lPR0cmvjyhf5/rXglJ8=;
	h=Date:To:From:Subject:From;
	b=SXeHlv+lYRUS+NdguuujXxb4FhLjVIWR1S66h0qF4ZukQ6UAN7n+SvDDeYIdP3Q9P
	 TKDMMtUkQ+nOc8UYmioSPhiGCR1YFH8pZqMx8Kxt1mJyUnpDyOlzNYqlbZZvCgYXbo
	 vAM7yDUj4VGpogqwaFxu7F5WQ4JbDLIRDRFOgzCo=
Date: Wed, 15 Jan 2025 21:45:03 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,anshuman.khandual@arm.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-cow-modify-the-incorrect-checking-parameters.patch removed from -mm tree
Message-Id: <20250116054504.6D7CAC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/cow: modify the incorrect checking parameters
has been removed from the -mm tree.  Its filename was
     selftests-mm-cow-modify-the-incorrect-checking-parameters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: selftests/mm/cow: modify the incorrect checking parameters
Date: Mon, 13 Jan 2025 11:28:58 +0800

In run_with_memfd_hugetlb(), some error handle have passed incorrect
parameters.  It should be "smem", but it was mistakenly written as "mem".

Let's fix it.

[gehao@kylinos.cn: fix other errant sites, per Anshuman]
  Link: https://lkml.kernel.org/r/20250113050908.93638-1-hao.ge@linux.dev
Link: https://lkml.kernel.org/r/20250113032858.63670-1-hao.ge@linux.dev
Fixes: f8664f3c4a08 ("selftests/vm: cow: basic COW tests for non-anonymous pages")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-modify-the-incorrect-checking-parameters
+++ a/tools/testing/selftests/mm/cow.c
@@ -1482,7 +1482,7 @@ static void run_with_zeropage(non_anon_t
 	}
 
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANON, -1, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1583,7 +1583,7 @@ static void run_with_memfd(non_anon_test
 		goto close;
 	}
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1634,7 +1634,7 @@ static void run_with_tmpfile(non_anon_te
 		goto close;
 	}
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1684,7 +1684,7 @@ static void run_with_memfd_hugetlb(non_a
 		goto close;
 	}
 	smem = mmap(NULL, hugetlbsize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1696,7 +1696,7 @@ static void run_with_memfd_hugetlb(non_a
 	fn(mem, smem, hugetlbsize);
 munmap:
 	munmap(mem, hugetlbsize);
-	if (mem != MAP_FAILED)
+	if (smem != MAP_FAILED)
 		munmap(smem, hugetlbsize);
 close:
 	close(fd);
_

Patches currently in -mm which might be from gehao@kylinos.cn are


