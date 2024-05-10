Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6AA4C62A;
	Fri, 10 May 2024 19:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715370970; cv=none; b=to0c3oimjbDMRkKz2YaTNUOt410a4YTa5sphTGofSmoNLM17Zu0YLw7yafW96A+nBn2uZfRT80XgI25UK8zdUZ2xqFbqhczQD+skpfCm+3bvM9coQP6nDbZ0hPUJYC9UCEDEc6QNX0VKiBXUNW522PCfHaQpuqKumTpCR/HIDCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715370970; c=relaxed/simple;
	bh=yfmBxWYDZHapfp/4C7vUl5z1TffogJZjDX22ThellOo=;
	h=Date:To:From:Subject:Message-Id; b=FSDbfekIQypchDhs34aOmThcVs5zGK+RTSVWyl29iI+NBbLOyORnBKuA9pwhxsyfrCvmpjeM4ZG9FSMfG1YPDHVR1slsjsKMktL45mzUuT9be61KwGfbInwB11pRqEgwQAFNVK3ZeEcx6lXiKSs47uCSEXgIcV3J/TFJ2gUAgjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nk01IXWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nk01IXWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2382C113CC;
	Fri, 10 May 2024 19:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715370969;
	bh=yfmBxWYDZHapfp/4C7vUl5z1TffogJZjDX22ThellOo=;
	h=Date:To:From:Subject:From;
	b=Nk01IXWNDKkIZSbv17ZG2gWQiHBRfCXMaNM3/Cr2Y7wirq26rCpJp9iQRRVd8YQTJ
	 hbeJVXe5GKXcTgDTVThCVmEwaKCQ0zoWsyxsy0YsA0A2/PzoJV+UmtoJcsyXPANdZh
	 +gkAIXVDzFcYvW6YyeDnceue/H9msNrpT+FBs/yw=
Date: Fri, 10 May 2024 12:56:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,broonie@kernel.org,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-powerpc-arch-check.patch removed from -mm tree
Message-Id: <20240510195609.B2382C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix powerpc ARCH check
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-powerpc-arch-check.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: selftests/mm: fix powerpc ARCH check
Date: Mon, 6 May 2024 21:58:25 +1000

In commit 0518dbe97fe6 ("selftests/mm: fix cross compilation with LLVM")
the logic to detect the machine architecture in the Makefile was changed
to use ARCH, and only fallback to uname -m if ARCH is unset.  However the
tests of ARCH were not updated to account for the fact that ARCH is
"powerpc" for powerpc builds, not "ppc64".

Fix it by changing the checks to look for "powerpc", and change the
uname -m logic to convert "ppc64.*" into "powerpc".

With that fixed the following tests now build for powerpc again:
 * protection_keys
 * va_high_addr_switch
 * virtual_address_range
 * write_to_hugetlbfs

Link: https://lkml.kernel.org/r/20240506115825.66415-1-mpe@ellerman.id.au
Fixes: 0518dbe97fe6 ("selftests/mm: fix cross compilation with LLVM")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org>	[6.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-fix-powerpc-arch-check
+++ a/tools/testing/selftests/mm/Makefile
@@ -12,7 +12,7 @@ uname_M := $(shell uname -m 2>/dev/null
 else
 uname_M := $(shell echo $(CROSS_COMPILE) | grep -o '^[a-z0-9]\+')
 endif
-ARCH ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/ppc64/')
+ARCH ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/powerpc/')
 endif
 
 # Without this, failed build products remain, with up-to-date timestamps,
@@ -98,13 +98,13 @@ TEST_GEN_FILES += $(BINARIES_64)
 endif
 else
 
-ifneq (,$(findstring $(ARCH),ppc64))
+ifneq (,$(findstring $(ARCH),powerpc))
 TEST_GEN_FILES += protection_keys
 endif
 
 endif
 
-ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sparc64 x86_64))
+ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 powerpc riscv64 s390x sparc64 x86_64))
 TEST_GEN_FILES += va_high_addr_switch
 TEST_GEN_FILES += virtual_address_range
 TEST_GEN_FILES += write_to_hugetlbfs
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

drm-amd-display-only-use-hard-float-not-altivec-on-powerpc.patch

