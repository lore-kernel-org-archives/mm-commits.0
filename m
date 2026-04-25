Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE6A3612D5
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 18:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777142282; cv=none; b=rINjU9ZihlSmNmd5kVAdPrblQOX3kPv2Jj1f6hgv5PwqL2Q3BPwL9nWMs7PKABnqc6PvtiHCyYSXM4TjAETIqlFpAtX5ZNtHU8yOQO62eMtCmEyypYaZF5TWWkfAnBo21AszsXQK8SMLW25T2clMEZ0nr1g5sYlc7vbU/ZHlZok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777142282; c=relaxed/simple;
	bh=lUJhyLk8WzaLd+ZydV8PWQn/BdbA7oZGaM7Yl84BQzk=;
	h=Date:To:From:Subject:Message-Id; b=H91geNeyolTHFmIpvGpjaQe+AqclRQVZOicCqMRetoy9y6vJhgRJQCCsulgehj+dxhr/S/b7Ue2pJ9vhi016cqSqKMZAfKXAn5JVg7U9Ae3qGd0nJ4WXm40w0aLftb0A17YYiGxVYk+0M76EdezXgrewNAb5ynhjCsXfoaQdMfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pp1M1riX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pp1M1riX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706AAC2BCB0;
	Sat, 25 Apr 2026 18:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777142281;
	bh=lUJhyLk8WzaLd+ZydV8PWQn/BdbA7oZGaM7Yl84BQzk=;
	h=Date:To:From:Subject:From;
	b=pp1M1riXMLuwCCjv8pJ++Mi1AcAHR22iXoPtm5ViXAKKtLh33HJcwDu/R3CM8cHsH
	 GxQvcWHUzmnJg02E9WmaC2ftDyhve8a3w2FIGKvZD1yl6G5sU4P6fv6rTyGJkXh2ts
	 GI3ruPnYL+8nNr1yGWrRSpIciUTCVWSS87DT9nFQ=
Date: Sat, 25 Apr 2026 11:38:00 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jlayton@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-filelock-use-ksft_perror.patch added to mm-nonmm-unstable branch
Message-Id: <20260425183801.706AAC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest/filelock: use ksft_perror()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kselftest-filelock-use-ksft_perror.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-filelock-use-ksft_perror.patch

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
Subject: kselftest/filelock: use ksft_perror()
Date: Thu, 26 Feb 2026 16:05:25 +0000

Patch series "selftests/filelock: Make output more kselftestish", v4.

This series makes the output from the ofdlocks test a bit easier for
tooling to work with, and also ignores the generated file while we're
here.


This patch (of 3):

The ofdlocks test reports some errors via perror() which does not produce
KTAP output, convert to ksft_perror() which does.

Link: https://lore.kernel.org/20260226-selftest-filelock-ktap-v4-0-db8ae192ff42@kernel.org
Link: https://lore.kernel.org/20260226-selftest-filelock-ktap-v4-1-db8ae192ff42@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filelock/ofdlocks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/filelock/ofdlocks.c~kselftest-filelock-use-ksft_perror
+++ a/tools/testing/selftests/filelock/ofdlocks.c
@@ -16,7 +16,7 @@ static int lock_set(int fd, struct flock
 	fl->l_whence = SEEK_SET;
 	ret = fcntl(fd, F_OFD_SETLK, fl);
 	if (ret)
-		perror("fcntl()");
+		ksft_perror("fcntl()");
 	return ret;
 }
 
@@ -28,7 +28,7 @@ static int lock_get(int fd, struct flock
 	fl->l_whence = SEEK_SET;
 	ret = fcntl(fd, F_OFD_GETLK, fl);
 	if (ret)
-		perror("fcntl()");
+		ksft_perror("fcntl()");
 	return ret;
 }
 
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-specify-requirement-for-proc_mem_always_force=y.patch
kselftest-filelock-use-ksft_perror.patch
kselftest-filelock-report-each-test-in-oftlocks-separately.patch
kselftest-filelock-add-a-gitignore-file.patch

