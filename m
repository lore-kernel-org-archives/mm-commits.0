Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A91736A027
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 20:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774298477; cv=none; b=kNZxpHXDbTkMVNfcKTclQC1LN2uLM/+k/L6JjlttkrC4qsLo9IOhpZJHDSULPKczO/0DLf227VDdAdJ3sRdVx7oMtvOrsIPcRula06WRI+ujYvjtUd0mPOU56DHvZc9OX8phQSHNmMpmITMYPfL1/ZIq+JBxQjAY4dhREbcH/ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774298477; c=relaxed/simple;
	bh=LtS1wKoOLdxxjRewOOB3QuInJVvecuG3ZN1+h7F7O9A=;
	h=Date:To:From:Subject:Message-Id; b=pBPrxzXdT5PB6OcmiS/CD1JASnzKbbmGkvNhup5JgeqDR/xtsTy4sFsIOGJ7Cno+r0T0bRtdXoeC6dekWJf38wWHV2Vaovy3KMQgt8DsX8gMdKNQWTpmF6hFZirfzGlabmz6W9NdCeektOsHkACFUlJPSF+jEzkhY9Da7cHUW08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JRIJ888f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JRIJ888f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EF1C4CEF7;
	Mon, 23 Mar 2026 20:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774298476;
	bh=LtS1wKoOLdxxjRewOOB3QuInJVvecuG3ZN1+h7F7O9A=;
	h=Date:To:From:Subject:From;
	b=JRIJ888fIiR0omgTpmI16d3Q/lNhbGDGYY0xJ47aMHXndyExUw15c8/JICPunEJ0k
	 wNi5TuoBPeiTqxlTdih8lOA1RB9fKGWSZdiIXgYvyX7PQdTgJzZRXTRi0mYG77bjH1
	 Fe+Fx2TveX6BJjOx3iTG9EhYXOx0rmdcjWVqmpvI=
Date: Mon, 23 Mar 2026 13:41:16 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,nathan@kernel.org,morbo@google.com,mingo@kernel.org,justinstitt@google.com,jackmanb@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] bug-shut-up-format-attribute-warning-for-clang-as-well.patch removed from -mm tree
Message-Id: <20260323204116.A1EF1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bug.c: shut up format attribute warning for clang as well
has been removed from the -mm tree.  Its filename was
     bug-shut-up-format-attribute-warning-for-clang-as-well.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: lib/bug.c: shut up format attribute warning for clang as well
Date: Fri, 20 Mar 2026 22:14:25 +0100

Like gcc, clang-22 now also warns about a function that it
incorrectly identifies as a printf-style format:

lib/bug.c:190:22: error: diagnostic behavior may be improved by adding the 'format(printf, 1, 0)' attribute to the declaration of '__warn_printf' [-Werror,-Wmissing-format-attribute]
  179 | static void __warn_printf(const char *fmt, struct pt_regs *regs)
      | __attribute__((format(printf, 1, 0)))
  180 | {
  181 |         if (!fmt)
  182 |                 return;
  183 |
  184 | #ifdef HAVE_ARCH_BUG_FORMAT_ARGS
  185 |         if (regs) {
  186 |                 struct arch_va_list _args;
  187 |                 va_list *args = __warn_args(&_args, regs);
  188 |
  189 |                 if (args) {
  190 |                         vprintk(fmt, *args);
      |                                           ^

Turn off this warning for all compilers and versions.

Link: https://lkml.kernel.org/r/20260320211528.2474389-1-arnd@kernel.org
Fixes: d36067d6ea00 ("bug: Hush suggest-attribute=format for __warn_printf()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/bug.c~bug-shut-up-format-attribute-warning-for-clang-as-well
+++ a/lib/bug.c
@@ -174,8 +174,7 @@ struct bug_entry *find_bug(unsigned long
 }
 
 __diag_push();
-__diag_ignore(GCC, all, "-Wsuggest-attribute=format",
-	      "Not a valid __printf() conversion candidate.");
+__diag_ignore_all("-Wmissing-format-attribute", "Not a valid __printf() conversion candidate.");
 static void __warn_printf(const char *fmt, struct pt_regs *regs)
 {
 	if (!fmt)
_

Patches currently in -mm which might be from arnd@arndb.de are

ubsan-turn-off-kmsan-inside-of-ubsan-instrumentation.patch
mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

