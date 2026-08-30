Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A658481B1;
	Sun, 30 Aug 2026 01:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788053201; cv=none; b=Jn6mlEtum6RBcqaGLV19L6kRleAqPwtIxNbTtMoliHdzXFmGn9s8SfSXL6chASHzIHKc5dytA/3wv7cpzX7W3hUPoYkAemdxKyCiYtspYcSArk+6PTjK1lphy4QRFGQKqAtWp/hgvGvlFFLg3AaYyQr4GKu32/NlIoqZLQzx1WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788053201; c=relaxed/simple;
	bh=oGragZfWtSfRjhr2w1sNNggVxLSrWL4DNP9pL7y0Ozk=;
	h=Date:To:From:Subject:Message-Id; b=YbMGQHz8OZDbqBE7cvbBwTiqekD97iOMpYxdcTNwrUWwd5hYCzxGIstnB1koJ1cQcDFGOZGL9YNZJeBuJqvC2i0smZcGIzmfA5pXz4AvEemPfKNo7AuflhujqkU9j7kBwNKInZDvxwgex76uOItxATnAkSKYOrM0hqRX+MQKn7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PU3wd0vz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PU3wd0vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DDB1F000E9;
	Sun, 30 Aug 2026 01:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788053199;
	bh=H4T2D0+HLot5SSZRrFOhZBM8jxVbsJi10WNyInAes+c=;
	h=Date:To:From:Subject;
	b=PU3wd0vzdW14cNzNY5J3kKlJHGOSoWi3bj7bt8tiMDPDt/ZIV8X6crSoxAbB6b/JC
	 +QOOUehD6RXO9zPpXHkHBvzppl24ZioYugXEz8zFy1BegUuOjmJ+Q/3/sAB63+bfG/
	 ittPXoQWl19As2UPLdsMDMyQgmpgovyL62kKUfxE=
Date: Sat, 29 Aug 2026 18:26:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,eva.kurchatova@virtuozzo.com,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-core-fix-unshare_test-with-large-fsnr_open.patch added to mm-nonmm-unstable branch
Message-Id: <20260830012639.82DDB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/core: fix unshare_test with large fs.nr_open
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-core-fix-unshare_test-with-large-fsnr_open.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-core-fix-unshare_test-with-large-fsnr_open.patch

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
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: selftests/core: fix unshare_test with large fs.nr_open
Date: Fri, 14 Aug 2026 18:57:09 +0200

The test assumes fs.nr_open is close to the default 1048576, but some
systems set it much higher (e.g.  1073741816).  This is systemd's doing:
since systemd v240 (2018), PID 1 bumps fs.nr_open and fs.file-max to their
largest possible values on boot, as file descriptors are already accounted
for by memcg [1].

In that case, dup2() to nr_open + 64 requires the kernel to allocate a
file descriptor table with ~1 billion entries, which fails with ENOMEM.

Cap the nr_open value used for the test's own arithmetic to a known
reasonable base value (1048576) and restore the true original value once
the test has completed.

Link: https://lore.kernel.org/20260814165709.513263-1-khorenko@virtuozzo.com
Link: https://github.com/systemd/systemd/commit/a8b627aaed409a15260c25988970c795bf963812 [1]
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/core/unshare_test.c |   19 ++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/core/unshare_test.c~selftests-core-fix-unshare_test-with-large-fsnr_open
+++ a/tools/testing/selftests/core/unshare_test.c
@@ -40,6 +40,14 @@ TEST(unshare_EMFILE)
 
 	ASSERT_EQ(sscanf(buf, "%d", &nr_open), 1);
 
+	/*
+	 * Cap nr_open for the duration of the test to avoid ENOMEM from a
+	 * huge fd table allocation; buf/n keep the real original value so
+	 * fs.nr_open can be restored to it once the test is done.
+	 */
+	if (nr_open > 1024 * 1024)
+		nr_open = 1024 * 1024;
+
 	ASSERT_EQ(0, getrlimit(RLIMIT_NOFILE, &rlimit));
 
 	/* bump fs.nr_open */
@@ -73,10 +81,13 @@ TEST(unshare_EMFILE)
 
 	if (pid == 0) {
 		int err;
+		char buf3[32];
+		ssize_t n3;
 
-		/* restore fs.nr_open */
+		/* restore fs.nr_open to the (possibly capped) test baseline */
+		n3 = sprintf(buf3, "%d\n", nr_open);
 		lseek(fd, 0, SEEK_SET);
-		write(fd, buf, n);
+		write(fd, buf3, n3);
 		/* ... and now unshare(CLONE_FILES) must fail with EMFILE */
 		err = unshare(CLONE_FILES);
 		EXPECT_EQ(err, -1)
@@ -89,6 +100,10 @@ TEST(unshare_EMFILE)
 	EXPECT_EQ(waitpid(pid, &status, 0), pid);
 	EXPECT_EQ(true, WIFEXITED(status));
 	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	/* restore the real fs.nr_open value */
+	lseek(fd, 0, SEEK_SET);
+	write(fd, buf, n);
 }
 
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

selftests-core-fix-unshare_test-with-large-fsnr_open.patch

