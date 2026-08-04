Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714453F8898
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816316; cv=none; b=QRs/wQ7R5WN9rTxWlTSKSL5ySnk7ZXRVBCd1DH4x2cbjT1sud7lsbX1VbRZPybVN3rwhryaAvilsiZ2kRd23whkiFRdoq9pnWJPRm2ewfK657gFZOSe5AzdveWjjSvG9GyF5EMKTlTV5pblNQ8X8yKzQui6WszZOgC9D1qCTcJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816316; c=relaxed/simple;
	bh=fVb70omvYXYmKKNbmWkbHFb3uxgwsrIaroFX5Q9AjTM=;
	h=Date:To:From:Subject:Message-Id; b=kqQ0z1r1BbR39EsF/5qNTejb5F7s+qckG2rAGw8AIDaZ5f6j5mBYjm6TVA+eATDtS0UCbx+RqsQtInOHTjnwQzyYGzKdEHKvraCg2FvZ+yMtvDdBP1geF7OePGBVYwYBTreEzXBNP8zQYdd9IH4wxPQREftJ/W6oBEAghCesJLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PEX4NNwj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PEX4NNwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF471F000E9;
	Tue,  4 Aug 2026 04:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816315;
	bh=gmvyyvPmjH0up6F2tCf1X8qviIWHTwjymcBGm9JdqAk=;
	h=Date:To:From:Subject;
	b=PEX4NNwj5Fa6XyXwdHFTrSefIb/1tcW8B+RdmN7qu9AmEPKfF2+FTBQAC24S5XrHP
	 obPfdJ/QnTqPiXlAxQIS6WdaEt8c6rUZd+kqwFJWNhDTK9g9o+zxowLk4xtRXEZSNb
	 1uSE/2y9bX0HrrTeDAGwiQnIvkVQORTSJn9uoVQ4=
Date: Mon, 03 Aug 2026 21:05:14 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,nathan@kernel.org,linux@rasmusvillemoes.dk,david.laight.linux@gmail.com,arnd@arndb.de,andriy.shevchenko@linux.intel.com,aleksander.lobakin@intel.com,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] revert-printf-compile-the-kunit-test-with-disable_branch_profiling-disable_branch_profiling.patch removed from -mm tree
Message-Id: <20260804040515.4DF471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "printf: Compile the kunit test with DISABLE_BRANCH_PROFILING DISABLE_BRANCH_PROFILING"
has been removed from the -mm tree.  Its filename was
     revert-printf-compile-the-kunit-test-with-disable_branch_profiling-disable_branch_profiling.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


