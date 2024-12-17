Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E6B1527B1
	for <mm-commits@vger.kernel.org>; Tue, 17 Dec 2024 17:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734457269; cv=none; b=DFA49GWXFPa1lsDO3SoUNTqL8Ikmpl0EYC0ocNQ7Vh6f/2Hz0nw0vCoZMU0rY46Gr6onAu+2cCGmdg3If7hdtmmTLqFdtsXHLZGpn3lxxCLp4calbAnhxl7jAoLAZojRXSlC3sKamDMzwR6fX/cqSrbihFqw3H/x3Ej96mIgz4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734457269; c=relaxed/simple;
	bh=0Dh1ofvmknE5xaZn/AmnaehUUpz3EY+afI3Tm9/fEw4=;
	h=Date:To:From:Subject:Message-Id; b=GVsdQ0RRAMURdAz3LiAXGnu7gcTaTqhwSU9Z12QcI5BjZNmEhuPOWM6tVxWI5zvL2TEo2aMcB0qwKrW+CkilQEW1uxHwwELgY6mvv5yWBR8AFmoxzYuqzHLE/XPS7rM7DJXVNJJbjPMO6mRc1oLkEhFF6tASILFnzkgLLvkbRJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rp4sbuLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rp4sbuLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F43C4CED3;
	Tue, 17 Dec 2024 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734457269;
	bh=0Dh1ofvmknE5xaZn/AmnaehUUpz3EY+afI3Tm9/fEw4=;
	h=Date:To:From:Subject:From;
	b=Rp4sbuLg5dCcwTwoqYbZI9XWqwV+CZP/1CqXWzKyIyl66hhKQX1IY9oqdeBJyI47d
	 wm/x42wYD7rSbC0TyXjlecCQ45YV+z6i+0LPE9IXo7m0qMGUGUrV5tvcUSZBCmmi+a
	 YS5e+iT5PaNQ/OJcsZQYJrAEuAC2g3PxDkhIV5QI=
Date: Tue, 17 Dec 2024 09:41:08 -0800
To: mm-commits@vger.kernel.org,pbonzini@redhat.com,ndesaulniers@google.com,nathan@kernel.org,masahiroy@kernel.org,kees@kernel.org,mailhol.vincent@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] build_bugh-more-user-friendly-error-messages-in-build_bug_on_zero.patch removed from -mm tree
Message-Id: <20241217174109.07F43C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: build_bug.h: more user friendly error messages in BUILD_BUG_ON_ZERO()
has been removed from the -mm tree.  Its filename was
     build_bugh-more-user-friendly-error-messages-in-build_bug_on_zero.patch

This patch was dropped because it had testing failures

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
Cc: Nathan Chancellor <nathan@kernel.org>
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


