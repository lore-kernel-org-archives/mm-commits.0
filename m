Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A0123C710
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837043; cv=none; b=rCvRgBS5kKcZjoxY/86Q9YhBmn5GGHIju18+cmOT+zM5YLN3hLdshDYv0vRlay4qf0h9JhZmwMvPxom8I6xfKIuJ2uVeZ0dGro/INLuRl0LAp4x/NympLvzCyjMquE4MwOvOGKKh7N3ahTInDCIxsES5r1cpk7QPaBE/KmWqESg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837043; c=relaxed/simple;
	bh=mDWgInePMV/w5bu8uL8radDkaI8YOT+btcKSkzLnmks=;
	h=Date:To:From:Subject:Message-Id; b=cCRkH2Xzd2mQ1rIZuQE7i1XQR2G3oAYL26i7ynqunnYEMfzlwEf5NDEO1TqVvlyEgs3oeTZbmzzeQdxa2bwc2olQOYgOq50cdEAP9likWpHGLnMDF1R6eCMkFENSffhkmN0fGLi/IqnwVydyGre63U9TNPKv993wqDfjhHktOZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lS5lOx4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lS5lOx4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C6AC4CEDD;
	Tue, 14 Jan 2025 06:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837042;
	bh=mDWgInePMV/w5bu8uL8radDkaI8YOT+btcKSkzLnmks=;
	h=Date:To:From:Subject:From;
	b=lS5lOx4+tcViIjtF4qgzxbZ22i2OB+S1L4s40NRH8YT7NKau7tvAd/cy3Kd05iCiO
	 YsJEuRSTyblLIiYKkuwnFNTQnRX3r9sgyF0PksTo0z8fCLLvUiYXD+zViGQkdoHp+W
	 SYtE8rIt3OyliNQejqJYxRTrQCjwfk4StlymeHa0=
Date: Mon, 13 Jan 2025 22:44:02 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,lkp@intel.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch removed from -mm tree
Message-Id: <20250114064402.92C6AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix -Warray-bounds warnings in pkey_sighandler_tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: fix -Warray-bounds warnings in pkey_sighandler_tests
Date: Mon, 9 Dec 2024 09:50:09 +0000

GCC doesn't like dereferencing a pointer set to 0x1 (when building
at -O2):

pkey_sighandler_tests.c:166:9: warning: array subscript 0 is outside array bounds of 'int[0]' [-Warray-bounds=]
  166 |         *(int *) (0x1) = 1;
      |         ^~~~~~~~~~~~~~
cc1: note: source object is likely at address zero

Using NULL instead seems to make it happy.  This should make no difference
in practice (SIGSEGV with SEGV_MAPERR will be the outcome regardless), we
just need to update the expected si_addr.

[kevin.brodsky@arm.com: fix clang dereferencing-null issue]
  Link: https://lkml.kernel.org/r/20241218153615.2267571-1-kevin.brodsky@arm.com
Link: https://lkml.kernel.org/r/20241209095019.1732120-5-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -163,7 +163,7 @@ static void *thread_segv_with_pkey0_disa
 	__write_pkey_reg(pkey_reg_restrictive_default());
 
 	/* Segfault (with SEGV_MAPERR) */
-	*(int *) (0x1) = 1;
+	*(volatile int *)NULL = 1;
 	return NULL;
 }
 
@@ -179,7 +179,6 @@ static void *thread_segv_pkuerr_stack(vo
 static void *thread_segv_maperr_ptr(void *ptr)
 {
 	stack_t *stack = ptr;
-	int *bad = (int *)1;
 	u64 pkey_reg;
 
 	/*
@@ -195,7 +194,7 @@ static void *thread_segv_maperr_ptr(void
 	__write_pkey_reg(pkey_reg);
 
 	/* Segfault */
-	*bad = 1;
+	*(volatile int *)NULL = 1;
 	syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
 	return NULL;
 }
@@ -234,7 +233,7 @@ static void test_sigsegv_handler_with_pk
 
 	ksft_test_result(siginfo.si_signo == SIGSEGV &&
 			 siginfo.si_code == SEGV_MAPERR &&
-			 siginfo.si_addr == (void *)1,
+			 siginfo.si_addr == NULL,
 			 "%s\n", __func__);
 }
 
@@ -349,7 +348,7 @@ static void test_sigsegv_handler_with_di
 
 	ksft_test_result(siginfo.si_signo == SIGSEGV &&
 			 siginfo.si_code == SEGV_MAPERR &&
-			 siginfo.si_addr == (void *)1,
+			 siginfo.si_addr == NULL,
 			 "%s\n", __func__);
 }
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


