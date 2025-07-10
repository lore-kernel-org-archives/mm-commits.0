Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECBA28505D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126265; cv=none; b=mh4WwXaiVneFRHi0Sfp8vfIYBYEt3O/7JimQJwXkFXiRsFjHi+t9wYKM5Ac0QZCAo9Y0/y2anM0z5v1DWqSeJWkgp9OuLkTy+YlFv8IqGVx2MMCth27IVPPJOcGa0jkaOOQOHh535g35gc7MwWExoQMZ0LL4A+et/HIzryDIw04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126265; c=relaxed/simple;
	bh=riLHmNMhaEe5ViZxi8KrLxkP9jFn2yS2BZzvkPt8weQ=;
	h=Date:To:From:Subject:Message-Id; b=a69+IG/lOb2NHVZra+CI+FvW/fyEQu/s98649DTDu8WFyNu9P6WSlNZ0GZK75B1lk7AzpOca9Tk89Y93XQabQRvw3tfAWJ0qlkJuo2pdj2aqshq81W3hfi4AKWfHfonU280+NYkvjUg0DNJMiyOfA2BJuMyEgAs5gupxOH+k5bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=leJFWAdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="leJFWAdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2530C4CEE3;
	Thu, 10 Jul 2025 05:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126264;
	bh=riLHmNMhaEe5ViZxi8KrLxkP9jFn2yS2BZzvkPt8weQ=;
	h=Date:To:From:Subject:From;
	b=leJFWAdWB4ffUCxy2pIbVtcIiZxF9jgvpXocXiMrNe/38nz3Emwhz6mZnTjP6Qg7V
	 Obx/Zev78l7gAe16WTDfE9uswbh+fILIE2Cbew4DD9y9aZDvVexq5tyN2KCkGYOrHh
	 WxjXf/iw9q+ODPDevBEBIuTO18bbxx7pb9wVwdPY=
Date: Wed, 09 Jul 2025 22:44:24 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch removed from -mm tree
Message-Id: <20250710054424.C2530C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add messages about test errors to the cow tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: add messages about test errors to the cow tests
Date: Tue, 10 Jun 2025 15:13:57 +0100

It is not sufficiently clear what the individual tests in the cow test
program are checking so add messages for the failure cases.

Link: https://lkml.kernel.org/r/20250610-selftest-mm-cow-tweaks-v1-4-43cd7457500f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
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


