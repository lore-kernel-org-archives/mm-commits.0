Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC74519D08F
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 03:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775100501; cv=none; b=GceE/Id8kO5jFZazMdPyYvFjzBbwBCs6ms2ZVLYOyXx5fqS1L+pwaBXQJwawCkNADfez6UOCWSx7YASx9oTMfz60PyRr9+vURAH+HMpRc7EpK3MAFS0CnLn4IBWQ1E/MJ6pkzXMnnuV3QPbqM/xWeoBxdhLmnuAkIKJ714H3/3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775100501; c=relaxed/simple;
	bh=xo8sShtRC3015uPvS+xXXHlxkb9aW9FDR4RWoUwcOjk=;
	h=Date:To:From:Subject:Message-Id; b=r73ARlF1RsW6ROCFnnfSJ0pEkPRld86ikEGmeU2vML8Gu65MzAgkYcPJVwvHWZ/A1NMPdXdshD5EFCnIkUTs5SEDiim9dAPtAr8IU9UqbLk4voz4kApi5EcZOOjso0vsAwNY6N4fphigv1Kf8hFIiuVyzKp4Or2Vfv/6ub2aFmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ozBP6Oj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ozBP6Oj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA0AC4CEF7;
	Thu,  2 Apr 2026 03:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775100501;
	bh=xo8sShtRC3015uPvS+xXXHlxkb9aW9FDR4RWoUwcOjk=;
	h=Date:To:From:Subject:From;
	b=ozBP6Oj5wgEnfCmWouQmPSrJRmtc3Hok4F4o563nBCj2sy9XIEIPiwuo6hKwb/9of
	 6S+DcVqQJj5r2GdOAZVWIY5WM5mCDQ9gQRom5XPs3fGIu0Z8OTRnQCueQa2yxC++U+
	 dcrpsj9qOYLXXhicH+NLvdv2pY3vwx8K4frSD0II=
Date: Wed, 01 Apr 2026 20:28:21 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-ksft_exit_fail_perror-support-printf-style-arguments.patch removed from -mm tree
Message-Id: <20260402032821.ADA0AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: ksft_exit_fail_perror: support printf style arguments
has been removed from the -mm tree.  Its filename was
     selftests-ksft_exit_fail_perror-support-printf-style-arguments.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests: ksft_exit_fail_perror: support printf style arguments
Date: Mon, 30 Mar 2026 23:15:00 +0800

The ksft_exit_fail_perror function previously only accepted a single string
argument, which limited its flexibility for providing specific context to
failure messages.

This change updates ksft_exit_fail_perror to support variable arguments,
similar to ksft_exit_fail_msg.  Adding the __printf(1, 2) attribute enables
compile-time checking for format string correctness.

Link: https://lkml.kernel.org/r/20260330151503.670415-5-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Li Wang <liwang@redhat.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest.h |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/kselftest.h~selftests-ksft_exit_fail_perror-support-printf-style-arguments
+++ a/tools/testing/selftests/kselftest.h
@@ -43,7 +43,7 @@
  * the program is aborting before finishing all tests):
  *
  *    ksft_exit_fail_msg(fmt, ...);
- *    ksft_exit_fail_perror(msg);
+ *    ksft_exit_fail_perror(fmt, ...);
  *
  */
 #ifndef __KSELFTEST_H
@@ -417,9 +417,24 @@ static inline __noreturn __printf(1, 2)
 	exit(KSFT_FAIL);
 }
 
-static inline __noreturn void ksft_exit_fail_perror(const char *msg)
+static inline __noreturn __printf(1, 2) void ksft_exit_fail_perror(const char *msg, ...)
 {
-	ksft_exit_fail_msg("%s: %s (%d)\n", msg, strerror(errno), errno);
+	va_list args;
+	char *buf = NULL;
+	int saved_errno = errno;
+
+	va_start(args, msg);
+	if (vasprintf(&buf, msg, args) == -1) {
+		va_end(args);
+		ksft_exit_fail_msg("vasprintf failed: %s (%d)\n", strerror(saved_errno),
+				saved_errno);
+	}
+	va_end(args);
+
+	errno = saved_errno;
+	ksft_exit_fail_msg("%s: %s (%d)\n", buf, strerror(errno), errno);
+
+	free(buf);
 }
 
 static inline __noreturn void ksft_exit_xfail(void)
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-vm_util-robust-write_file.patch
selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

