Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEEF47A64
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 22:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719269143; cv=none; b=ph135VH85oJPH2yXvcrtlQCjokxlsEGRzICQ8UJsY83PyRWevs3/0s95wW8pLn6tJ4wzS6wK7diAJSqzmN9rSuNk5fZWniOY+GfNgd7VeV5wGObjriuEn8uIqXTYUocFAXthudE3X2zKQl+b2XlkLLshcf08pPJBzW1ZaziLkYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719269143; c=relaxed/simple;
	bh=UnqFayVCuC1V4r77+/uh9VdF+Y4b/A6PLJcf18iKpNU=;
	h=Date:To:From:Subject:Message-Id; b=KppRYMIdVrFEkRRvKeUB+YEJ6doQG9b4L1H2jlRQWEkzq0jKmzjKjE46kj6j0YxLk1CS3t5naKohy44nq3MB0BKp+32pyxGOxt71EVyKOoftamN7jxVOEmv3ng9Lwt0lyBfv5SrJW/cqoqkWm75YbJqjk5DXHOpyr7Hbh4mjazo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OP8uO6cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OP8uO6cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC44C2BBFC;
	Mon, 24 Jun 2024 22:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719269142;
	bh=UnqFayVCuC1V4r77+/uh9VdF+Y4b/A6PLJcf18iKpNU=;
	h=Date:To:From:Subject:From;
	b=OP8uO6cyIBijtkxkCOJnn0LoCMOpwDI+TvwDnm/YxHBV+xZp4Vw6c3MfwP9sv4A4h
	 gMhoDvnbGZMwo+XKhv4EUkfa6DeqS4qsEJZJzYaGMzluI0wtG44uxw+jo1rIK48QzS
	 LtyefXFTVYPLN59cj8AzBe5HnQ+yMFOtNU7ebDUo=
Date: Mon, 24 Jun 2024 15:45:41 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,elver@google.com,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compilerh-simplify-data_race-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240624224542.9AC44C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler.h: simplify data_race() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compilerh-simplify-data_race-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compilerh-simplify-data_race-macro.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: compiler.h: simplify data_race() macro
Date: Mon, 24 Jun 2024 18:39:49 +0300

-Wdeclaration-after-statement used since forever required statement
expressions to inject __kcsan_disable_current(), __kcsan_enable_current()
to mark data race. Now that it is gone, make macro expansion simpler.

__unqual_scalar_typeof() is wordy macro by itself.
"expr" is expanded twice.

Link: https://lkml.kernel.org/r/fb62163f-ba21-4661-be5b-bb5124abc87d@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/compiler.h~compilerh-simplify-data_race-macro
+++ a/include/linux/compiler.h
@@ -200,10 +200,8 @@ void ftrace_likely_update(struct ftrace_
  */
 #define data_race(expr)							\
 ({									\
-	__unqual_scalar_typeof(({ expr; })) __v = ({			\
-		__kcsan_disable_current();				\
-		expr;							\
-	});								\
+	__kcsan_disable_current();					\
+	__auto_type __v = (expr);					\
 	__kcsan_enable_current();					\
 	__v;								\
 })
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-test-kthread-field.patch
build-id-require-program-headers-to-be-right-after-elf-header.patch
compilerh-simplify-data_race-macro.patch

