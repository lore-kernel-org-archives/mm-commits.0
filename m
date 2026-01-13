Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE0D329361
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 23:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768347254; cv=none; b=uPB1z3/1NSjSxyzcoAcgqQ3Y5kwGzCSrNtLKFDzvkECKF50OYGA5EvUTyKqhP6cg9j9jTKYIEITSoHa62+nZY2k6r7+xiuhK01zELPUT7a9pU8VRECcAM2ZGI6Ltp+h1eDxVD+CXLkwLIeWeEo8TbKUbv1NOMMrWKjH3Ez09qlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768347254; c=relaxed/simple;
	bh=KHGllkMUsT0chDcmCPHeNTpc1Q733tDOa2ZpDByi4oI=;
	h=Date:To:From:Subject:Message-Id; b=Ylm/3j5iB337nHMyIzkPWhjTlu3bAAqk2kJK3lBYDn0INPqhh+lK3+8uncVugoD//CTD8DFnKsF5loN4cyorHc2cezhOHNk9PFxVp21NjvaC4GaUXd3ym1B8gzOwYoL0hzkUwhMGTkXMOjJx1fRF+BujuG4zwzD2CEdXcVsP2nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g8EZWSvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g8EZWSvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C3CC116C6;
	Tue, 13 Jan 2026 23:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768347254;
	bh=KHGllkMUsT0chDcmCPHeNTpc1Q733tDOa2ZpDByi4oI=;
	h=Date:To:From:Subject:From;
	b=g8EZWSvjXQeC9AzH9RukfhyUS3lAS0shWFtudHFWwR2Ias5EVNyIQleK5/vIeyXdx
	 EHFv1TN/OvXx2uJNbCKsWYC5DoYhcG28nyKkC6DuuU36WiKRVCPO5jko86P+JArZeU
	 NrINmlNLahypnIKIWy4DAAOAAVwef2EXXYPjNppw=
Date: Tue, 13 Jan 2026 15:34:13 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,will@kernel.org,tglx@linutronix.de,stefan.kristiansson@saunalahti.fi,song@kernel.org,shorne@gmail.com,sdf@fomichev.me,sashal@kernel.org,peterz@infradead.org,mingo@redhat.com,martin.lau@linux.dev,mark.rutland@arm.com,kpsingh@kernel.org,jonas@southpole.se,jolsa@kernel.org,john.fastabend@gmail.com,hpa@zytor.com,haoluo@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,gary@garyguo.net,eddyz87@gmail.com,dinguyen@kernel.org,dave.hansen@linux.intel.com,daniel@iogearbox.net,dalias@libc.org,bp@alien8.de,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,ardb@kernel.org,andrii@kernel.org,fthain@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + atomic-add-option-for-weaker-alignment-check.patch added to mm-nonmm-unstable branch
Message-Id: <20260113233414.07C3CC116C6@smtp.kernel.org>
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
Date: Tue, 13 Jan 2026 16:22:28 +1100

Add a new Kconfig symbol to make CONFIG_DEBUG_ATOMIC more useful on those
architectures which do not align dynamic allocations to 8-byte boundaries.
Without this, CONFIG_DEBUG_ATOMIC produces excessive WARN splats.

Link: https://lkml.kernel.org/r/6d25a12934fe9199332f4d65d17c17de450139a8.1768281748.git.fthain@linux-m68k.org
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/instrumented.h |    8 +++++++-
 lib/Kconfig.debug            |    8 ++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/include/linux/instrumented.h~atomic-add-option-for-weaker-alignment-check
+++ a/include/linux/instrumented.h
@@ -59,7 +59,13 @@ static __always_inline void instrument_r
 static __always_inline void instrument_atomic_check_alignment(const volatile void *v, size_t size)
 {
 #ifndef __DISABLE_EXPORTS
-	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
+	if (IS_ENABLED(CONFIG_DEBUG_ATOMIC)) {
+		unsigned int mask = size - 1;
+
+		if (IS_ENABLED(CONFIG_DEBUG_ATOMIC_LARGEST_ALIGN))
+			mask &= sizeof(struct { long x; } __aligned_largest) - 1;
+		WARN_ON_ONCE((unsigned long)v & mask);
+	}
 #endif
 }
 
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

