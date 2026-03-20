Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854B53D0902
	for <mm-commits@vger.kernel.org>; Fri, 20 Mar 2026 23:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774049550; cv=none; b=CDNwI9Ag0lrFd5WXsqJ5HKhDoIr5NUXWNC2g7IcTIb5i1pYJT5jKpmWw5FU1oNcOwUIHy/Ny0BN5jPbGnBPs8voDBOkFasLxMK4bAhwPed6GDzQR0kvuCUSRBz9dnKfR58DmAzct2bs/tIR69hlEbINdbhURiSYLyatYxbHUEAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774049550; c=relaxed/simple;
	bh=2Rhbssm2ylayOHiv7vglVygbKawr19UOktmBp9NMfTg=;
	h=Date:To:From:Subject:Message-Id; b=hyTRIZ+Q5RE2mPR7UlaCRqV1qt0HIS0j9mRViYjzKoE3NLl931VaH+OD9BVzFzyn9a1MaDgVvlRzzL+QBn+zXDgx272KImOTtAYRjvajM3L3LudXiOqVKKjI4DWCQj4f2/C7HyYez2EaO/iX5/mENtyZ1Pa/XXh84SycfjXy6c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r4xmZ3XO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r4xmZ3XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C3EC4CEF7;
	Fri, 20 Mar 2026 23:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774049550;
	bh=2Rhbssm2ylayOHiv7vglVygbKawr19UOktmBp9NMfTg=;
	h=Date:To:From:Subject:From;
	b=r4xmZ3XOEy3X6gfKkNTck2b/uGoeOIOtdiKjS3TK7B9HMGXoVtLiK7/hYbpMpgvXg
	 xsIBs9p5c8K1j808HY9ugo5f9drYLivu1c7aMaCSH0NKCxrNgoxQYevBMSRCWz+wCH
	 PT8Mo7NR5ObSi6l5b3jK7AZwHeHFsAu+ZHh6jUEw=
Date: Fri, 20 Mar 2026 16:32:29 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,nathan@kernel.org,morbo@google.com,mingo@kernel.org,justinstitt@google.com,jackmanb@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bug-shut-up-format-attribute-warning-for-clang-as-well.patch added to mm-hotfixes-unstable branch
Message-Id: <20260320233229.E9C3EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bug.c: shut up format attribute warning for clang as well
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     bug-shut-up-format-attribute-warning-for-clang-as-well.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bug-shut-up-format-attribute-warning-for-clang-as-well.patch

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
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
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

bug-shut-up-format-attribute-warning-for-clang-as-well.patch
ubsan-turn-off-kmsan-inside-of-ubsan-instrumentation.patch
mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

