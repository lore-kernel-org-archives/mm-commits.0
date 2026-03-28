Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3087A9443
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 00:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774658365; cv=none; b=soEpGGLkSSL3BKX5mP2WNrT66jKVAQ9v8VZuJeUPQpxWUATwN5qn4FbYbukts2gPn0JcDaTQBpful4o6socrTg+bq20V/1uB9vp7MJX5NZCj5g+rMEWfte7y3JxdGbIlzEnMoJqbiYuPVc8xyqFNoe6tOd+NaHiLfa2dgv6aTq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774658365; c=relaxed/simple;
	bh=JY6oESQTMSLnva6MCbcwzLPLaeK05vP0ymK/fqVgk3o=;
	h=Date:To:From:Subject:Message-Id; b=uAtLF1yAvuNpW5k0mOUZOH0lTigbEogO26OjnVQujcx8n3izjbqVsbdzvLOa/Cr+eMoGhN07MQHgsUixs/fpztt//hYMBTDypMCqjl7sli2k7KEwgL960J6nc6ZkhKv46vxbtRYmeEbwD3LopXnWj5MkhDACiiwaeDr3ZtvACBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M5eGyIJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M5eGyIJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C85C19423;
	Sat, 28 Mar 2026 00:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774658364;
	bh=JY6oESQTMSLnva6MCbcwzLPLaeK05vP0ymK/fqVgk3o=;
	h=Date:To:From:Subject:From;
	b=M5eGyIJ6+z466YXeNll+7gEK05HP8KRl6m1ThgSQXf3UvT/V+0JV10ESCRpbuv92M
	 dMTluoiLIPCiBa8GkLJA1OOM1zBJgYaeaqtCq55D1smXfN9dnKanhIjQ2RvgnnBiAg
	 Z3dcjABbf80i6Kx4DPbJmDIrpFbLQWqoQw40I9L0=
Date: Fri, 27 Mar 2026 17:39:24 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,nathan@kernel.org,morbo@google.com,mingo@kernel.org,justinstitt@google.com,jackmanb@google.com,andriy.shevchenko@linux.intel.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] bug-avoid-format-attribute-warning-for-clang-as-well.patch removed from -mm tree
Message-Id: <20260328003924.D0C85C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bug: avoid format attribute warning for clang as well
has been removed from the -mm tree.  Its filename was
     bug-avoid-format-attribute-warning-for-clang-as-well.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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

ubsan-turn-off-kmsan-inside-of-ubsan-instrumentation.patch

