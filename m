Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9EC1CEEB2
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846659; cv=none; b=U8gH5ID9j7bm0JEQjWnWm6nQbSgfUBQ/P78u/sZRPC61w1+o07egbukBPJa419CMn2XnMK1FErNLqw8OJHhL6ZkjZgMYgqLb6KhUmYPycQ+r0RtJEgfxLa+7LtLa+KKS3kY5EO2MkrOQ31+lmjOfzxc0mKcwHayluAs22yHsmbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846659; c=relaxed/simple;
	bh=8Ldey89B1ZWYdi0yQCIoO9wsM2TskUUTePUBUcAPj74=;
	h=Date:To:From:Subject:Message-Id; b=aY75KoDDk24E730vCAJaVTcR4aOuzGro7UdkI4fVIgyn03O5YcQu7/soJX+ZZpJL3mfwXw/+O59vpVMWsxosHaBIhRn+mMYb+3+ZdgqXLB0PVOdKT1jEJ+Rg+kxNymxhbK80f3SFAuI3uCccrfRaxlqp7h+w6die+sUyCn9inhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AvaXkhbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AvaXkhbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DABC4CEE4;
	Wed, 21 May 2025 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846658;
	bh=8Ldey89B1ZWYdi0yQCIoO9wsM2TskUUTePUBUcAPj74=;
	h=Date:To:From:Subject:From;
	b=AvaXkhbDEdsmEaC/pa2dFF8Vmn1RdFufTEpEEVNhebXEPuec4XX1C2vNUNIEjqwxH
	 fI5C0JH8ARgA1zKPYLnOtrj6n9Hk012iC2eA6HQ7Ti1zIZxJx6shHB7IjhRUmGrQV9
	 LVKlEN0B+L+CYm7Io6TlXtl7HxwVTmyKJh4CmFcg=
Date: Wed, 21 May 2025 09:57:38 -0700
To: mm-commits@vger.kernel.org,wen.yang@linux.dev,shuah@kernel.org,seokwoo.chung130@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-eventfd-correct-test-name-and-improve-messages.patch removed from -mm tree
Message-Id: <20250521165738.D5DABC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/eventfd: correct test name and improve messages
has been removed from the -mm tree.  Its filename was
     selftests-eventfd-correct-test-name-and-improve-messages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Shuah Khan <shuah@kernel.org>
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


