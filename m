Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F8C420877
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 18:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783450447; cv=none; b=SYS3kbx2rkQiDpDnuHlKCu+bqYP5stgHMPqYIGj0DdYqoiEzdOSsC8oXU6xlhsyl6YbSxPmSXW73CLv95zH75fkPSoBdBFiZC8EFdw3971rt8g4g2JF+U7PHSew7gJHDKcBYk0xrMorzFHPon1RGIwr6e9aRuwLQpchcdXUlo1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783450447; c=relaxed/simple;
	bh=goK/F/e4w03ubS29yQW35bDdORicAD/vb+FWmHNkhtk=;
	h=Date:To:From:Subject:Message-Id; b=UufaTxpOZeaLaOcXFEgssvMTWO6LFiNsKxIAGEfZF/QNkHGnvP9cKEWawIGCQQ/pYAODAUR/+H0X/PQPaiVM0gWCDeeX0GCbPKLysiSQrc7AMZVvVsZf2hu6BF8NcZyyCU0k8tr0INjaEPUl0yC9KG+xIBuoPPwWEYzz4kBNxDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rlGWpZM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rlGWpZM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFFF1F000E9;
	Tue,  7 Jul 2026 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783450445;
	bh=ZW2dK6q+pSzbgR03Kiuz7upUMnvDRuSY9r/BB/2Fi68=;
	h=Date:To:From:Subject;
	b=rlGWpZM2LyPgPyQIQjqJGpKYNZuWmTV1EVRoXRRiKHw8FOn4w6d5vy9hgjZuybJLf
	 lLDRNMWsDWvCH72DgDgragnhfgXY/Umzel30wpbzXpBpHcvPMovBRTPBgGrubC8kw9
	 wwKv3gjnsPWoVKvnNJGTXRqE1rSn2QsmoYa5zQKI=
Date: Tue, 07 Jul 2026 11:54:05 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,nathan@kernel.org,linux@rasmusvillemoes.dk,david.laight.linux@gmail.com,arnd@arndb.de,andriy.shevchenko@linux.intel.com,aleksander.lobakin@intel.com,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-printf-compile-the-kunit-test-with-disable_branch_profiling-disable_branch_profiling.patch added to mm-nonmm-unstable branch
Message-Id: <20260707185405.8CFFF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "printf: Compile the kunit test with DISABLE_BRANCH_PROFILING DISABLE_BRANCH_PROFILING"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     revert-printf-compile-the-kunit-test-with-disable_branch_profiling-disable_branch_profiling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-printf-compile-the-kunit-test-with-disable_branch_profiling-disable_branch_profiling.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: Revert "printf: Compile the kunit test with DISABLE_BRANCH_PROFILING DISABLE_BRANCH_PROFILING"
Date: Tue, 7 Jul 2026 15:55:22 +0200

This reverts commit 8901ac9d2c7eb8ed7ae5e749bf13ecb3b6062488.

The commit 94bfc7f3b0c7 ("err.h: use __always_inline on all error pointer
helpers") fixes the problem with a dead code elimination by always
inlining IS_ERR() function.  It prevents the related linker failures as
well.

The workaround with disabling branch profiling is not longer necessary.

Link: https://lore.kernel.org/20260707135522.120447-1-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/r/ah6WDkwO8eYY5f2a@ashevche-desk.local
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Aleksander Lobakin <aleksander.lobakin@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/Makefile |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/tests/Makefile~revert-printf-compile-the-kunit-test-with-disable_branch_profiling-disable_branch_profiling
+++ a/lib/tests/Makefile
@@ -41,8 +41,6 @@ obj-$(CONFIG_MEMCPY_KUNIT_TEST) += memcp
 obj-$(CONFIG_MIN_HEAP_KUNIT_TEST) += min_heap_kunit.o
 CFLAGS_overflow_kunit.o = $(call cc-disable-warning, tautological-constant-out-of-range-compare)
 obj-$(CONFIG_OVERFLOW_KUNIT_TEST) += overflow_kunit.o
-# GCC < 12.1 can miscompile errptr() test when branch profiling is enabled.
-CFLAGS_printf_kunit.o += -DDISABLE_BRANCH_PROFILING
 obj-$(CONFIG_PRANDOM_KUNIT_TEST) += random32_kunit.o
 obj-$(CONFIG_PRINTF_KUNIT_TEST) += printf_kunit.o
 obj-$(CONFIG_RANDSTRUCT_KUNIT_TEST) += randstruct_kunit.o
_

Patches currently in -mm which might be from pmladek@suse.com are

revert-printf-compile-the-kunit-test-with-disable_branch_profiling-disable_branch_profiling.patch

