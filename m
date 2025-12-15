Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FA62D7DCF
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 18:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765821607; cv=none; b=AnFYfoAQWB1A4qtlqBJ454k94nGEqej6l7Fah+tGM8p5P0gUzesRHMMOZiR/tlCf97yEIDi1e65rOB9sRS/6CXlyysyN8inJDp9TXLuXnfNc84Br8GZlTllccu80UArD0ijk9kX7Ekdq6YeUuiWOK0HfZRKiN0pwUNRYVCqwLhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765821607; c=relaxed/simple;
	bh=gNJ8dxzp/ZFhjRjFgMsslYZTfvBFz+x/oD4WQjr3DzY=;
	h=Date:To:From:Subject:Message-Id; b=ZJyw0qJ7sTf9egJNtGY8W1HTX7emoWd44c7VzbBoUw9CUzBnUvrpdP1Bfz2BiRyYGJk4QtqVR6rq+sU4bLkgwoOBgQ5lBb2yzrLMyuoZ2Jp7ar0VUouu2o6Ad/RO5aGFzDFMTB9AcgALLEHLC69hsp1I/qrDvnm5m1c0HlmDJgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wLf000no; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wLf000no"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10231C4CEF5;
	Mon, 15 Dec 2025 18:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765821607;
	bh=gNJ8dxzp/ZFhjRjFgMsslYZTfvBFz+x/oD4WQjr3DzY=;
	h=Date:To:From:Subject:From;
	b=wLf000noZIG+EMiSynd6wMQORIcOui/4mA5EBWcHPXkCucQghpvhMjsQhNlc01n0+
	 aKldD6fPSyywlQN+UxxgTvCJ7dDrq9bDEL5UIV3f/uKKgRs9lhLfrUQKiwdUhiqgrQ
	 PCKl6bIfocjh/cMOUI0T02L6Wo1jnlNNomvjGJtA=
Date: Mon, 15 Dec 2025 10:00:06 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,keescook@chromium.org,glider@google.com,elver@google.com,dvyukov@google.com,ardb@kernel.org,andreyknvl@gmail.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-sev-disable-gcov-on-noinstr-object.patch added to mm-new branch
Message-Id: <20251215180007.10231C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/sev: Disable GCOV on noinstr object
has been added to the -mm mm-new branch.  Its filename is
     x86-sev-disable-gcov-on-noinstr-object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-sev-disable-gcov-on-noinstr-object.patch

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
Subject: x86/sev: Disable GCOV on noinstr object
Date: Mon, 15 Dec 2025 10:12:41 +0000

With Debian clang version 19.1.7 (3+build5) there are calls to
kasan_check_write() from __sev_es_nmi_complete, which violates noinstr. 
Fix it by disabling GCOV for the noinstr object, as has been done for
previous such instrumentation issues.

Note that this file already disables __SANITIZE_ADDRESS__ and
__SANITIZE_THREAD__, thus calls like kasan_check_write() ought to be nops
regardless of GCOV.  This has been fixed in other patches.  However, to
avoid any other accidental instrumentation showing up, (and since, in
principle GCOV is instrumentation and hence should be disabled for noinstr
code anyway), disable GCOV overall as well.

Link: https://lkml.kernel.org/r/20251215-gcov-inline-noinstr-v2-3-6f100b94fa99@google.com
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

 arch/x86/coco/sev/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/coco/sev/Makefile~x86-sev-disable-gcov-on-noinstr-object
+++ a/arch/x86/coco/sev/Makefile
@@ -8,3 +8,5 @@ UBSAN_SANITIZE_noinstr.o	:= n
 # GCC may fail to respect __no_sanitize_address or __no_kcsan when inlining
 KASAN_SANITIZE_noinstr.o	:= n
 KCSAN_SANITIZE_noinstr.o	:= n
+
+GCOV_PROFILE_noinstr.o		:= n
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep.patch
kasan-mark-__sanitize_address__-stubs-__always_inline.patch
kcsan-mark-__sanitize_thread__-stub-__always_inline.patch
x86-sev-disable-gcov-on-noinstr-object.patch

