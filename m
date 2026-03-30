Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42E0397E8B
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774898768; cv=none; b=kFf+nPqgTDgWSOL6pWT0hIQpqQ9GqvcPWklJJoR0kGiXrQj9Y+p+DentrtKU0UweIKasDUAzwu86iIwFAOTqIDba0JylkyGMgQ1ShZ9idvucpO56DTydDZd2GNk6NrIduCPYDHQRh0u7MCMVovbWHNjFRj0SEZvhPmqJhxzA+n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774898768; c=relaxed/simple;
	bh=r5W0XDoAWSBc8OXaL+KZ177JFqLMsK7Sr59GVsX3bxE=;
	h=Date:To:From:Subject:Message-Id; b=kjpD7VKtCbfYRZMbp6THNFh7dBsSiYlVM5U86n8kyP03Q1YXYfUd7ReXdJ3l9Smxx235qrulOdt5PmhYJtBZkD5HUL2BMMQRTqK1dKUvm2fDVacR8XLy8brHdoKRkEhvW9cNhsBMDZttovXfkPgrfP4A3uqmPCOrYrr7RnEmq1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z604F4v0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z604F4v0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B740C4CEF7;
	Mon, 30 Mar 2026 19:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774898768;
	bh=r5W0XDoAWSBc8OXaL+KZ177JFqLMsK7Sr59GVsX3bxE=;
	h=Date:To:From:Subject:From;
	b=Z604F4v0U9xDHKi3ZemERjxk40Qwyyh35hGWNe54OVr2epJqEqv/cVpfYARauJYuE
	 H6M7g/tX9UqRKW29bm3C2CMiFUd3wbFYWbshJ9eB6nSq1dvaXgdVmbf1xY1uwzCpyM
	 hyoUDgb97B6EsMgMl20voWgWuWG0ltJZvx+0eF0U=
Date: Mon, 30 Mar 2026 12:26:08 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-ksft_exit_fail_perror-support-printf-style-arguments.patch added to mm-unstable branch
Message-Id: <20260330192608.8B740C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: ksft_exit_fail_perror: support printf style arguments
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-ksft_exit_fail_perror-support-printf-style-arguments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-ksft_exit_fail_perror-support-printf-style-arguments.patch

This patch will later appear in the mm-unstable branch at
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

selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled.patch
selftests-mm-soft-dirty-skip-two-tests-when-thp-is-not-available.patch
selftests-mm-move-write_file-helper-to-vm_util.patch
selftests-ksft_exit_fail_perror-support-printf-style-arguments.patch
selftests-mm-vm_util-robust-write_file.patch
selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

