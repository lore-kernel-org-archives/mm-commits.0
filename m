Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F692327A7
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585699; cv=none; b=hRbGvMFjWvLtts5EvRaFIZGeDL1LGNH62R5IDbLLSbeOdXWcekF1C7n4kUSyKHhPXmfJxGTsJE+bBu4YSjqyY1h9NHluvU0c0KzTc4kZuOppVqKY/soHWjWpsdfnjdL6ifZRCO2bLgiTw0NSfzULbSwO8udt4rNrcxPzvoKbUU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585699; c=relaxed/simple;
	bh=4p28bdRP7v0efAh8OU+vhzDTKPyWZ54WggEqse6hOyU=;
	h=Date:To:From:Subject:Message-Id; b=SRjaUzqz1WBrowfi63CKJUS/zW6qQEf1VqN5YaudOeATbYc7hSg/jZpFMe0u0z5Kr/3U6vviGgvnyybJYCkaTprg6PyAsdhoud2WidANbe0GJvgwRE2+c8bWA7Lqd/GseQxRVnYbKBCKMSbtXM98rJum1hIeRsTs1jFACEVLN6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ORq/Var6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ORq/Var6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F21C4CEED;
	Tue, 10 Jun 2025 20:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749585697;
	bh=4p28bdRP7v0efAh8OU+vhzDTKPyWZ54WggEqse6hOyU=;
	h=Date:To:From:Subject:From;
	b=ORq/Var62mhYTp+KnJ7uXH7S4ItvQaHzHvogX1oFOvDOBZvm5zaN+atRXjwF19OU3
	 NWozchSH9brp0nQw/bb8hCJ6pvR5vzq5v8eSYCc4szPfSRKfFGJ4aE7ED7zfS3emDs
	 w+VtGdQL4VFfcl6kkDyVXh6wOBmkCkyJmzXM2/RA=
Date: Tue, 10 Jun 2025 13:01:37 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch added to mm-new branch
Message-Id: <20250610200137.A1F21C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: convert some cow error reports to ksft_perror()
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch

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
Subject: selftests/mm: convert some cow error reports to ksft_perror()
Date: Tue, 10 Jun 2025 15:13:55 +0100

This prints the errno and a string decode of it.

Link: https://lkml.kernel.org/r/20250610-selftest-mm-cow-tweaks-v1-2-43cd7457500f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Reported-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-convert-some-cow-error-reports-to-ksft_perror
+++ a/tools/testing/selftests/mm/cow.c
@@ -332,7 +332,7 @@ static void do_test_vmsplice_in_parent(c
 	if (before_fork) {
 		transferred = vmsplice(fds[1], &iov, 1, 0);
 		if (transferred <= 0) {
-			ksft_print_msg("vmsplice() failed\n");
+			ksft_perror("vmsplice() failed\n");
 			log_test_result(KSFT_FAIL);
 			goto close_pipe;
 		}
@@ -562,7 +562,7 @@ static void do_test_iouring(char *mem, s
 	while (total < size) {
 		cur = pread(fd, tmp + total, size - total, total);
 		if (cur < 0) {
-			ksft_print_msg("pread() failed\n");
+			ksft_perror("pread() failed\n");
 			log_test_result(KSFT_FAIL);
 			goto quit_child;
 		}
@@ -628,7 +628,7 @@ static void do_test_ro_pin(char *mem, si
 
 	tmp = malloc(size);
 	if (!tmp) {
-		ksft_print_msg("malloc() failed\n");
+		ksft_perror("malloc() failed\n");
 		log_test_result(KSFT_FAIL);
 		return;
 	}
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-skip-failed-memfd-setups-in-gup_longterm.patch
kselftest-mm-clarify-errors-for-pipe.patch
selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch
selftests-mm-dont-compare-return-values-to-in-cow.patch
selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch

