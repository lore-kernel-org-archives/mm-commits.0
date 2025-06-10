Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07EC2327A7
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585701; cv=none; b=oeAtNDha2KeVaE9RmAuteVIRskjuQcJN3vjn2ZBOPuIc/4SlyEbxDZTbLdH8P3/3CQ/PEAjGUtBt7tZG5IXb3H718qmKQRKf4glcTnQ67oIS6mNsTY85ghH0667FkXlT8Qpb+XL4THrxLFWYOEi3ztsQkS9uxZ72qi9+vQH7Soc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585701; c=relaxed/simple;
	bh=/9QAk7RdI8SzZB3oIltQZP5Np+qW2MRO0T/hLYz5DEA=;
	h=Date:To:From:Subject:Message-Id; b=g7EgEiyNpKjNGYXAu/Knwsxfd6nJDKbIP4xfjd/TKWHUQuhgAE3xUu7aMJqG1OO09RKOTq/tsCWpriLnC7+PfaDdoL1dhqIVrFr0YqMb81GucRufNYmopfkKptVFYxv52fCxqUgQuVet9Pbs0s8NXZ+9JsTKh0fGJbPNBQKvXIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uWEep5sD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uWEep5sD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD83C4CEED;
	Tue, 10 Jun 2025 20:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749585701;
	bh=/9QAk7RdI8SzZB3oIltQZP5Np+qW2MRO0T/hLYz5DEA=;
	h=Date:To:From:Subject:From;
	b=uWEep5sDxrsNhFLQKUx3UhmDgZEcF99u79FQDBm5BGc2zuwtX4q6DtWLZOqO/eIPo
	 wQYPs8rAGnw3xeYBQZF24tDvEI1Vf39E/dI0T2InkjifaYu69KJcnutYeWJbDJdHLW
	 EoBkZ3F2tLvvgqGFgs6djv/UnyWzAaM4dS/l0jmw=
Date: Tue, 10 Jun 2025 13:01:41 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch added to mm-new branch
Message-Id: <20250610200141.9BD83C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add messages about test errors to the cow tests
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch

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
Subject: selftests/mm: add messages about test errors to the cow tests
Date: Tue, 10 Jun 2025 15:13:57 +0100

It is not sufficiently clear what the individual tests in the cow test
program are checking so add messages for the failure cases.

Link: https://lkml.kernel.org/r/20250610-selftest-mm-cow-tweaks-v1-4-43cd7457500f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-add-messages-about-test-errors-to-the-cow-tests
+++ a/tools/testing/selftests/mm/cow.c
@@ -268,8 +268,10 @@ static void do_test_cow_in_parent(char *
 		 * fail because (a) harder to fix and (b) nobody really cares.
 		 * Flag them as expected failure for now.
 		 */
+		ksft_print_msg("Leak from parent into child\n");
 		log_test_result(KSFT_XFAIL);
 	} else {
+		ksft_print_msg("Leak from parent into child\n");
 		log_test_result(KSFT_FAIL);
 	}
 close_comm_pipes:
@@ -397,8 +399,10 @@ static void do_test_vmsplice_in_parent(c
 		 * fail because (a) harder to fix and (b) nobody really cares.
 		 * Flag them as expected failure for now.
 		 */
+		ksft_print_msg("Leak from child into parent\n");
 		log_test_result(KSFT_XFAIL);
 	} else {
+		ksft_print_msg("Leak from child into parent\n");
 		log_test_result(KSFT_FAIL);
 	}
 close_pipe:
@@ -570,10 +574,12 @@ static void do_test_iouring(char *mem, s
 	}
 
 	/* Finally, check if we read what we expected. */
-	if (!memcmp(mem, tmp, size))
+	if (!memcmp(mem, tmp, size)) {
 		log_test_result(KSFT_PASS);
-	else
+	} else {
+		ksft_print_msg("Longtom R/W pin is not reliable\n");
 		log_test_result(KSFT_FAIL);
+	}
 
 quit_child:
 	if (use_fork) {
@@ -725,10 +731,12 @@ static void do_test_ro_pin(char *mem, si
 		ksft_perror("PIN_LONGTERM_TEST_READ failed");
 		log_test_result(KSFT_FAIL);
 	} else {
-		if (!memcmp(mem, tmp, size))
+		if (!memcmp(mem, tmp, size)) {
 			log_test_result(KSFT_PASS);
-		else
+		} else {
+			ksft_print_msg("Longterm R/O pin is not reliable\n");
 			log_test_result(KSFT_FAIL);
+		}
 	}
 
 	ret = ioctl(gup_fd, PIN_LONGTERM_TEST_STOP);
@@ -1417,10 +1425,12 @@ static void do_test_anon_thp_collapse(ch
 	else
 		ret = -EINVAL;
 
-	if (!ret)
+	if (!ret) {
 		log_test_result(KSFT_PASS);
-	else
+	} else {
+		ksft_print_msg("Leak from parent into child\n");
 		log_test_result(KSFT_FAIL);
+	}
 close_comm_pipes:
 	close_comm_pipes(&comm_pipes);
 }
@@ -1528,10 +1538,12 @@ static void test_cow(char *mem, const ch
 	memset(mem, 0xff, size);
 
 	/* See if we still read the old values via the other mapping. */
-	if (!memcmp(smem, old, size))
+	if (!memcmp(smem, old, size)) {
 		log_test_result(KSFT_PASS);
-	else
+	} else {
+		ksft_print_msg("Other mapping modified\n");
 		log_test_result(KSFT_FAIL);
+	}
 	free(old);
 }
 
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-skip-failed-memfd-setups-in-gup_longterm.patch
kselftest-mm-clarify-errors-for-pipe.patch
selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch
selftests-mm-dont-compare-return-values-to-in-cow.patch
selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch

