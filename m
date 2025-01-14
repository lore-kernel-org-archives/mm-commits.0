Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3208A1FBBE5
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836166; cv=none; b=a5COvkrNuynnn/DWOy32Gdv/wGyyYRVXzAHChbCdVLh9a0DH49a6rT8kAQQ8DwAKfiY3baXTdlK7kqmw08J3XGU6auFI2F2X/y0HlNe1HUKXA4KgQRcKlHHR7CFKxjsmzL9ks0cbXx3iqolxNx/x8tb6RNa5cFOHT5LE8F/0008=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836166; c=relaxed/simple;
	bh=2DQnWtyZ7Js8xq0W7PHrPFT0TEmY4GolHQqHEZlZfn4=;
	h=Date:To:From:Subject:Message-Id; b=fnLQCdNNzs8jV3EQNfSXwqnH5sTry/ukWZg0JuPJyqbMUl4/RZnt6r7sDwZUOu/nqneyC/3Jk7TtDqOrxoGn9Gvk8pTN6RD/zZEElPMRP2tb64PtX9xDkSQeIc0eYJC4/J5Wr3kVjEEx8elJuGcK6EhQ/x15ZRlbX5K9Lf9mM90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lMDG+kk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lMDG+kk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62D2C4CEDD;
	Tue, 14 Jan 2025 06:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836165;
	bh=2DQnWtyZ7Js8xq0W7PHrPFT0TEmY4GolHQqHEZlZfn4=;
	h=Date:To:From:Subject:From;
	b=lMDG+kk/elWVTQMaZNvny8tb7G7WfDmnBY/tD8yxn/7/tSBda3B3N2o9AWvSzFgsF
	 RAyhqgcMg87VoWgDQMGpuEZ490pbxATybRCqRZQiUy3zLprbgXScNkBGlo6geqJQun
	 7LENHQBv/c/7J3xMbeyGcIDnzgNkEZHCR0TtWWoE=
Date: Mon, 13 Jan 2025 22:29:25 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-build-with-o2-fix.patch removed from -mm tree
Message-Id: <20250114062925.A62D2C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: silence unused-result warnings
has been removed from the -mm tree.  Its filename was
     selftests-mm-build-with-o2-fix.patch

This patch was dropped because it was folded into selftests-mm-build-with-o2.patch

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: silence unused-result warnings
Date: Tue, 7 Jan 2025 17:01:10 +0000

Switching to -O2 when building the mm tests has the unexpected side effect
of triggering many unused-result warnings on certain distros like Ubuntu,
where GCC is configured so that -O2 implies -D_FORTIFY_SOURCE.

Explicitly disable FORTIFY_SOURCE to avoid those warnings. This has
no effect on upstream toolchains where FORTIFY_SOURCE is not
implicitly enabled.

Link: https://lkml.kernel.org/r/20250107170110.2819685-1-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-build-with-o2-fix
+++ a/tools/testing/selftests/mm/Makefile
@@ -36,6 +36,13 @@ MAKEFLAGS += --no-builtin-rules
 CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 LDLIBS = -lrt -lpthread -lm
 
+# Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
+# automatically enabled at -O1 or above. This triggers various unused-result
+# warnings where functions such as read() or write() are called and their
+# return value is not checked. Disable _FORTIFY_SOURCE to silence those
+# warnings.
+CFLAGS += -U_FORTIFY_SOURCE
+
 KDIR ?= /lib/modules/$(shell uname -r)/build
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
 ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-fix-condition-in-uffd_move_test_common.patch
selftests-mm-fix-wmaybe-uninitialized-warnings.patch
selftests-mm-fix-strncpy-length.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch
selftests-mm-build-with-o2.patch
selftests-mm-remove-unused-pkey-helpers.patch
selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch
selftests-mm-ensure-pkey-h-define-inline-functions-only.patch
selftests-mm-remove-empty-pkey-helper-definition.patch
selftests-mm-ensure-non-global-pkey-symbols-are-marked-static.patch
selftests-mm-use-sys_pkey-helpers-consistently.patch
selftests-mm-use-sys_pkey-helpers-consistently-fix.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch
riscv-mm-skip-pgtable-level-check-in-pudp4d_alloc_one.patch
asm-generic-pgalloc-provide-generic-p4d_alloc_onefree.patch
mm-move-common-part-of-pagetable__ctor-to-helper.patch
parisc-mm-ensure-pagetable_pmd_tor-are-called.patch
m68k-mm-add-calls-to-pagetable_pmd_tor.patch
arm-mm-rename-pgd-helpers.patch
asm-generic-pgalloc-provide-generic-__pgd_allocfree.patch
mm-introduce-ctor-dtor-at-pgd-level.patch

