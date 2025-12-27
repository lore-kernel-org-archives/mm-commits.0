Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92405288535
	for <mm-commits@vger.kernel.org>; Thu,  1 Jan 2026 02:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767233371; cv=none; b=hTydq0GbT264kAIvqoI0/H1sOvDocfrY6r2RO8JRJZmYmBOuNRciQcSc3cJWJY0mZ41htzTJWV6fauW0zdvDUWxrM2HPYm9p8ZUay1vqM4W5rhKNSr6UixGkJFxTD+jkQTuXswq6JxBGVQVEBP84pImUOBOYMKwpdxFAhewJOI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767233371; c=relaxed/simple;
	bh=oCTyC7TJR3527DK/vxQz6PG4GOy6Jdyeu6RQ57aLGqw=;
	h=Date:To:From:Subject:Message-Id; b=BNoZhxZ4iQmn1q0CA2XUIFFA+nD31S68ntAy/Rw59vDf47UvS4FKS/3+RutGk+PfosNWDZNcHLaPuvW2x1vbjhGeXjpEw/ZxJNAu8T+X6XZr3TvOwIq2Hku4rXgrZD6mp6tdPVXiKHV7hHjy180788a3X2c32qg4+R6Ld6VKa3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bbQCjOcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bbQCjOcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064A9C113D0;
	Thu,  1 Jan 2026 02:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767233371;
	bh=oCTyC7TJR3527DK/vxQz6PG4GOy6Jdyeu6RQ57aLGqw=;
	h=Date:To:From:Subject:From;
	b=bbQCjOcX9lcLoMys+EBSqjH2BL5OMw8EOLRHhfy2crlGYn6KhAr+jLGOdAvjxIFfX
	 uJKotXRRWSplX7L0QDynN9orvaAoD6dE9BxCffLQ3E2NxunaEifNfivbjsgrJetEGX
	 o4EWpbeBDFle2uSGWfGavgzPWe9rcotNnhmOnuZA=
Date: Wed, 31 Dec 2025 18:09:30 +9900
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,will@kernel.org,tglx@linutronix.de,stefan.kristiansson@saunalahti.fi,song@kernel.org,shorne@gmail.com,sdf@fomichev.me,sashal@kernel.org,peterz@infradead.org,mingo@redhat.com,martin.lau@linux.dev,mark.rutland@arm.com,kpsingh@kernel.org,jonas@southpole.se,jolsa@kernel.org,john.fastabend@gmail.com,hpa@zytor.com,haoluo@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,gary@garyguo.net,eddyz87@gmail.com,dinguyen@kernel.org,dave.hansen@linux.intel.com,daniel@iogearbox.net,dalias@libc.org,bp@alien8.de,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,ardb@kernel.org,andrii@kernel.org,fthain@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + atomic-add-option-for-weaker-alignment-check.patch added to mm-nonmm-unstable branch
Message-Id: <20260101020931.064A9C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: atomic: add option for weaker alignment check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     atomic-add-option-for-weaker-alignment-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/atomic-add-option-for-weaker-alignment-check.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Finn Thain <fthain@linux-m68k.org>
Subject: atomic: add option for weaker alignment check
Date: Wed, 31 Dec 2025 19:25:42 +1100

Add a new Kconfig symbol to make CONFIG_DEBUG_ATOMIC more useful on those
architectures which do not align dynamic allocations to 8-byte boundaries.
Without this, CONFIG_DEBUG_ATOMIC produces excessive WARN splats.

Link: https://lkml.kernel.org/r/0c8ef95ea5e9a949a28412a3c791b2167592ae80.1767169542.git.fthain@linux-m68k.org
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Hao Luo <haoluo@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Sasha Levin (Microsoft) <sashal@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/instrumented.h |   25 ++++++++++++++++---------
 lib/Kconfig.debug            |    8 ++++++++
 2 files changed, 24 insertions(+), 9 deletions(-)

--- a/include/linux/instrumented.h~atomic-add-option-for-weaker-alignment-check
+++ a/include/linux/instrumented.h
@@ -56,6 +56,19 @@ static __always_inline void instrument_r
 	kcsan_check_read_write(v, size);
 }
 
+static __always_inline void instrument_atomic_check_alignment(const volatile void *v, size_t size)
+{
+#ifndef __DISABLE_BUG_TABLE
+	if (IS_ENABLED(CONFIG_DEBUG_ATOMIC)) {
+		unsigned int mask = size - 1;
+
+		if (IS_ENABLED(CONFIG_DEBUG_ATOMIC_LARGEST_ALIGN))
+			mask &= sizeof(struct { long x; } __aligned_largest) - 1;
+		WARN_ON_ONCE((unsigned long)v & mask);
+	}
+#endif
+}
+
 /**
  * instrument_atomic_read - instrument atomic read access
  * @v: address of access
@@ -68,9 +81,7 @@ static __always_inline void instrument_a
 {
 	kasan_check_read(v, size);
 	kcsan_check_atomic_read(v, size);
-#ifndef __DISABLE_BUG_TABLE
-	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
-#endif
+	instrument_atomic_check_alignment(v, size);
 }
 
 /**
@@ -85,9 +96,7 @@ static __always_inline void instrument_a
 {
 	kasan_check_write(v, size);
 	kcsan_check_atomic_write(v, size);
-#ifndef __DISABLE_BUG_TABLE
-	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
-#endif
+	instrument_atomic_check_alignment(v, size);
 }
 
 /**
@@ -102,9 +111,7 @@ static __always_inline void instrument_a
 {
 	kasan_check_write(v, size);
 	kcsan_check_atomic_read_write(v, size);
-#ifndef __DISABLE_BUG_TABLE
-	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
-#endif
+	instrument_atomic_check_alignment(v, size);
 }
 
 /**
--- a/lib/Kconfig.debug~atomic-add-option-for-weaker-alignment-check
+++ a/lib/Kconfig.debug
@@ -1370,6 +1370,14 @@ config DEBUG_ATOMIC
 
 	  This option has potentially significant overhead.
 
+config DEBUG_ATOMIC_LARGEST_ALIGN
+	bool "Check alignment only up to __aligned_largest"
+	depends on DEBUG_ATOMIC
+	help
+	  If you say Y here then the check for natural alignment of
+	  atomic accesses will be constrained to the compiler's largest
+	  alignment for scalar types.
+
 menu "Lock Debugging (spinlocks, mutexes, etc...)"
 
 config LOCK_DEBUGGING_SUPPORT
_

Patches currently in -mm which might be from fthain@linux-m68k.org are

bpf-explicitly-align-bpf_res_spin_lock.patch
atomic-specify-alignment-for-atomic_t-and-atomic64_t.patch
atomic-add-option-for-weaker-alignment-check.patch

