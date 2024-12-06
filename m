Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DA441E4E
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 01:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733447742; cv=none; b=GKhQvnMwLQwW5D3iUPOWisJnwAClEjX4xewBOGBagKUMhHNF647Q5UGAAcLTQFhry3XXsTCrlI+daWqA1Bb6GUUNqJRto2w3AVMqyDjElOx56CPRq/zrwGCsfhCJJTkqKnpkjdW5L7ZFdkIu8SyW7C/g6hBI9VN2nsY2QXoydyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733447742; c=relaxed/simple;
	bh=N69lFKlBH9CI2f55k/NaybunHtUltYhzcSAKyO23RSo=;
	h=Date:To:From:Subject:Message-Id; b=EUEg7e0O0peFS2f7usQFu0MyM8NFjTFXiN689DVgEnKx/cCblBC+DIqMDU5NypJCObNTs6gD3Pl8BXr7m6LT9zFfcbEvG/gFbFVVC2EK+0aWKtPEyUW9/1KajFTzEihQcB3m7XUyi3j4lPLRMv965uIasY7h6SNuJ03B4qll5JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BejLAoVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BejLAoVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20895C4CED1;
	Fri,  6 Dec 2024 01:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733447742;
	bh=N69lFKlBH9CI2f55k/NaybunHtUltYhzcSAKyO23RSo=;
	h=Date:To:From:Subject:From;
	b=BejLAoVfSmoiYKv20G5V+XsQRwInO+tkSIfMB73jzSRrw2Ir06IT2Gk9l8Ip1bPm1
	 9U1HZ5I5TvtjSVr/Vn7qrm7YRgzO4+2hdteuIB+SXPWuqgmNrhmw0ySfBKxgAq4KUc
	 pQeVQdS/2DT9FanKlnfzbHkn2uzTmKhzlUwDo3dg=
Date: Thu, 05 Dec 2024 17:15:41 -0800
To: mm-commits@vger.kernel.org,pbonzini@redhat.com,ndesaulniers@google.com,masahiroy@kernel.org,kees@kernel.org,mailhol.vincent@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + build_bugh-more-user-friendly-error-messages-in-build_bug_on_zero.patch added to mm-nonmm-unstable branch
Message-Id: <20241206011542.20895C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: build_bug.h: more user friendly error messages in BUILD_BUG_ON_ZERO()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     build_bugh-more-user-friendly-error-messages-in-build_bug_on_zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/build_bugh-more-user-friendly-error-messages-in-build_bug_on_zero.patch

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
From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: build_bug.h: more user friendly error messages in BUILD_BUG_ON_ZERO()
Date: Fri, 6 Dec 2024 00:11:46 +0900

__BUILD_BUG_ON_ZERO_MSG(), as introduced in [1], makes it possible to do a
static assert while still returning a zero value.  The direct benefit is
to provide a meaningful error message instead of the cryptic negative
bitfield size error message currently returned by BUILD_BUG_ON_ZERO():

  ./include/linux/build_bug.h:16:51: error: negative width in bit-field '<anonymous>'
     16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
        |                                                   ^

Get rid of BUILD_BUG_ON_ZERO() bitfield size hack.  Instead rely on
__BUILD_BUG_ON_ZERO_MSG() (which in turn relies on C11's
_Static_assert()).

Use some macro magic, similarly to static_assert(), to either use an error
message provided by the user or, when omitted, to produce a default error
message by stringifying the tested expression.  With this, for example:

  BUILD_BUG_ON_ZERO_MSG(1 > 0)

would now throw:

  ./include/linux/compiler.h:245:62: error: static assertion failed: "1 > 0 is true"
    245 | #define __BUILD_BUG_ON_ZERO_MSG(e, msg) ((int)sizeof(struct {_Static_assert(!(e), msg);}))
        |                                                              ^~~~~~~~~~~~~~

Finally, __BUILD_BUG_ON_ZERO_MSG() is already guarded by an:

  #ifdef __CHECKER__

So no need any more for that guard clause for BUILD_BUG_ON_ZERO().
Remove it.

[1] commit d7a516c6eeae ("compiler.h: Fix undefined BUILD_BUG_ON_ZERO()")

Link: https://git.kernel.org/torvalds/c/d7a516c6eeae
Link: https://lkml.kernel.org/r/20241205151316.1480255-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: Kees Cook <kees@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/build_bug.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/build_bug.h~build_bugh-more-user-friendly-error-messages-in-build_bug_on_zero
+++ a/include/linux/build_bug.h
@@ -4,17 +4,17 @@
 
 #include <linux/compiler.h>
 
-#ifdef __CHECKER__
-#define BUILD_BUG_ON_ZERO(e) (0)
-#else /* __CHECKER__ */
 /*
  * Force a compilation error if condition is true, but also produce a
  * result (of value 0 and type int), so the expression can be used
  * e.g. in a structure initializer (or where-ever else comma expressions
  * aren't permitted).
+ *
+ * Take a message as an optional second argument. If omitted, default to
+ * the stringification of the tested expression.
  */
-#define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
-#endif /* __CHECKER__ */
+#define BUILD_BUG_ON_ZERO(e, ...) __BUILD_BUG_ON_ZERO(e, ##__VA_ARGS__, #e)
+#define __BUILD_BUG_ON_ZERO(e, msg) __BUILD_BUG_ON_ZERO_MSG(e, msg " is true")
 
 /* Force a compilation error if a constant expression is not a power of 2 */
 #define __BUILD_BUG_ON_NOT_POWER_OF_2(n)	\
_

Patches currently in -mm which might be from mailhol.vincent@wanadoo.fr are

build_bugh-more-user-friendly-error-messages-in-build_bug_on_zero.patch

