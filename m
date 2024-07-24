Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E1D446DB
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 21:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721855237; cv=none; b=TYd3lRCvCkso0CV7P6fPFBRw5/ctMmRw5uD8bB9ujwOr+4Hqm6ugCm/9u7gXJIpvVCoxwr0u8ekQRSbnmSxGUTxJpJKmlGk8BKK6W00RsxZcKwmBmPJFJwZSGizei/oDocm60vACP2uHqXrszERlQWCpLHWGJ2RdNOGdCctTzS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721855237; c=relaxed/simple;
	bh=VHaJ7/Q+YJ0o+prfcmd7wIfgSmYWaOQqzS+SQFsUVro=;
	h=Date:To:From:Subject:Message-Id; b=c+xPCdklxyymckhiMk8UTRhqzCwPRioywHzwyR7jBL1rBjoKOlYQ0IferrHUY2vTZ8IPp5GvwR+CGq+MdCMrPW9UpGwxmXhhBf74elzLo6Tqmrq35WMCAa/yXzJTUgVrmrYHVa7r+kDDnVJw4wCHvJsN6y/aSYwvxNH4H/Ai1PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jv3MBegL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jv3MBegL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08617C32781;
	Wed, 24 Jul 2024 21:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721855237;
	bh=VHaJ7/Q+YJ0o+prfcmd7wIfgSmYWaOQqzS+SQFsUVro=;
	h=Date:To:From:Subject:From;
	b=Jv3MBegL6YSf4EGQWZdmGIu1saizKuxiaWUgUOXZOoSWLrVHOeqU/tIbNTn+DxryB
	 9wn7Wf9Ru4aCKkWbF9CIIxPYFM8LoFAmOTpLi/1wxTqiFXPe+XKWmmC300b/Rfg+wn
	 oDDxoaLmcabBv8OQr1Cq5vwGch8kXj5+ES4QO69U=
Date: Wed, 24 Jul 2024 14:07:16 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,aou@eecs.berkeley.edu,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-s390-to-arch-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20240724210717.08617C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: add s390 to ARCH check
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-add-s390-to-arch-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-s390-to-arch-check.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Nico Pache <npache@redhat.com>
Subject: selftests: mm: add s390 to ARCH check
Date: Wed, 24 Jul 2024 14:09:55 -0600

When compiling with ARCH already set, the s390x ARCH is actually s390. 
Add s390 to the ARCH check list, so we can properly build selftests for
s390.

Link: https://lkml.kernel.org/r/20240724200955.14882-1-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-add-s390-to-arch-check
+++ a/tools/testing/selftests/mm/Makefile
@@ -109,7 +109,7 @@ endif
 
 endif
 
-ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 powerpc riscv64 s390x sparc64 x86_64))
+ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 powerpc riscv64 s390x sparc64 x86_64 s390))
 TEST_GEN_FILES += va_high_addr_switch
 TEST_GEN_FILES += virtual_address_range
 TEST_GEN_FILES += write_to_hugetlbfs
_

Patches currently in -mm which might be from npache@redhat.com are

selftests-mm-add-s390-to-arch-check.patch

