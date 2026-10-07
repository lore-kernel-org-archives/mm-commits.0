Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4F217A2F6;
	Wed,  7 Oct 2026 02:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338664; cv=none; b=HbRD1pUT9O0vyUUKDMNuPiH5QVc3UCb9Bv8ciyMlfX+i22CXPBvMhuM9zP8TM08D4c82nL0oUT9iyppMBHGY9CAsRnwmu+pB2537e7AS9xv9BluOTX/9BQiCPQYuzHdwFPSjli238hi5LrFyyOwansogsUfoS+VDTl9fWODHoTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338664; c=relaxed/simple;
	bh=lvVRA69GMu4TysbVZCWE6FO2WDGUPOAuhpulAOE9PIg=;
	h=Date:To:From:Subject:Message-Id; b=m3c9CAqhs5N/Nc5Pc5/NFF8ilB7h3fy4faOZdgECe/Db3G0F47Z9Zr22t43tUpIFlgMPAnlSmySNjENg2k9TibVwI7ONmNt3xTVmrb5AI+U+yhPr+7a/+s/Bt9KsVz8dVgTk9ptAHtPqsftjBq/OEJesE9ZT6qqFPadNovqZ1TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ugc/biyQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ugc/biyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31261F0089B;
	Wed,  7 Oct 2026 02:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338663;
	bh=0BKFVlNDmuBiYnoqtrNEMjHDaYGWOZ3c2gzNR2UimpQ=;
	h=Date:To:From:Subject;
	b=Ugc/biyQwqEgYZdywM67eV49Lc5bYpnmmFb1SHIzTolj8LKuVTmkwB6BWcEbKp+Qu
	 A07ca7WAJiparUmRqhPi59V9P8rPj/JpbFFcYmaYJgzN3XzfTPxxD4ATbZcMwaWGvH
	 l2ZMzA3MkLVgrm55MQ3zIN0ebiLKFW6DZZxcIMVM=
Date: Tue, 06 Oct 2026 19:04:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,eva.kurchatova@virtuozzo.com,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-core-fix-unshare_test-with-large-fsnr_open.patch removed from -mm tree
Message-Id: <20261007020423.A31261F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/core: fix unshare_test with large fs.nr_open
has been removed from the -mm tree.  Its filename was
     selftests-core-fix-unshare_test-with-large-fsnr_open.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

On a kernel that already carries 04a2c4b4511d1, dup2() no longer fails
with ENOMEM.  The allocation is now rejected up front and the caller
gets EMFILE instead, without the WARNING, but the test still fails.

Cap the nr_open value used for the test's own arithmetic to a known
reasonable base value (1048576) and restore the true original value once
the test has completed.

Link: https://lore.kernel.org/20260814165709.513263-1-khorenko@virtuozzo.com
Link: https://github.com/systemd/systemd/commit/a8b627aaed409a15260c25988970c795bf963812 [1]
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: <stable@vger.kernel.org>
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

kbuild-use-cflags_gcov-in-the-prefer-atomic-try-run-test.patch
kbuild-move-gcov-flags-to-scripts-makefilegcov.patch

