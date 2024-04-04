Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03AC163
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 00:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712189104; cv=none; b=eJ1rLRPGzAk2+WLUWq7SDi3YBVg/AorUEjg8JUTgfU43fgfsiU27fI7J4VgfQGeexwd2Q2mRZPGMAZTZZ+652unqi1a2sx8uSJl0MUI4QwFSj8clnxY6NJT7TSE+fyh3euBKoHQ7FY95Lu6W8aPP2zbjAqgPEs01BQYmUZZke/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712189104; c=relaxed/simple;
	bh=pCv2s3YIfG41ZKi1y39xBcFom8M7MtV5aES1g8ZyPIY=;
	h=Date:To:From:Subject:Message-Id; b=GZzY/z5q+VCfBYSWrrvpxd9quWJ18N54WW4Z7Hhm93fD9ZKb4Nnh6Oedtgud2slmXdUSgooigPpa/wJfYtbnCO7NTWCBTAfY8DybCEfHkP1jLfZPBD8P1QGiiXayplEm/qJRRGpwvO+KaJQFaS7Me0gB+hIUvR0EzDj1h3xnRUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zScBgM9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zScBgM9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF24C433F1;
	Thu,  4 Apr 2024 00:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712189103;
	bh=pCv2s3YIfG41ZKi1y39xBcFom8M7MtV5aES1g8ZyPIY=;
	h=Date:To:From:Subject:From;
	b=zScBgM9GEpUb0UekvDCI2YABgAmPt5b28z+WhBK26454oIKIY6SAQHOWLVa0C5cwG
	 RM1bt0RuADaZu2fQrtFILT8mEsp0LgP0CdGYawicxKlKiEXORKac2F/uvLlDVpYnBg
	 QQONzqY/JgHcFjXNpjt3QMlc3DdjjuNZ1CYD/ffs=
Date: Wed, 03 Apr 2024 17:05:02 -0700
To: mm-commits@vger.kernel.org,tujinjiang@huawei.com,shuah@kernel.org,david@redhat.com,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix.patch added to mm-unstable branch
Message-Id: <20240404000503.6DF24C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix
Date: Tue, 2 Apr 2024 09:15:37 +0100

There is a spelling mistake in a ksft_test_result_skip message. Fix it.

Link: https://lkml.kernel.org/r/20240402081537.1365939-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -502,7 +502,7 @@ static void test_child_ksm_err(int statu
 	else if (status == -2)
 		ksft_test_result_fail("Merge in child failed\n");
 	else if (status == -3)
-		ksft_test_result_skip("Merge in child skiped\n");
+		ksft_test_result_skip("Merge in child skipped\n");
 }
 
 /* Verify that prctl ksm flag is inherited. */
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec-fix.patch

