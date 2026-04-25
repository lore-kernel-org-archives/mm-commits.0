Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE77BA3D
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 18:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777142284; cv=none; b=Zndk/SDRwbZwUtJprs2elFYOLTitVXxtPkOYtbdPsO2D9HOEwz3kVUFqFHS/ll17DBV0+BoiBVevNZ1W4bT1UJOjuHq9tTNjcISRrK/iRxROApdNLlsAcgwJJb2ZotMTyvDxdqLRW8stPZRH1/R7Lgqt0NBdnIyVTphRWk9JnTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777142284; c=relaxed/simple;
	bh=hDPplvEyUrRSb/vmT3Pk4s34jHB5yr3aJKuZxb5ZFM8=;
	h=Date:To:From:Subject:Message-Id; b=Z0T2Eie4xC2U3XqBmJiUiyA1ZmY705URqJw0yrR/u2uFBofhzXte3FN20epfCyIF928kmMdBC024237+KGNSjmzzigJ0icaIuXPkG31pHyqx9KiU6bt3ut5+hhJCORWfzURlfDtFOyLwFwv5U8X9uOXHScMwqT0LAC/E2L2ukFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q4mZPapu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q4mZPapu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D75C2BCB0;
	Sat, 25 Apr 2026 18:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777142283;
	bh=hDPplvEyUrRSb/vmT3Pk4s34jHB5yr3aJKuZxb5ZFM8=;
	h=Date:To:From:Subject:From;
	b=q4mZPapuaCKuUrCf+F0nFt70LaTAuJwEqa0Qz+zkeQGZ/NA9JWZLzW64nOvqe9IdY
	 V2KQElh943lh3CLHaW93VNCbcttDdwxkywKmyhw7kyTZSJalHdrmeaX+Homaed88y7
	 +1PTrZsv4f+ynVuUzcW8RiaPFOAJQUUwiTp0LUmw=
Date: Sat, 25 Apr 2026 11:38:02 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jlayton@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-filelock-report-each-test-in-oftlocks-separately.patch added to mm-nonmm-unstable branch
Message-Id: <20260425183803.86D75C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest/filelock: report each test in oftlocks separately
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kselftest-filelock-report-each-test-in-oftlocks-separately.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-filelock-report-each-test-in-oftlocks-separately.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: kselftest/filelock: report each test in oftlocks separately
Date: Thu, 26 Feb 2026 16:05:26 +0000

The filelock test checks four different things but only reports an overall
status, convert to use ksft_test_result() for these individual tests. 
Each test depends on the previous ones so we still bail out if any of them
fail but we get a bit more information from UIs parsing the results.

Link: https://lore.kernel.org/20260226-selftest-filelock-ktap-v4-2-db8ae192ff42@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filelock/ofdlocks.c |   90 +++++++-----------
 1 file changed, 39 insertions(+), 51 deletions(-)

--- a/tools/testing/selftests/filelock/ofdlocks.c~kselftest-filelock-report-each-test-in-oftlocks-separately
+++ a/tools/testing/selftests/filelock/ofdlocks.c
@@ -39,94 +39,82 @@ int main(void)
 	int fd = open("/tmp/aa", O_RDWR | O_CREAT | O_EXCL, 0600);
 	int fd2 = open("/tmp/aa", O_RDONLY);
 
+	ksft_print_header();
+	ksft_set_plan(4);
+
 	unlink("/tmp/aa");
 	assert(fd != -1);
 	assert(fd2 != -1);
-	ksft_print_msg("[INFO] opened fds %i %i\n", fd, fd2);
+	ksft_print_msg("opened fds %i %i\n", fd, fd2);
 
 	/* Set some read lock */
 	fl.l_type = F_RDLCK;
 	fl.l_start = 5;
 	fl.l_len = 3;
 	rc = lock_set(fd, &fl);
-	if (rc == 0) {
-		ksft_print_msg
-		    ("[SUCCESS] set OFD read lock on first fd\n");
-	} else {
-		ksft_print_msg("[FAIL] to set OFD read lock on first fd\n");
-		return -1;
-	}
+	ksft_test_result(rc == 0, "set OFD read lock on first fd\n");
+	if (rc != 0)
+		ksft_finished();
+
 	/* Make sure read locks do not conflict on different fds. */
 	fl.l_type = F_RDLCK;
 	fl.l_start = 5;
 	fl.l_len = 1;
 	rc = lock_get(fd2, &fl);
 	if (rc != 0)
-		return -1;
-	if (fl.l_type != F_UNLCK) {
-		ksft_print_msg("[FAIL] read locks conflicted\n");
-		return -1;
-	}
+		ksft_finished();
+	if (fl.l_type != F_UNLCK)
+		ksft_exit_fail_msg("read locks conflicted\n");
+
 	/* Make sure read/write locks do conflict on different fds. */
 	fl.l_type = F_WRLCK;
 	fl.l_start = 5;
 	fl.l_len = 1;
 	rc = lock_get(fd2, &fl);
 	if (rc != 0)
-		return -1;
-	if (fl.l_type != F_UNLCK) {
-		ksft_print_msg
-		    ("[SUCCESS] read and write locks conflicted\n");
-	} else {
-		ksft_print_msg
-		    ("[SUCCESS] read and write locks not conflicted\n");
-		return -1;
-	}
+		ksft_finished();
+	ksft_test_result(fl.l_type != F_UNLCK,
+			 "read and write locks conflicted\n");
+	if (fl.l_type == F_UNLCK)
+		ksft_finished();
+
 	/* Get info about the lock on first fd. */
 	fl.l_type = F_UNLCK;
 	fl.l_start = 5;
 	fl.l_len = 1;
 	rc = lock_get(fd, &fl);
-	if (rc != 0) {
-		ksft_print_msg
-		    ("[FAIL] F_OFD_GETLK with F_UNLCK not supported\n");
-		return -1;
-	}
-	if (fl.l_type != F_UNLCK) {
-		ksft_print_msg
-		    ("[SUCCESS] F_UNLCK test returns: locked, type %i pid %i len %zi\n",
-		     fl.l_type, fl.l_pid, fl.l_len);
-	} else {
-		ksft_print_msg
-		    ("[FAIL] F_OFD_GETLK with F_UNLCK did not return lock info\n");
-		return -1;
-	}
+	if (rc != 0)
+		ksft_exit_fail_msg("F_OFD_GETLK with F_UNLCK not supported\n");
+	ksft_test_result(fl.l_type != F_UNLCK,
+			 "F_OFD_GETLK with F_UNLCK returned lock info\n");
+	if (fl.l_type == F_UNLCK)
+		ksft_exit_fail();
+	ksft_print_msg("F_UNLCK test returns: locked, type %i pid %i len %zi\n",
+		       fl.l_type, fl.l_pid, fl.l_len);
+
 	/* Try the same but by locking everything by len==0. */
 	fl2.l_type = F_UNLCK;
 	fl2.l_start = 0;
 	fl2.l_len = 0;
 	rc = lock_get(fd, &fl2);
-	if (rc != 0) {
-		ksft_print_msg
-		    ("[FAIL] F_OFD_GETLK with F_UNLCK not supported\n");
-		return -1;
-	}
+	if (rc != 0)
+		ksft_exit_fail_msg
+		    ("F_OFD_GETLK with F_UNLCK not supported\n");
+	ksft_test_result(memcmp(&fl, &fl2, sizeof(fl)) == 0,
+			 "F_UNLCK with len==0 returned the same\n");
 	if (memcmp(&fl, &fl2, sizeof(fl))) {
-		ksft_print_msg
-		    ("[FAIL] F_UNLCK test returns: locked, type %i pid %i len %zi\n",
+		ksft_exit_fail_msg
+		    ("F_UNLCK test returns: locked, type %i pid %i len %zi\n",
 		     fl.l_type, fl.l_pid, fl.l_len);
-		return -1;
 	}
-	ksft_print_msg("[SUCCESS] F_UNLCK with len==0 returned the same\n");
+
 	/* Get info about the lock on second fd - no locks on it. */
 	fl.l_type = F_UNLCK;
 	fl.l_start = 0;
 	fl.l_len = 0;
 	lock_get(fd2, &fl);
-	if (fl.l_type != F_UNLCK) {
-		ksft_print_msg
-		    ("[FAIL] F_OFD_GETLK with F_UNLCK return lock info from another fd\n");
-		return -1;
-	}
-	return 0;
+	ksft_test_result(fl.l_type == F_UNLCK,
+			 "F_OFD_GETLK with F_UNLCK return lock info from another fd\n");
+
+	ksft_finished();
 }
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-specify-requirement-for-proc_mem_always_force=y.patch
kselftest-filelock-use-ksft_perror.patch
kselftest-filelock-report-each-test-in-oftlocks-separately.patch
kselftest-filelock-add-a-gitignore-file.patch

