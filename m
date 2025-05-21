Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D0922A7F3
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846647; cv=none; b=ZbWzCqs4d8WtBQTyHls9V1Ndv1Fp8rlkXwiRMv/0R/qwCaacwTjOQthovtMDTluZ0hs8P24/mVj/uxPqJXtqN8VjkSa8ak3Esf3ixfbCnj9huUrpp1dlps2IzDJW0fMUYPIdmJlgSHwdxWfpzC3VTnsM68umSdRZ/+1sarFPkj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846647; c=relaxed/simple;
	bh=I3AOxlw3t/+mafmblWoK0nszho3C5B9bjhwcvORBAIY=;
	h=Date:To:From:Subject:Message-Id; b=iQCizTDblT6y2dNJuUopO9a8uYea2B1v7l1PDPgdR6ODOuhoheUcbisEJ/RPcEWj6y/sF1HX6Z2DlSzOTKh6/8IN/LD0xxLkB2yzeANA3slh/clPf6nJEkapTpeiH+4YgfeEvrPUjOU4EMhuqZbg2kWg2QwNdhZrTannQMrs8GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YJ0DL/hZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YJ0DL/hZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C02C4CEE4;
	Wed, 21 May 2025 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846646;
	bh=I3AOxlw3t/+mafmblWoK0nszho3C5B9bjhwcvORBAIY=;
	h=Date:To:From:Subject:From;
	b=YJ0DL/hZpKbDWQOEc2KK5aZsaL98CVkPqpG5LqZjBfnqQsyg4uo4gIFzJW3uLi/2Y
	 3ESA3UUsn7odTBX6HF/0UhiLW15ausJNcDXbrLDUJtKceT5jdd0WzMrGKg6F1AR061
	 v+C2sHMIXPu4qT115at3MkPq+AJOLKx8L21f2SOs=
Date: Wed, 21 May 2025 09:57:26 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-deduplicate-second-mmap-of-5page_size-at-base.patch removed from -mm tree
Message-Id: <20250521165726.B6C02C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: deduplicate second mmap() of 5*PAGE_SIZE at base
has been removed from the -mm tree.  Its filename was
     selftests-mm-deduplicate-second-mmap-of-5page_size-at-base.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: deduplicate second mmap() of 5*PAGE_SIZE at base
Date: Sun, 18 May 2025 15:04:42 +0100

The map_fixed_noreplace test does two blocks of test starting from a
mapping of 5 pages at the base address, logging a test result for each
initial mapping.  These are logged with the same test name, causing test
automation software to see two reports for the same test in a single run. 
Tweak the log message for the second one to deduplicate.

Link: https://lkml.kernel.org/r/20250518-selftests-mm-map-fixed-noreplace-dup-v1-1-1a11a62c5e9f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/map_fixed_noreplace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/map_fixed_noreplace.c~selftests-mm-deduplicate-second-mmap-of-5page_size-at-base
+++ a/tools/testing/selftests/mm/map_fixed_noreplace.c
@@ -96,7 +96,7 @@ int main(void)
 		ksft_exit_fail_msg("Error:1: mmap() succeeded when it shouldn't have\n");
 	}
 	ksft_print_msg("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
-	ksft_test_result_pass("mmap() 5*PAGE_SIZE at base\n");
+	ksft_test_result_pass("Second mmap() 5*PAGE_SIZE at base\n");
 
 	/*
 	 * Second mapping contained within first:
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch
selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch

