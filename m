Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593AA63A9;
	Sat, 30 Nov 2024 03:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939087; cv=none; b=s/W1kdbyqBByjKqlFYDc3AaA1Bus7FQ0TuQ0XnrO6VDjhO20kKGZWu644kyNKcvoZqeXgHBOcyKs4Zi0CDPgKAwbCm8vsH+aF+vG1wtoMC0/2qcOUhgHJ4XA1fN6xsl21O0mDU2Yb/0ssc4HacYMNSD5NPFxNGQEQaDb0P9g+3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939087; c=relaxed/simple;
	bh=dZj2YclkcAqJZIKEj0FsFzvvj5mWyM8Etv0HtxsqlZI=;
	h=Date:To:From:Subject:Message-Id; b=rJve+wn7Tu4xQ8XRkzOU5W9mgzzCOmKXzc/06n0dxTUKeYTUfDXgA4K/zjmZNDq/NS7fZ4l9s3O31SphDHSCcHgMrHnUQBAVgxCW5Xvhxo4bYYCFaSY8darpVY7qjjwq5RvmxwZJ4+gEsTvZqtHEyXZ2cV6f5EKbHJWvtsUGHZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RDGs74gv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RDGs74gv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0B7C4CECC;
	Sat, 30 Nov 2024 03:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939086;
	bh=dZj2YclkcAqJZIKEj0FsFzvvj5mWyM8Etv0HtxsqlZI=;
	h=Date:To:From:Subject:From;
	b=RDGs74gvkoSH+x8J3zWUYk+sSn/KLPBuY9YXlw4TN98wLQDxjzjuCacxplfv8Pue4
	 DFLh6ppYOcjyHO9WxmHqkza469ezXJOJHBvSKM108v+BS4Z5kP2dKl6kI4qYGOoPry
	 +tc610pl2TKbHecWNbw0u5hkmWWtb4wXe1NLon6s=
Date: Fri, 29 Nov 2024 19:58:06 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackinit-hide-never-taken-branch-from-compiler.patch added to mm-hotfixes-unstable branch
Message-Id: <20241130035806.9F0B7C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: stackinit: hide never-taken branch from compiler
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-stackinit-hide-never-taken-branch-from-compiler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackinit-hide-never-taken-branch-from-compiler.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kees Cook <kees@kernel.org>
Subject: lib: stackinit: hide never-taken branch from compiler
Date: Sun, 17 Nov 2024 03:38:13 -0800

The never-taken branch leads to an invalid bounds condition, which is by
design. To avoid the unwanted warning from the compiler, hide the
variable from the optimizer.

../lib/stackinit_kunit.c: In function 'do_nothing_u16_zero':
../lib/stackinit_kunit.c:51:49: error: array subscript 1 is outside array bounds of 'u16[0]' {aka 'short unsigned int[]'} [-Werror=array-bounds=]
   51 | #define DO_NOTHING_RETURN_SCALAR(ptr)           *(ptr)
      |                                                 ^~~~~~
../lib/stackinit_kunit.c:219:24: note: in expansion of macro 'DO_NOTHING_RETURN_SCALAR'
  219 |                 return DO_NOTHING_RETURN_ ## which(ptr + 1);    \
      |                        ^~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20241117113813.work.735-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackinit_kunit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/stackinit_kunit.c~lib-stackinit-hide-never-taken-branch-from-compiler
+++ a/lib/stackinit_kunit.c
@@ -212,6 +212,7 @@ static noinline void test_ ## name (stru
 static noinline DO_NOTHING_TYPE_ ## which(var_type)		\
 do_nothing_ ## name(var_type *ptr)				\
 {								\
+	OPTIMIZER_HIDE_VAR(ptr);				\
 	/* Will always be true, but compiler doesn't know. */	\
 	if ((unsigned long)ptr > 0x2)				\
 		return DO_NOTHING_RETURN_ ## which(ptr);	\
_

Patches currently in -mm which might be from kees@kernel.org are

lib-stackinit-hide-never-taken-branch-from-compiler.patch

