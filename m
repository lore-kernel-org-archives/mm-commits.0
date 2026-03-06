Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DE7346FA0
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 17:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772818301; cv=none; b=fMNA7LCFkjLG6m5uw2yik6opYYE7yEkOThb4hv+3iXNJebtnuhjBLjH25X2Lw9c9Mys/f7YjArBbAqxHwYGqxuDaNj72ZJhh9UyomKE1sK9+4jSLH8xlVKCants/qRspWJbt3gSqZzOn/nTv8kD7So4z5NhPFu5zZXaZ7nyE7hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772818301; c=relaxed/simple;
	bh=VjXzYSc//I18q30FkA27aXU04yXwmzabHcA1DdEtKRY=;
	h=Date:To:From:Subject:Message-Id; b=R2HJt9YOsjjQVItvPQtg2fACFxWBEGun0CiP9U/ATnA++106W3RjVNlMWECFn4MjKRrUYXrfjJwVh0Ez17ez9ZhwNjOOPXDJAd5+ZN1GzXQTsIAuCq2EgbVPZJQ/sfrX/AMNZemagNIQRiAH9vierb7H+Odn3mSeqKxnZT0EJsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=19zjFz9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="19zjFz9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420ADC4CEF7;
	Fri,  6 Mar 2026 17:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772818301;
	bh=VjXzYSc//I18q30FkA27aXU04yXwmzabHcA1DdEtKRY=;
	h=Date:To:From:Subject:From;
	b=19zjFz9w3eQRHlnQKtMItDXTZbDIOTcKK6EJcZzMuVO7UOIuKYsrwj+iGX+8W08+D
	 kfcrWJ0zyeGCWC1C5p/AA1/AE+I48V9D8DpDr4j9301NzV7EUUgrHmpHHRD4L44hUh
	 gacos5VS8yaXS2Aw8jgbgtP2XcXaZrfrtmUWnoik=
Date: Fri, 06 Mar 2026 09:31:40 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,peterz@infradead.org,nathan@kernel.org,morbo@google.com,kees@kernel.org,justinstitt@google.com,elver@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ubsan-turn-off-kmsan-inside-of-ubsan-instrumentation.patch added to mm-new branch
Message-Id: <20260306173141.420ADC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ubsan: turn off kmsan inside of ubsan instrumentation
has been added to the -mm mm-new branch.  Its filename is
     ubsan-turn-off-kmsan-inside-of-ubsan-instrumentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ubsan-turn-off-kmsan-inside-of-ubsan-instrumentation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: ubsan: turn off kmsan inside of ubsan instrumentation
Date: Fri, 6 Mar 2026 16:05:49 +0100

The structure initialization in the two type mismatch handling functions
causes a call to __msan_memset() to be generated inside of a UACCESS
block, which in turn leads to an objtool warning about possibly leaking
uaccess-enabled state:

lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch+0xda: call to __msan_memset() with UACCESS enabled
lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1+0xf4: call to __msan_memset() with UACCESS enabled

Most likely __msan_memset() is safe to be called here and could be added
to the uaccess_safe_builtin[] list of safe functions, but seeing that the
ubsan file itself already has kasan, ubsan and kcsan disabled itself, it
is probably a good idea to also turn off kmsan here, in particular this
also avoids the risk of recursing between ubsan and kcsan checks in other
functions of this file.

I saw this happen while testing randconfig builds with clang-22, but did
not try older versions, or attempt to see which kernel change introduced
the warning.

Link: https://lkml.kernel.org/r/20260306150613.350029-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Makefile~ubsan-turn-off-kmsan-inside-of-ubsan-instrumentation
+++ a/lib/Makefile
@@ -308,6 +308,7 @@ obj-$(CONFIG_UBSAN) += ubsan.o
 UBSAN_SANITIZE_ubsan.o := n
 KASAN_SANITIZE_ubsan.o := n
 KCSAN_SANITIZE_ubsan.o := n
+KMSAN_SANITIZE_ubsan.o := n
 CFLAGS_ubsan.o := -fno-stack-protector $(DISABLE_KSTACK_ERASE)
 
 obj-$(CONFIG_SBITMAP) += sbitmap.o
_

Patches currently in -mm which might be from arnd@arndb.de are

ubsan-turn-off-kmsan-inside-of-ubsan-instrumentation.patch
mm-vmscan-avoid-false-positive-wuninitialized-warning.patch

