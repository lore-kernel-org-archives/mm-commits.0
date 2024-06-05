Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B80F2AF16
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 03:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717557364; cv=none; b=Tu0w0WWaCyCS7aYbEANa+HwJesW/qv88H9yqYtncCx7DTMeZyoiZluDmUlmGY5ZkNZ5dKiHlQQ6qD6qyyPPG1MkzV4F5w/6BxMomqThrKdLR2zbv5l/BX2LEZ4QGdYogrc0GLPn0Now3pfRgDYntYP3dz6ZzMXO6TscP6m9S2fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717557364; c=relaxed/simple;
	bh=hbEyx0neAvRnCJWW2x4m9mZXfMzNotREQpUZr1G0nE8=;
	h=Date:To:From:Subject:Message-Id; b=KcVxEU8nkMEfpSN0NBfK+4RiYaZTGdNj66l7pwsTT2oVQPWm3G3aGhFNu3TRwHzmRwEkYOXDLEOjnXVbCRYwWwrGXPSbH6LDtQT1H5QwrpURqrt120Ar/nH9H3RJ3EeYyl3tobRU6B+ZyEoveMFwBLheQoNcZvlRWrkyC6+C98M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kPIZcPxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kPIZcPxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066A5C32781;
	Wed,  5 Jun 2024 03:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717557364;
	bh=hbEyx0neAvRnCJWW2x4m9mZXfMzNotREQpUZr1G0nE8=;
	h=Date:To:From:Subject:From;
	b=kPIZcPxAqZALUHs82rFc3CYFcdMUJ98YW5PB8SSdqe+7pAxmLbikIosyOmEOFDhiY
	 inuzHu7NAjrB0eZhRId5Z9bQ2IJnnReN7zjZxLfc9axNFzhIK5nNschJk3+tcR2SSl
	 h5WsvigZMbs8GyP/ynJZBa3kFD0XF9t3kweJRXAc=
Date: Tue, 04 Jun 2024 20:16:03 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmemleak-test-add-missing-module_description-macro.patch added to mm-unstable branch
Message-Id: <20240605031604.066A5C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmemleak-test: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-unstable branch.  Its filename is
     kmemleak-test-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmemleak-test-add-missing-module_description-macro.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: kmemleak-test: add missing MODULE_DESCRIPTION() macro
Date: Sat, 1 Jun 2024 18:05:00 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kmemleak/kmemleak-test.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240601-md-samples-kmemleak-v1-1-47186be7f0a8@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kmemleak/kmemleak-test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/samples/kmemleak/kmemleak-test.c~kmemleak-test-add-missing-module_description-macro
+++ a/samples/kmemleak/kmemleak-test.c
@@ -96,4 +96,5 @@ static void __exit kmemleak_test_exit(vo
 }
 module_exit(kmemleak_test_exit);
 
+MODULE_DESCRIPTION("Sample module to leak memory for kmemleak testing");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
kmemleak-test-add-missing-module_description-macro.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch

