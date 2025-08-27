Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4039C30F94E
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 22:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756335395; cv=none; b=nDupvipg4t1wfNxA3klV/L5hI9bxnfvFWU14B62YUxq4JC1k2hoXpelVc75loRD/iskBDbhBFf0fPw8hbZ4vA0Wg0MPlHlTMKKX8oBOoVyCGh8pMvuCqjPto39X3BE/dfdcf+nokuMv6PqpOL1aBrJubiEl97+X4NtgOIXWaJxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756335395; c=relaxed/simple;
	bh=Q+Z5SuewEc8g+6ebAmOCCBI1NVGPRWAif6W2lu/+33k=;
	h=Date:To:From:Subject:Message-Id; b=Bq+q460/qxOmdJxD3XhOws/Cm6vvF6fK7AqdNoVejJ/s4kCTOh/608KiUm9iKX/Zbt/rIK6CGx3tbJbh1w6O32uYATteJ2TooanpWSBP7mANGjK0OfN7z9N74r/wXjC0JLEsBuEecgHUEjJ6/fCE1vdgaFO1OYR1fpTG+RVB75c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u24ScjS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u24ScjS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B621FC4CEEB;
	Wed, 27 Aug 2025 22:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756335394;
	bh=Q+Z5SuewEc8g+6ebAmOCCBI1NVGPRWAif6W2lu/+33k=;
	h=Date:To:From:Subject:From;
	b=u24ScjS4DPvk9FhHQMC0bACkaaEfUXY47q0JnDzQDON0e7M8hS32XnM1Glxo4Ltkf
	 YbFFA5BfhdtUc4RTApJbhtu8KJXlMhVsm1VkBekWy+vfebOaUYsvtNVdilngbPF2To
	 v0ZnsahwTCxV2TtxQrF9bAWeaAkXoIwf1e8Wqkks=
Date: Wed, 27 Aug 2025 15:56:34 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,akpm@linux-foundation.org,reddybalavignesh9979@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-centralize-include-path-for-kselftesth-and-kselftest_harnessh.patch added to mm-nonmm-unstable branch
Message-Id: <20250827225634.B621FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: centralize include path for kselftest.h and kselftest_harness.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-centralize-include-path-for-kselftesth-and-kselftest_harnessh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-centralize-include-path-for-kselftesth-and-kselftest_harnessh.patch

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
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Subject: selftests: centralize include path for kselftest.h and kselftest_harness.h
Date: Wed, 27 Aug 2025 20:17:32 +0530

Patch series "selftests: Centralize kselftest headers to avoid relative
includes".

This series centralizes the handling of kselftest.h and
kselftest_harness.h includes in selftests, replacing relative paths with a
non-relative approach using shared -I path.

Patch 1 updates the build files (Makefile and lib.mk) and include CFLAGS
in sync/Makefile to resolve not found errors.

Patch 2 applies bulk source change (patch 2 is large but it is replaced
automatically).


This patch (of 2):

Add compile flag in Makefile and export it in lib.mk.  Also add CFLAGS in
the Makefile rules to fix include path errors for kselftest.h.

Link: https://lore.kernel.org/lkml/20250820143954.33d95635e504e94df01930d0@linux-foundation.org/
Link: https://lkml.kernel.org/r/20250827144733.82277-2-reddybalavignesh9979@gmail.com
Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |    4 ++++
 tools/testing/selftests/lib.mk   |    2 ++
 2 files changed, 6 insertions(+)

--- a/tools/testing/selftests/lib.mk~selftests-centralize-include-path-for-kselftesth-and-kselftest_harnessh
+++ a/tools/testing/selftests/lib.mk
@@ -199,6 +199,8 @@ clean: $(if $(TEST_GEN_MODS_DIR),clean_m
 # Build with _GNU_SOURCE by default
 CFLAGS += -D_GNU_SOURCE=
 
+CFLAGS += $(KSFT_INCLUDES)
+
 # Enables to extend CFLAGS and LDFLAGS from command line, e.g.
 # make USERCFLAGS=-Werror USERLDFLAGS=-static
 CFLAGS += $(USERCFLAGS)
--- a/tools/testing/selftests/Makefile~selftests-centralize-include-path-for-kselftesth-and-kselftest_harnessh
+++ a/tools/testing/selftests/Makefile
@@ -194,11 +194,15 @@ else
   DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
+# Include path for kselftest.h
+KSFT_INCLUDES := -I${abs_srctree}/tools/testing/selftests
+
 # Prepare for headers install
 include $(top_srcdir)/scripts/subarch.include
 ARCH           ?= $(SUBARCH)
 export BUILD
 export KHDR_INCLUDES
+export KSFT_INCLUDES
 
 # set default goal to all, so make without a target runs all, even when
 # all isn't the first target in the file.
_

Patches currently in -mm which might be from reddybalavignesh9979@gmail.com are

selftests-centralise-maybe-unused-definition-in-kselftesth.patch
selftests-proc-mark-vsyscall-strings-maybe-unused.patch
selftests-centralize-include-path-for-kselftesth-and-kselftest_harnessh.patch
selftests-replace-relative-includes-with-non-relative-for-kselftesth-and-kselftest_harnessh.patch

