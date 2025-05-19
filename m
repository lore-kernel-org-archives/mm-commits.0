Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B701FDE22
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 22:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747694015; cv=none; b=s3e7hZhyC5tWeCgALXmb4Bxzf88Ro9HxkqSZ5ZlsNkftsTaBvKST7MCVumWBu2vuObO4ZyN5U2aDopv83Tgq0GENVYma9aAup6yJlGoxwAUGRI8eWYzEVL62aDkXDhWD1tvkln2GK4NB17pw0WF4Eppa4F/3HON2h1ubn5a6BOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747694015; c=relaxed/simple;
	bh=NDS41H7wVz4NaWeX2JVa+flUOv4zTj+h/P1ZW8MTrrQ=;
	h=Date:To:From:Subject:Message-Id; b=BrZgiLUfs+ZpXlDpMpzdq673jr0XrRiRVFNAUE/bgEcjJhVXVqIW2KkaAVDvBghV62UXhpRii6Y0/MMa9KN4j65fm0kjtfi05AdPo023iPqg2lXoIUo8GR+zwyAXE2NDQwIq+LQdvBepeyTgvXiSlU/LGh2t1W6Y9V0M37rsOSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E2+gTNGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E2+gTNGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BEFC4CEE4;
	Mon, 19 May 2025 22:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747694014;
	bh=NDS41H7wVz4NaWeX2JVa+flUOv4zTj+h/P1ZW8MTrrQ=;
	h=Date:To:From:Subject:From;
	b=E2+gTNGnOidG223A6MRq0/a+TBIz9cJzN+1eBFA6lkMZsCxHS3ij581U6VnPPhbXq
	 TVN11ffxHNL2jYT68rQgya4jbU4Oje18JSyoiJXLz2lKq8+DpQcr7bO5quy2Yyc3WW
	 aChXMfB5KscwwNX/pbnSZKyrqxT0XaFC3IIf4Zv0=
Date: Mon, 19 May 2025 15:33:34 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-deduplicate-second-mmap-of-5page_size-at-base.patch added to mm-unstable branch
Message-Id: <20250519223334.A0BEFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: deduplicate second mmap() of 5*PAGE_SIZE at base
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-deduplicate-second-mmap-of-5page_size-at-base.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-deduplicate-second-mmap-of-5page_size-at-base.patch

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

selftests-mm-deduplicate-second-mmap-of-5page_size-at-base.patch
selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch
selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch

