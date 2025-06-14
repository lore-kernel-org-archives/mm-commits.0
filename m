Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E749D195
	for <mm-commits@vger.kernel.org>; Sat, 14 Jun 2025 00:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749859354; cv=none; b=XRW10qHxG+aAVPtFNBgb0U8268TVJxHzAEw5khOlmUDjkIcZcrSgvxjvKNGR8HmeufQECj8dXasdZPvdEt83GW3tlgdM117xaFoNvk7ETEa7jjHQ7J04lLq3zi5/YUhDU6Cp5FkchJHkk1fmeaZ7F8PnpBz3Sn18DfLflxUZv0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749859354; c=relaxed/simple;
	bh=v1oSiNLx2AlWGXrwqYzlvSwD2jW0MzLb746PtiiufeA=;
	h=Date:To:From:Subject:Message-Id; b=sLYX3Av37xpEbPt7LrZ6aqs8FR2KLmN0bJyGtebe2YccSMYCYyRuv17mrxBX/PDYVBlqiOFMPXYbPe3bLnIerHDBeb34hAeTOBVC7XSXDxYk5Sl307HqVkXRB4Xg3PaMceLlXSJGSI8dogG4ciSr4L5jLi2RG3Y6G7qsfguj8+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ofWnvgWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ofWnvgWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894CCC4CEE3;
	Sat, 14 Jun 2025 00:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749859353;
	bh=v1oSiNLx2AlWGXrwqYzlvSwD2jW0MzLb746PtiiufeA=;
	h=Date:To:From:Subject:From;
	b=ofWnvgWShlCXc0E9VsTo+Toy5pspvMVJBBqh8uD6lwm2F+w+RRoWgIYQw11WGRaOc
	 QYSmdb6GR3h+2WinIuWHGJU0skVMI0TTyROD5pHprxzL4VofZOHZpML3ZLRM11Oo2N
	 JubaezdLywKYHS2Oodesojh3wTZ15xqgXZBLI/6w=
Date: Fri, 13 Jun 2025 17:02:32 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-skip-if-fallocate-is-unsupported-in-gup_longterm.patch added to mm-new branch
Message-Id: <20250614000233.894CCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/mm: skip if fallocate() is unsupported in gup_longterm
has been added to the -mm mm-new branch.  Its filename is
     selftest-mm-skip-if-fallocate-is-unsupported-in-gup_longterm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-skip-if-fallocate-is-unsupported-in-gup_longterm.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: selftest/mm: skip if fallocate() is unsupported in gup_longterm
Date: Fri, 13 Jun 2025 12:44:07 +0100

Currently gup_longterm assumes that filesystems support fallocate() and
uses that to allocate space in files, however this is an optional feature
and is in particular not implemented by NFSv3 which is commonly used in CI
systems leading to spurious failures.  Check for lack of support and
report a skip instead for that case.

Link: https://lkml.kernel.org/r/20250613-selftest-mm-gup-longterm-fallocate-nfs-v1-1-758a104c175f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftest-mm-skip-if-fallocate-is-unsupported-in-gup_longterm
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -114,7 +114,15 @@ static void do_test(int fd, size_t size,
 	}
 
 	if (fallocate(fd, 0, 0, size)) {
-		if (size == pagesize) {
+		/*
+		 * Some filesystems (eg, NFSv3) don't support
+		 * fallocate(), report this as a skip rather than a
+		 * test failure.
+		 */
+		if (errno == EOPNOTSUPP) {
+			ksft_print_msg("fallocate() not supported by filesystem\n");
+			result = KSFT_SKIP;
+		} else if (size == pagesize) {
 			ksft_print_msg("fallocate() failed (%s)\n", strerror(errno));
 			result = KSFT_FAIL;
 		} else {
_

Patches currently in -mm which might be from broonie@kernel.org are

kselftest-mm-clarify-errors-for-pipe.patch
selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch
selftests-mm-dont-compare-return-values-to-in-cow.patch
selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch
selftests-mm-check-for-yama-ptrace_scope-configuraiton-before-modifying-it.patch
selftest-mm-skip-if-fallocate-is-unsupported-in-gup_longterm.patch

