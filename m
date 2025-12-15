Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CBC322B62
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765821603; cv=none; b=jb4SjZNDTeFhElyQl5SenjT1G3ywMDb4TdtsCdfHbDMpQDoJxxXBwNL9QdH8xXOEOp+RvjN2CKxOM1ug5s9TO1Y1+G2+uznYt62qXL2KdyWtT1ycwUO2NYS8W66edMB9/5a4AgS8K8AcCvRLOK/dcgdUo+fjwH6t5Fu58mjCoNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765821603; c=relaxed/simple;
	bh=MivtAg1Baz0G0B5yUxybrbTDXm+3+Yy4Wha/aMlj48M=;
	h=Date:To:From:Subject:Message-Id; b=PYA5/yLTYzaPT59arRYMyW8/0k/251k0qB3g1+fhX9vaD7gvHIJ/gLH82ctoXMLlrGLEbZdTgpurw5U8cC6Rwi5yh09aBVccnltp7jWXQs4XBemSkuDuxLbkLicEY4O9hw/jihGA7TC9wrhD4wosBHyFx5IbBbzzZM1a7AumpSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nwnhyO9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nwnhyO9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAA5C4CEF5;
	Mon, 15 Dec 2025 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765821602;
	bh=MivtAg1Baz0G0B5yUxybrbTDXm+3+Yy4Wha/aMlj48M=;
	h=Date:To:From:Subject:From;
	b=nwnhyO9NNIXBZClHsV3I9LYymOQKfujqeEiz27RSpE0DlLY8aqqlgFhQ1TpUgCjEb
	 x393px5DMMF2meUVgnqfrniVxt8eAl+/Br0QbXuQkYLllelkHFH6k3StLrxrIl+ZQ0
	 7CmIzEdr8CQqeTpn9T4MULz/2X5/T+FNXCXsQtjE=
Date: Mon, 15 Dec 2025 10:00:01 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,keescook@chromium.org,glider@google.com,elver@google.com,dvyukov@google.com,ardb@kernel.org,andreyknvl@gmail.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-mark-__sanitize_address__-stubs-__always_inline.patch added to mm-new branch
Message-Id: <20251215180002.ACAA5C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: mark !__SANITIZE_ADDRESS__ stubs __always_inline
has been added to the -mm mm-new branch.  Its filename is
     kasan-mark-__sanitize_address__-stubs-__always_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-mark-__sanitize_address__-stubs-__always_inline.patch

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
Subject: kasan: mark !__SANITIZE_ADDRESS__ stubs __always_inline
Date: Mon, 15 Dec 2025 10:12:39 +0000

Patch series "Noinstr fixes for K[CA]SAN with GCOV", v2.

 - clang --version
   Debian clang version 19.1.7 (3+build5)
   Target: x86_64-pc-linux-gnu
   Thread model: posix
   InstalledDir: /usr/lib/llvm-19/bin

 - Kernel config:

   https://gist.githubusercontent.com/bjackman/bbfdf4ec2e1dfd0e18657174f053=
7e2c/raw/a88dcc6567d14c69445e7928a7d5dfc23ca9f619/gistfile0.txt

Note I also get this error:

vmlinux.o: warning: objtool: set_ftrace_ops_ro+0x3b: relocation to !ENDBR: =
machine_kexec_prepare+0x810

That one's a total mystery to me. I guess it's better to "fix" the SEV
one independently rather than waiting until I know how to fix them both.

Note I also mentioned other similar errors in [0]. Those errors don't
exist in Linus' master and I didn't note down where I saw them. Either
they have since been fixed, or I observed them in Google's internal
codebase where they were instroduced downstream.

As discussed in [2], the GCOV+*SAN issue is attacked from two angles:
both adding __always_inline to the instrumentation helpers AND disabling
GCOV for noinstr.c. Only one or the other of these things is needed to
make the build error go away, but they both make sense in their own
right and both may serve to prevent other similar errors from cropping
up in future.


This patch (of 3):

The x86 instrumented bitops in
include/asm-generic/bitops/instrumented-non-atomic.h are
KASAN-instrumented via explicit calls to instrument_* functions from
include/linux/instrumented.h.

These bitops are used from noinstr code in __sev_es_nmi_complete().  This
code avoids noinstr violations by disabling __SANITIZE_ADDRESS__ etc for
the compilation unit.

However, when GCOV is enabled, there can still be violations caused by the
stub versions of these functions, since coverage instrumentation is
injected that causes them to be out-of-lined.

Fix this by just applying __always_inline.

Link: https://lkml.kernel.org/r/20251215-gcov-inline-noinstr-v2-1-6f100b94fa99@google.com
Link: https://lore.kernel.org/all/DERNCQGNRITE.139O331ACPKZ9@google.com/ [1]
Link: https://lore.kernel.org/all/20251117-b4-sev-gcov-objtool-v1-1-54f7790d54df@google.com/ [2]
Link: https://lore.kernel.org/r/20251208-gcov-inline-noinstr-v1-0-623c48ca5714@google.com [3]
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

 include/linux/kasan-checks.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/kasan-checks.h~kasan-mark-__sanitize_address__-stubs-__always_inline
+++ a/include/linux/kasan-checks.h
@@ -37,11 +37,11 @@ static inline bool __kasan_check_write(c
 #define kasan_check_read __kasan_check_read
 #define kasan_check_write __kasan_check_write
 #else
-static inline bool kasan_check_read(const volatile void *p, unsigned int size)
+static __always_inline bool kasan_check_read(const volatile void *p, unsigned int size)
 {
 	return true;
 }
-static inline bool kasan_check_write(const volatile void *p, unsigned int size)
+static __always_inline bool kasan_check_write(const volatile void *p, unsigned int size)
 {
 	return true;
 }
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep.patch
kasan-mark-__sanitize_address__-stubs-__always_inline.patch
kcsan-mark-__sanitize_thread__-stub-__always_inline.patch
x86-sev-disable-gcov-on-noinstr-object.patch

