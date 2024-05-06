Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF61D156F46;
	Mon,  6 May 2024 20:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715025643; cv=none; b=KJaHxrgZOSLh8+b/Z3qxZID/CwgnITR7qbNNVSrPx1wqNuMLlNekuRJfohTI5CrfDVfjUTOTsWCezENJ4NogyS/hA5wOlTDjKHX7V3C2KusTTkeOR8EMgzpwj4ik38vRWwzz9H9D/tHeaONKS5kwnf6KgDPE3kFxKHzO68oTyNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715025643; c=relaxed/simple;
	bh=nxl+HbLeufFyqJp8F0cYUEGsWlhTMbaM9hgpZ4FAAOI=;
	h=Date:To:From:Subject:Message-Id; b=K1FeiJw71VUslIyqhSSxh8EyBa+WKqaIEi1hdr1308P3fzgQka3M8mnMH4St4YIE22e3PNidgXqayBGGdP16LW5nRr6x/oBmjIIxGXufG3mv3vbVQtvAF7WzBShxYgnRbvbeT5d+8MSWWrXRjb3YQ4LsIXX0pkyRuDQ2Nfslt+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gHEcAyqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gHEcAyqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3C2C116B1;
	Mon,  6 May 2024 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715025642;
	bh=nxl+HbLeufFyqJp8F0cYUEGsWlhTMbaM9hgpZ4FAAOI=;
	h=Date:To:From:Subject:From;
	b=gHEcAyqG/QdrPBSwB59DgyirI7aIsN/VnMDJLYakKYANDYc6Ax7e0BNC+nty+UvDA
	 VV9mo3UETS7QdYVOmc2Yc2/BF5FbVnL3Mqq61TYwYFR6zxqosppkYaEUpozosGOV7q
	 cDv2ndRVrHo06h6OISCYT8TNpnjs4A4uZDQAh4g8=
Date: Mon, 06 May 2024 13:00:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,broonie@kernel.org,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-powerpc-arch-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20240506200042.4B3C2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix powerpc ARCH check
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-powerpc-arch-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-powerpc-arch-check.patch

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

selftests-mm-fix-powerpc-arch-check.patch
drm-amd-display-only-use-hard-float-not-altivec-on-powerpc.patch

