Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9BF192B8C
	for <mm-commits@vger.kernel.org>; Mon, 30 Sep 2024 16:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727713604; cv=none; b=fVSfSoYFob4zxlTCGG1xuWO66sKTCLMr9AgMPH17aXO1xyl0ZBtgZPGNYz8YuKxD8PKsrbxbX6AMKQwTeEhFmBLfRp0j8OqwUygasFmz0xYJusJfso1xP3tbPbAL1/YRx9Two6nUKyei2HNUVJCHF3qFwu/vgwiwr+QAIzuyT9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727713604; c=relaxed/simple;
	bh=4jZFEWy0ye7EPtoDrP5y+KLvxB4dBULWfg7mRmbMfMk=;
	h=Date:To:From:Subject:Message-Id; b=S8KAkL21n9dHZE3UaO4FFxDjDfm6mydczFRv61uIIfnnK7irxktJBiURz6SaUSzv/s9MaMRJUSTI51NLw/sjpVFQxp8h3V8KL/zFPTe5EACioXzV1FyDugowo1ID3wFMv7o33LbimBXOMHD5gQra6bD8MGP+hzDmAH3wecca6X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A/VRI8de; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A/VRI8de"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F5BC4CEC7;
	Mon, 30 Sep 2024 16:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727713604;
	bh=4jZFEWy0ye7EPtoDrP5y+KLvxB4dBULWfg7mRmbMfMk=;
	h=Date:To:From:Subject:From;
	b=A/VRI8depOMFc+vnI9NjkIRO5YVk/8jO8EmKLF2B3mL+c+NN+/pqurZbBMxrZIvCG
	 FPj8DdjNCaUw1A8YEdNpsNP9mFUOqoXHjxjHrLyaczYaAHDtnHVNBftga5KympDvl5
	 TS++18+ARJh/vPGnDIrscwEKZTYMn4BB2T2cLQCI=
Date: Mon, 30 Sep 2024 09:26:43 -0700
To: mm-commits@vger.kernel.org,brunofrancadevsec@gmail.com,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-fix-spelling-mistake-bsae-base.patch added to mm-nonmm-unstable branch
Message-Id: <20240930162644.40F5BC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: [next] lib/math: Fix spelling mistake "bsae" -> "base"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-math-fix-spelling-mistake-bsae-base.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-math-fix-spelling-mistake-bsae-base.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: [next] lib/math: Fix spelling mistake "bsae" -> "base"
Date: Mon, 30 Sep 2024 08:47:36 +0100

There is a spelling mistake in a literal string. Fix it.

Link: https://lkml.kernel.org/r/20240930074736.48878-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Bruno Sobreira França <brunofrancadevsec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/tests/int_log_kunit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/math/tests/int_log_kunit.c~lib-math-fix-spelling-mistake-bsae-base
+++ a/lib/math/tests/int_log_kunit.c
@@ -24,7 +24,7 @@ static const struct test_case_params int
 
 static const struct test_case_params intlog10_params[] = {
 	{0, 0, "Log base 10 of 0"},
-	{1, 0, "Log bsae 10 of 1"},
+	{1, 0, "Log base 10 of 1"},
 	{6, 13055203, "Log base 10 of 6"},
 	{10, 16777225, "Log base 10 of 10"},
 	{100, 33554450, "Log base 10 of 100"},
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

lib-math-fix-spelling-mistake-bsae-base.patch

