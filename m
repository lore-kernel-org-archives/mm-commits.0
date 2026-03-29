Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EA2231A3B
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744814; cv=none; b=kDYiO6Oa+U1pA9MkgehTztj9TCMp237cTsF9wz9TnS/iSModia6DyB3diVhlHlV0GpLiM/7unufztkga3709f94/wxBptBP+tHykTdpKJhzjz2ecq+Xh3P/XrF1udXr+ICUsTuTdkRyd+nZT0xJMzxxtEI6pN+EfR+BiDxFT23Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744814; c=relaxed/simple;
	bh=Bc5JXpT6T8cKCY+cfiToB3FH/82AgUYRnAuDhqycJnM=;
	h=Date:To:From:Subject:Message-Id; b=puwGqRXKLJpG6l9LM4/7QD7SpSGHRTg2VgEi3d3EXPuKJM2ehqiIYLODNg/Rh5RaImCNuZu7Y6ujCkUdg7nQimY9ax2g5RoXXRlWLfG4LhXS4l1tet0wxU4yNqxMXtE5/wtrVRrlBwyGml96KNlEXKxfy6nr9mAfm8VCUo50rP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FXe/42g8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FXe/42g8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9794EC4CEF7;
	Sun, 29 Mar 2026 00:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744814;
	bh=Bc5JXpT6T8cKCY+cfiToB3FH/82AgUYRnAuDhqycJnM=;
	h=Date:To:From:Subject:From;
	b=FXe/42g85BE1bR7s/+Kc0JDvUv5wWA05I1JmXUn/8vr3+AkcDXzY/HsyuL2j2VAak
	 it6bvDK09LUUAcAUemgQbU+yuz5lConJqGoG97/1Smlcy4GNlfXyNacWqaKMI0HzOw
	 pQkBA4M7I6phtmytK6Sjyfu1+gOj+44ys94uKCdw=
Date: Sat, 28 Mar 2026 17:40:13 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,peterz@infradead.org,nathan@kernel.org,morbo@google.com,kees@kernel.org,justinstitt@google.com,elver@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ubsan-turn-off-kmsan-inside-of-ubsan-instrumentation.patch removed from -mm tree
Message-Id: <20260329004014.9794EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ubsan: turn off kmsan inside of ubsan instrumentation
has been removed from the -mm tree.  Its filename was
     ubsan-turn-off-kmsan-inside-of-ubsan-instrumentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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
@@ -307,6 +307,7 @@ obj-$(CONFIG_UBSAN) += ubsan.o
 UBSAN_SANITIZE_ubsan.o := n
 KASAN_SANITIZE_ubsan.o := n
 KCSAN_SANITIZE_ubsan.o := n
+KMSAN_SANITIZE_ubsan.o := n
 CFLAGS_ubsan.o := -fno-stack-protector $(DISABLE_KSTACK_ERASE)
 
 obj-$(CONFIG_SBITMAP) += sbitmap.o
_

Patches currently in -mm which might be from arnd@arndb.de are


