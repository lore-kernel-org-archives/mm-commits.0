Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BD1371CE4
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028756; cv=none; b=bYlorgIPKtyQXImCFYoTJhI4p6dY3qMO2lbTClf/IJzIKTv+zwfu9Uyp1rTjv1ato6eWHrFoYBGr413P7M1QuGy6FMeMrYUTdozObuKKp872GjM1G91+tA6nG+JPCSh/okQrAsT10y5Yv+6TShwnZUVio5TEeh3GrqpcS+wkEYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028756; c=relaxed/simple;
	bh=ikmmC0yQbXTjmabqEYzfxfTqtWY7hYEJ1vj2Y43x71Y=;
	h=Date:To:From:Subject:Message-Id; b=eJnQFxEkIKiQcURjS/23f1T3OrYsm73hgi2XLhv2OUiV//YfnJt4yMPTSvrtx4C/7+99mZklWJiOz2xpN4btC2yxt40FaWs6FLKz1dAGVNiHB9coO0pNUFMswyaivUYdbKCM5Qb0mfh98vSvmTxrglyMwd7tkGGL00mbcO9GzFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gz4veXoq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gz4veXoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E941F00893;
	Fri, 29 May 2026 04:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028754;
	bh=aKY0PL8INziJsUahAHdv1c7m6+dszjwupJHRmPd+8Rs=;
	h=Date:To:From:Subject;
	b=gz4veXoqWzviw5+eEgd+FLYcSfiRe3QdAPbON3FXwZPIJLW8WVIrS+kBHtwlAb9VE
	 SFN1PdO2m0FeiWzApo1TJ46vkgWcXBeB0kAAm+xamgsxJSgNSQ0tK77SGs8UunSFey
	 F2jSDjz3FGRb/4XM459fI5K36bWFuRmFf9ZVmGg0=
Date: Thu, 28 May 2026 21:25:54 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jlayton@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kselftest-filelock-report-each-test-in-oftlocks-separately.patch removed from -mm tree
Message-Id: <20260529042554.79E941F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest/filelock: report each test in oftlocks separately
has been removed from the -mm tree.  Its filename was
     kselftest-filelock-report-each-test-in-oftlocks-separately.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


