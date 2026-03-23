Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A996313534
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 22:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774304601; cv=none; b=qoD6z9I6ELvGo28zeFgtQZ9S0zpN4dyYtLj3HkZ+tcDcppSC/P6QUx1Xw+YG86m7dOdV2ZepRAEmuIWy/75PtG5KOGEiG4vD5IRNRjddffVFJhlN3/P0ImFQuGqbrdsVl2Sux6nWYltAnkeqHkR9V5wXQZlMCwo+Uv0sSTS0WUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774304601; c=relaxed/simple;
	bh=5J2ggUd8STpiXxfNX3chfMpuss7lB9s3memFjbOCAbA=;
	h=Date:To:From:Subject:Message-Id; b=aHynYWizX3dDe01NonAYl2hl8kmKepBfPi9IBQSrliZY2JEeVmvegZUuK+Q3yCsgAlaUfzp4nOFeb7FyMByDg0E6RLSOWyU/yMgomhh3IBiuJtkUfCOi+BLMn2nwNDInMY48I/FeFedQh7Ec5HdaMZG4s0KiuUBLaLj7x8T1TGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YCsD9U+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YCsD9U+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B98C4CEF7;
	Mon, 23 Mar 2026 22:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774304600;
	bh=5J2ggUd8STpiXxfNX3chfMpuss7lB9s3memFjbOCAbA=;
	h=Date:To:From:Subject:From;
	b=YCsD9U+cWf3RIOCn2QAPemGX3CSpiolcnW5rvJsc7gjQo4SStnegGZVfjiU+YyQSS
	 6ubn03XPtnjdM27LsRKifi7hoASIB1rSzfk8iVc8N5/uvZ0lIKeqjMPkUK+5dzqvRI
	 Qnd+trb8lo4tAUz+XYRp9Hhoe8t/Vh+UMklBePzU=
Date: Mon, 23 Mar 2026 15:23:20 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,nathan@kernel.org,morbo@google.com,mingo@kernel.org,justinstitt@google.com,jackmanb@google.com,andriy.shevchenko@linux.intel.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bug-avoid-format-attribute-warning-for-clang-as-well.patch added to mm-hotfixes-unstable branch
Message-Id: <20260323222320.A1B98C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bug: avoid format attribute warning for clang as well
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     bug-avoid-format-attribute-warning-for-clang-as-well.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bug-avoid-format-attribute-warning-for-clang-as-well.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: bug: avoid format attribute warning for clang as well
Date: Mon, 23 Mar 2026 21:55:16 +0100

Like gcc, clang-22 now also warns about a function that it incorrectly
identifies as a printf-style format:

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

Revert the change that added a gcc-specific workaround, and instead add
the generic annotation that avoid the warning.

Link: https://lkml.kernel.org/r/20260323205534.1284284-1-arnd@kernel.org
Fixes: d36067d6ea00 ("bug: Hush suggest-attribute=format for __warn_printf()")
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Brendan Jackman <jackmanb@google.com>
Link: https://lore.kernel.org/all/20251208141618.2805983-1-andriy.shevchenko@linux.intel.com/T/#u
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Bill Wendling <morbo@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/bug.c~bug-avoid-format-attribute-warning-for-clang-as-well
+++ a/lib/bug.c
@@ -173,10 +173,8 @@ struct bug_entry *find_bug(unsigned long
 	return module_find_bug(bugaddr);
 }
 
-__diag_push();
-__diag_ignore(GCC, all, "-Wsuggest-attribute=format",
-	      "Not a valid __printf() conversion candidate.");
-static void __warn_printf(const char *fmt, struct pt_regs *regs)
+static __printf(1, 0)
+void __warn_printf(const char *fmt, struct pt_regs *regs)
 {
 	if (!fmt)
 		return;
@@ -195,7 +193,6 @@ static void __warn_printf(const char *fm
 
 	printk("%s", fmt);
 }
-__diag_pop();
 
 static enum bug_trap_type __report_bug(struct bug_entry *bug, unsigned long bugaddr, struct pt_regs *regs)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

bug-avoid-format-attribute-warning-for-clang-as-well.patch
ubsan-turn-off-kmsan-inside-of-ubsan-instrumentation.patch
mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

