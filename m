Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A8428EC
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 02:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747189323; cv=none; b=OsFEOg2FZasKnlgFT9gKfZvrieDxlNDEfeFplBOFLq//FaZW8yhI102EZp7AgqQUm4ktMKbUtnYDmflIDsZsI3RDYSlQ7tLx0cuiF5J2Qjv0WYwJsc1kf+CWd7eQkEtp3eTJFiQM6onXdQKxnymFGwUJTl2uD4V43Sh0gyORxJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747189323; c=relaxed/simple;
	bh=LjFnDYarrNhurWaqLuZdwjm7UKNMe5GYIorZGvP4XOI=;
	h=Date:To:From:Subject:Message-Id; b=pbyIOKHmBUYecMkA+EgJ/Cll+/pwfGFtEG2/QnYCEVZZhJq6EItiEqqSX3f48UchVCzIZFIDoGJ6Mk1BPPsHIA8G1sfnuATpfSgX3eNzqu1bmKmNM/Wt1VWUX9qya6R0R3ATlNNweeTL2SAuntniFQVOa7LRVQZgAmHCF9RJgOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HQ4ukVny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HQ4ukVny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF982C4CEE4;
	Wed, 14 May 2025 02:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747189322;
	bh=LjFnDYarrNhurWaqLuZdwjm7UKNMe5GYIorZGvP4XOI=;
	h=Date:To:From:Subject:From;
	b=HQ4ukVnyvlK4iM+EEerm29wVwfrnRsUjmcWKvCF6sI1/4g+rYm9rS8kiCax2dEFCB
	 I58oWhmDgiE6ZCDTMcz+bMsPQGY317q0OC5UBfO+z9TCsggs3a328zJlCSd35O5N1C
	 +uVOR0fczPWnQItovo5RA75ayY7YZhNsWHqkcSp0=
Date: Tue, 13 May 2025 19:22:02 -0700
To: mm-commits@vger.kernel.org,wen.yang@linux.dev,seokwoo.chung130@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-eventfd-correct-test-name-and-improve-messages.patch added to mm-new branch
Message-Id: <20250514022202.BF982C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/eventfd: correct test name and improve messages
has been added to the -mm mm-new branch.  Its filename is
     selftests-eventfd-correct-test-name-and-improve-messages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-eventfd-correct-test-name-and-improve-messages.patch

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
From: Ryan Chung <seokwoo.chung130@gmail.com>
Subject: selftests/eventfd: correct test name and improve messages
Date: Tue, 13 May 2025 16:44:11 +0900

- Rename test from eventfd_chek_flag_cloexec_and_nonblock to
eventfd_check_flag_cloexec_and_nonblock.

- Make the RDWR‐flag comment declarative:
  “The kernel automatically adds the O_RDWR flag.”
- Update semaphore‐flag failure message to:
  “eventfd semaphore flag check failed: …”

Link: https://lkml.kernel.org/r/20250513074411.6965-1-seokwoo.chung130@gmail.com
Signed-off-by: Ryan Chung <seokwoo.chung130@gmail.com>
Reviewed-by: Wen Yang <wen.yang@linux.dev>
Cc: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/eventfd/eventfd_test.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/filesystems/eventfd/eventfd_test.c~selftests-eventfd-correct-test-name-and-improve-messages
+++ a/tools/testing/selftests/filesystems/eventfd/eventfd_test.c
@@ -50,7 +50,7 @@ TEST(eventfd_check_flag_rdwr)
 	ASSERT_GE(fd, 0);
 
 	flags = fcntl(fd, F_GETFL);
-	// since the kernel automatically added O_RDWR.
+	// The kernel automatically adds the O_RDWR flag.
 	EXPECT_EQ(flags, O_RDWR);
 
 	close(fd);
@@ -85,7 +85,7 @@ TEST(eventfd_check_flag_nonblock)
 	close(fd);
 }
 
-TEST(eventfd_chek_flag_cloexec_and_nonblock)
+TEST(eventfd_check_flag_cloexec_and_nonblock)
 {
 	int fd, flags;
 
@@ -178,8 +178,7 @@ TEST(eventfd_check_flag_semaphore)
 	// The semaphore could only be obtained from fdinfo.
 	ret = verify_fdinfo(fd, &err, "eventfd-semaphore: ", 19, "1\n");
 	if (ret != 0)
-		ksft_print_msg("eventfd-semaphore check failed, msg: %s\n",
-				err.msg);
+		ksft_print_msg("eventfd semaphore flag check failed: %s\n", err.msg);
 	EXPECT_EQ(ret, 0);
 
 	close(fd);
_

Patches currently in -mm which might be from seokwoo.chung130@gmail.com are

selftests-eventfd-correct-test-name-and-improve-messages.patch

