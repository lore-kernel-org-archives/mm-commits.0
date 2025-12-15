Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7053233E8
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765821605; cv=none; b=mI2cQFOyjGknaw1PfOCJecMfR5Zk9dYdk6CitqBBJvS10OZDILXQazpluJsgRfR+dnhUbcax29vBIsjJroFPCtewYXHOFrWXsfgD0TDNkg2S5ShurZmrXaf5btYVcCDdimW5wWcV2pTF5j8j7dfHXP9WIcOV8CssGVzIQiJlcTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765821605; c=relaxed/simple;
	bh=lr3XuuiLrB38Ch9vdpmZ9f0xW/9BbPYIPaiwi9MnyV4=;
	h=Date:To:From:Subject:Message-Id; b=Pd79IJLUyojihzcrj5ubRZyggyaqjZVPUlDGZ4c6/JZyigItRk92Qt/kBjrzH1QVc+VoHVq0nbYGAPLz9voNsamGV016uAjMCmLUYZze5eyK1jz9Z/LQlB8beq+rh3E7ixGBD8AOaj2iO+CdWQpo2MUxlk9/MmJYuohgl0XA2dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jUIXNrtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jUIXNrtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE92C4CEF5;
	Mon, 15 Dec 2025 18:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765821605;
	bh=lr3XuuiLrB38Ch9vdpmZ9f0xW/9BbPYIPaiwi9MnyV4=;
	h=Date:To:From:Subject:From;
	b=jUIXNrtguWfwcNH5ZLIHV8VmKF7gk/w806KpZgIidsOG9n79FpJ6PiKhADXLFZ0Rl
	 u2ZEm6yRkQkin4g2IgnfoqnHQhpRRvd6DKAvdQkteybfvl/30ODjkJwzRAXJZWmIg2
	 52+qavrmcSPstLMT0luCy42CdQ1ygtPGOxnGRFBg=
Date: Mon, 15 Dec 2025 10:00:04 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,keescook@chromium.org,glider@google.com,elver@google.com,dvyukov@google.com,ardb@kernel.org,andreyknvl@gmail.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcsan-mark-__sanitize_thread__-stub-__always_inline.patch added to mm-new branch
Message-Id: <20251215180004.EAE92C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcsan: mark !__SANITIZE_THREAD__ stub __always_inline
has been added to the -mm mm-new branch.  Its filename is
     kcsan-mark-__sanitize_thread__-stub-__always_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcsan-mark-__sanitize_thread__-stub-__always_inline.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Brendan Jackman <jackmanb@google.com>
Subject: kcsan: mark !__SANITIZE_THREAD__ stub __always_inline
Date: Mon, 15 Dec 2025 10:12:40 +0000

The x86 instrumented bitops in
include/asm-generic/bitops/instrumented-non-atomic.h are
KCSAN-instrumented via explicit calls to instrument_* functions from
include/linux/instrumented.h.

These bitops are used from noinstr code in __sev_es_nmi_complete().  This
code avoids noinstr violations by disabling __SANITIZE_THREAD__ etc for
the compilation unit.

However, when GCOV is enabled, there can still be violations caused by the
stub versions of these functions, since coverage instrumentation is
injected that causes them to be out-of-lined.

Fix this by just applying __always_inline.

Link: https://lkml.kernel.org/r/20251215-gcov-inline-noinstr-v2-2-6f100b94fa99@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kcsan-checks.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kcsan-checks.h~kcsan-mark-__sanitize_thread__-stub-__always_inline
+++ a/include/linux/kcsan-checks.h
@@ -226,7 +226,7 @@ static inline void kcsan_end_scoped_acce
 #define __kcsan_disable_current kcsan_disable_current
 #define __kcsan_enable_current kcsan_enable_current_nowarn
 #else /* __SANITIZE_THREAD__ */
-static inline void kcsan_check_access(const volatile void *ptr, size_t size,
+static __always_inline void kcsan_check_access(const volatile void *ptr, size_t size,
 				      int type) { }
 static inline void __kcsan_enable_current(void)  { }
 static inline void __kcsan_disable_current(void) { }
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep.patch
kasan-mark-__sanitize_address__-stubs-__always_inline.patch
kcsan-mark-__sanitize_thread__-stub-__always_inline.patch
x86-sev-disable-gcov-on-noinstr-object.patch

