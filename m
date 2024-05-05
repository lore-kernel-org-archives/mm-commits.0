Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B047580E
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942890; cv=none; b=rzC5b78r2kBLLRGKKvd9XKXWiJB3WC/9+Xlzsu2M4w7Q+phl7N4LqGv2Z7kkOCzUmenuNXY6vtDJuH0WQf609ziT1vIdj1jS+7ggySE9Xu0ERUJDV+aHc/0pTRHcffzQggU3PxtptX6zgi9F5ebiBSFuVIDO1tq9dUyZDYJY9Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942890; c=relaxed/simple;
	bh=iSObSk26QZ8pGkw3Vi0tL/W5Sq8noN8koN3W3a4ERnk=;
	h=Date:To:From:Subject:Message-Id; b=HYzieqQnl8a3attAo+hzPVUNtbEQJHZqj4vsdgglAKsSiyb0qMvthP3e4qoUqVV4ZGP2mOUfyHnUhpune2mUf/X7M8Kxl1BMkGBY3mrFzvbhmoaV+S4vKz2pFg5i1HlFlklP3fXAMp6AZojSGLX1flqliU1mAkDm1cUR80d9LvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tGIP0rYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tGIP0rYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15868C113CC;
	Sun,  5 May 2024 21:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942890;
	bh=iSObSk26QZ8pGkw3Vi0tL/W5Sq8noN8koN3W3a4ERnk=;
	h=Date:To:From:Subject:From;
	b=tGIP0rYFsgn7M+RbEQ9XSYj2tgJ6pb/auJrkXH9t61yukqHJ1JW+vaqgVvpWnptgj
	 vbNiqWscs0xXSblxSuWHmZhvAMDKa4e1tCubBbT2tv6fLSRYcKirer4arXlSAaAZAu
	 /XCBsCGK2mWsjeOk5SvCyH3qy7zgZq99oqJz2dvA=
Date: Sun, 05 May 2024 14:01:29 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-mseal-read-only-elf-memory-segment-fix-4.patch added to mm-unstable branch
Message-Id: <20240505210130.15868C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest mm/mseal: fix arm build
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-mseal-read-only-elf-memory-segment-fix-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-mseal-read-only-elf-memory-segment-fix-4.patch

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
From: Jeff Xu <jeffxu@chromium.org>
Subject: selftest mm/mseal: fix arm build
Date: Thu, 2 May 2024 22:53:31 +0000

Add include linux/mman.h to fix arm build.  Fix a typo.

Link: https://lkml.kernel.org/r/20240502225331.3806279-2-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftest-mm-mseal-read-only-elf-memory-segment-fix-4
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #define _GNU_SOURCE
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <stdint.h>
 #include <unistd.h>
@@ -29,7 +30,7 @@
 # define PKEY_DISABLE_WRITE     0x2
 #endif
 
-#ifndef PKEY_BITS_PER_KEY
+#ifndef PKEY_BITS_PER_PKEY
 #define PKEY_BITS_PER_PKEY      2
 #endif
 
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mseal-wire-up-mseal-syscall.patch
mseal-add-mseal-syscall.patch
mseal-add-mseal-syscall-fix.patch
selftest-mm-mseal-memory-sealing.patch
mseal-add-documentation.patch
selftest-mm-mseal-read-only-elf-memory-segment.patch
selftest-mm-mseal-read-only-elf-memory-segment-fix.patch
selftest-mm-mseal-read-only-elf-memory-segment-fix-3.patch
selftest-mm-mseal-read-only-elf-memory-segment-fix-4.patch

