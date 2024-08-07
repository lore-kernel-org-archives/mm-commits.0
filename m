Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6EE1509A5
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 21:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723066174; cv=none; b=NrdnMHgy8B6Nsf3j2uHm0CcYM13wLlIt5C79y0VHaAIL+4U2s2HS64Iyqs2IZbdtFdihGknfAbrb56t9i9ERR4kRxaGTAD/BCOBrN65MggU4OV8RzYKH/+ZF3kY9aDoZ/c86AuwsBfxzKNNY3Q/JqBO3Hn3MaAU+1PbSAELgElU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723066174; c=relaxed/simple;
	bh=Rq0KCD2SmWgPZByyAIeMkrnNo09XLk8F9VDHh28jBqA=;
	h=Date:To:From:Subject:Message-Id; b=Ax1BAXtzKr1U04up8WOxZn1RHm4AgvIO7BsJhFTo+FK+zvyrhghhFNkIIhHbCcvshy9nz5EGY9EYhJB0Kjz0qKgRjjAhoWxFDYkqX+22/7+R1tjgqpZwnA8UYhfbpsgUyNdcjjiotWsSqA0+Fhxc21Rg94ms9YpvAluye5fX2Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F1wpaIjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F1wpaIjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C51C32781;
	Wed,  7 Aug 2024 21:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723066173;
	bh=Rq0KCD2SmWgPZByyAIeMkrnNo09XLk8F9VDHh28jBqA=;
	h=Date:To:From:Subject:From;
	b=F1wpaIjOfkLE3NRUlcvhJjmJw7DXyYiSbS/UhsmaqqPsTfTW6dhGhBtW9WYnFHrpD
	 r+ZtaDXUiXr3U/2bn3wX50bxizdYCAR4znl/agKV9ChQMku/7zCKgD0d2zQWC3qNhw
	 LpmRAMH0zNX2844bq6wqiTEikC22cIj5FFsQccXA=
Date: Wed, 07 Aug 2024 14:29:32 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch added to mm-unstable branch
Message-Id: <20240807212933.88C51C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! selftests/mm: Add mseal test for no-discard madvise
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch

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
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: fixup! selftests/mm: Add mseal test for no-discard madvise
Date: Wed, 7 Aug 2024 21:37:24 +0100

Adjust the mseal test's plan.

Link: https://lkml.kernel.org/r/20240807203724.2686144-1-pedro.falcato@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-mseal-test-for-no-discard-madvise-fix
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -1775,7 +1775,7 @@ int main(int argc, char **argv)
 	if (!pkey_supported())
 		ksft_print_msg("PKEY not supported\n");
 
-	ksft_set_plan(80);
+	ksft_set_plan(82);
 
 	test_seal_addseal();
 	test_seal_unmapped_start();
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are

mseal-fix-is_madv_discard.patch
selftests-mm-add-mseal-test-for-no-discard-madvise.patch
selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch

