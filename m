Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3478285069
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126263; cv=none; b=ry1kDCK8kMoJMN72Azqb1esnpw6K2QJQQcmgcWJzSOAvK9oCWet6017+eKjfx/S3BRCpyp3wmqzFQgrBjlcWAvpzQaCt5MkgWavxBFv5koop2pg0xcOsJsz4cdHuvVcPk1SDeIODatwnatRNFyZ9MMVSwtnESGefcp6mkI30EaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126263; c=relaxed/simple;
	bh=zwwg/wSR68/KjaXJx9gGo4wpqzLpneOT4RXb8hfF1Dk=;
	h=Date:To:From:Subject:Message-Id; b=u6D/ERAKD8jGd1iWIootS4/zM7bIivNrLS7ZFNrwjoA6vi3EYFadi28s5D3VayOcA7dKLlcJh92nOBLHjyzSOwZ9ibEC9hZJb8iibwm+Y2b7V16mRUvVWpEFtmSs2+Yrmc5yYgN7DEFV0P5XrD0PdUmooR+P7VG1rP2piZDWVV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y5+BJxLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y5+BJxLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E40C4CEE3;
	Thu, 10 Jul 2025 05:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126263;
	bh=zwwg/wSR68/KjaXJx9gGo4wpqzLpneOT4RXb8hfF1Dk=;
	h=Date:To:From:Subject:From;
	b=y5+BJxLNhovB7fvTjVisJSpv9cR4pJblLZz5fUwd7zAjy6XEEYeikmQf2OzKCMeby
	 L7nNiC84Of1lMicVdg1lJ0/h0OcgG+O4FOoI6KihIxqg+8agX4AhvbRbZEsos2uImh
	 5XYNz7eBY2XFPiLou6g8GsVdzw4Xon0V9i9pYA4M=
Date: Wed, 09 Jul 2025 22:44:23 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-dont-compare-return-values-to-in-cow.patch removed from -mm tree
Message-Id: <20250710054423.A5E40C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: don't compare return values to in cow
has been removed from the -mm tree.  Its filename was
     selftests-mm-dont-compare-return-values-to-in-cow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: don't compare return values to in cow
Date: Tue, 10 Jun 2025 15:13:56 +0100

Tweak the coding style for checking for non-zero return values.
While we're at it also remove a now redundant oring of the madvise()
return code.

Link: https://lkml.kernel.org/r/20250610-selftest-mm-cow-tweaks-v1-3-43cd7457500f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-dont-compare-return-values-to-in-cow
+++ a/tools/testing/selftests/mm/cow.c
@@ -1613,13 +1613,13 @@ static void run_with_huge_zeropage(non_a
 	smem = (char *)(((uintptr_t)mmap_smem + pmdsize) & ~(pmdsize - 1));
 
 	ret = madvise(mem, pmdsize, MADV_HUGEPAGE);
-	if (ret != 0) {
+	if (ret) {
 		ksft_perror("madvise()");
 		log_test_result(KSFT_FAIL);
 		goto munmap;
 	}
-	ret |= madvise(smem, pmdsize, MADV_HUGEPAGE);
-	if (ret != 0) {
+	ret = madvise(smem, pmdsize, MADV_HUGEPAGE);
+	if (ret) {
 		ksft_perror("madvise()");
 		log_test_result(KSFT_FAIL);
 		goto munmap;
_

Patches currently in -mm which might be from broonie@kernel.org are


