Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9852318C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628634; cv=none; b=YkH5dvL/tRV/1lqqWJ310teg7tXs6hSV1n7JekHdVqHCJ14jBZHMsZ3Av6bDfDJOmJ8DnqcvAzWscJXVDx/8KZ3Q9a4ThqjMrB7GRTi4zdJsnG7aeV5rDYfOCZ5q5iDkGQpEp39eevvUD91YONwBG+RmHenFb6UAW50+W42CSag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628634; c=relaxed/simple;
	bh=xlaS4jOr/Tevz4Lvu55y6JtFtS4jr9rscFhMDAQAleE=;
	h=Date:To:From:Subject:Message-Id; b=UfEyZmn6XBKK5kEdVK97xD3uXUXZIO9mxYHLTWIiVMBV4eWyH7OxgjcjXbfpl0v4eSCWKeaurx0hnqwnuGfOrBlKIN8D9QxMcuYSJ8f2CWUoel28DBPRdrQ65TCRfxBCatTTSVJcOXP+dsANleiWgReRtvd4jvps4BfNS16bcxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RsXnp5pj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RsXnp5pj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFCDC32789;
	Sat, 29 Jun 2024 02:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628634;
	bh=xlaS4jOr/Tevz4Lvu55y6JtFtS4jr9rscFhMDAQAleE=;
	h=Date:To:From:Subject:From;
	b=RsXnp5pj8K2lxzhHS1GHaim9ECb/JhxZjtsHlRRiz+Qo7YM1eRU2gGmxzwmUrokp8
	 jKn8kZE4quFdFVLShskcOlKs+wKMw0S+QoYYl/wZLI7ROcOhk4Mn2KjTAEJWq8aVYf
	 4CNXhailmaPXHJvKoF3K6V8kL8kfE+kpb35wEKyY=
Date: Fri, 28 Jun 2024 19:37:13 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,elver@google.com,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] compilerh-simplify-data_race-macro.patch removed from -mm tree
Message-Id: <20240629023714.6CFCDC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: compiler.h: simplify data_race() macro
has been removed from the -mm tree.  Its filename was
     compilerh-simplify-data_race-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


