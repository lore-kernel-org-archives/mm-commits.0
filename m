Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27431286412
	for <mm-commits@vger.kernel.org>; Thu,  1 Jan 2026 02:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767233367; cv=none; b=NnWU1eYlaOp6QJfph9pNpWDlQzvUxbq9culaQrKahuTRJbHZR+/690dR8vG5kDB3vY3yqeS8o1u1N7FmMGDhP74BCAlVaYOIR6lnwJ+Xk32S0W+7MviTNq1ds/EAd3rU6jkNM7VcXfY2WD21cizeDXpnx6rYcDPCP56r+BZnJOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767233367; c=relaxed/simple;
	bh=0Hsv77Gt5lSdZZTtTzcWwspp1+jvndK5dk62DIvE4A8=;
	h=Date:To:From:Subject:Message-Id; b=gFXxcBC6wKXObWIDlb+YzpfLMWX6n8xpc8bP3IP3nMZwGWEYbUUGChYsByXUcdaYZvJI1uAIyPM6WmyaUTFCiHpzDrYxJO25q6XdBSP61selsHciHfg9UQGNYUxRB+csNaf+FPvkoPw8cAgT8cgkIjYeIgAzeexE4RJfy18W20A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aTo1bZ7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aTo1bZ7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7FEC113D0;
	Thu,  1 Jan 2026 02:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767233366;
	bh=0Hsv77Gt5lSdZZTtTzcWwspp1+jvndK5dk62DIvE4A8=;
	h=Date:To:From:Subject:From;
	b=aTo1bZ7DbZj4IlYH0IyUfr0QlH3oCf0seuq6u1m410BaWRLMsaI3ynLprlxPP9wp7
	 1tlznpjiPDd7RzTxSLm/pdg8iIJ4Mj3ETpt/d6ZZ5vcEcjLm1vfI7r+g/PwkWnoE/T
	 dubNw5F4dNDU1vQmTdxpqEZOBmkRSd52MjDt1pqE=
Date: Wed, 31 Dec 2025 18:09:25 +9900
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,will@kernel.org,tglx@linutronix.de,stefan.kristiansson@saunalahti.fi,song@kernel.org,shorne@gmail.com,sdf@fomichev.me,sashal@kernel.org,mingo@redhat.com,martin.lau@linux.dev,mark.rutland@arm.com,kpsingh@kernel.org,jonas@southpole.se,jolsa@kernel.org,john.fastabend@gmail.com,hpa@zytor.com,haoluo@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,gary@garyguo.net,fthain@linux-m68k.org,eddyz87@gmail.com,dinguyen@kernel.org,dave.hansen@linux.intel.com,daniel@iogearbox.net,dalias@libc.org,bp@alien8.de,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,ardb@kernel.org,andrii@kernel.org,peterz@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + atomic-add-alignment-check-to-instrumented-atomic-operations.patch added to mm-nonmm-unstable branch
Message-Id: <20260101020926.7C7FEC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: atomic: add alignment check to instrumented atomic operations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     atomic-add-alignment-check-to-instrumented-atomic-operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/atomic-add-alignment-check-to-instrumented-atomic-operations.patch

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
From: Peter Zijlstra <peterz@infradead.org>
Subject: atomic: add alignment check to instrumented atomic operations
Date: Wed, 31 Dec 2025 19:25:42 +1100

Add a Kconfig option for debug builds which logs a warning when an
instrumented atomic operation takes place that's misaligned.  Some
platforms don't trap for this.

[fthain@linux-m68k.org: added __DISABLE_BUG_TABLE macro]
Link: https://lkml.kernel.org/r/f8cfe0d121be0849f5175495e73eafeeb85e1ad3.1767169542.git.fthain@linux-m68k.org
Link: https://lore.kernel.org/lkml/20250901093600.GF4067720@noisy.programming.kicks-ass.net/
Link: https://lore.kernel.org/linux-next/df9fbd22-a648-ada4-fee0-68fe4325ff82@linux-m68k.org/
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Rich Felker <dalias@libc.org>
Cc: Song Liu <song@kernel.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Will Deacon <will@kernel.org>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/Makefile     |    1 +
 drivers/firmware/efi/libstub/Makefile |    1 +
 include/linux/instrumented.h          |   10 ++++++++++
 lib/Kconfig.debug                     |   10 ++++++++++
 4 files changed, 22 insertions(+)

--- a/arch/x86/boot/compressed/Makefile~atomic-add-alignment-check-to-instrumented-atomic-operations
+++ a/arch/x86/boot/compressed/Makefile
@@ -42,6 +42,7 @@ KBUILD_CFLAGS += -Wno-microsoft-anon-tag
 endif
 KBUILD_CFLAGS += -Wno-pointer-sign
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
+KBUILD_CFLAGS += -D__DISABLE_BUG_TABLE
 KBUILD_CFLAGS += -D__DISABLE_EXPORTS
 # Disable relocation relaxation in case the link is not PIE.
 KBUILD_CFLAGS += $(call cc-option,-Wa$(comma)-mrelax-relocations=no)
--- a/drivers/firmware/efi/libstub/Makefile~atomic-add-alignment-check-to-instrumented-atomic-operations
+++ a/drivers/firmware/efi/libstub/Makefile
@@ -42,6 +42,7 @@ KBUILD_CFLAGS			:= $(subst $(CC_FLAGS_FT
 				   -ffreestanding \
 				   -fno-stack-protector \
 				   $(call cc-option,-fno-addrsig) \
+				   -D__DISABLE_BUG_TABLE \
 				   -D__DISABLE_EXPORTS
 
 #
--- a/include/linux/instrumented.h~atomic-add-alignment-check-to-instrumented-atomic-operations
+++ a/include/linux/instrumented.h
@@ -7,6 +7,7 @@
 #ifndef _LINUX_INSTRUMENTED_H
 #define _LINUX_INSTRUMENTED_H
 
+#include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/kasan-checks.h>
 #include <linux/kcsan-checks.h>
@@ -67,6 +68,9 @@ static __always_inline void instrument_a
 {
 	kasan_check_read(v, size);
 	kcsan_check_atomic_read(v, size);
+#ifndef __DISABLE_BUG_TABLE
+	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
+#endif
 }
 
 /**
@@ -81,6 +85,9 @@ static __always_inline void instrument_a
 {
 	kasan_check_write(v, size);
 	kcsan_check_atomic_write(v, size);
+#ifndef __DISABLE_BUG_TABLE
+	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
+#endif
 }
 
 /**
@@ -95,6 +102,9 @@ static __always_inline void instrument_a
 {
 	kasan_check_write(v, size);
 	kcsan_check_atomic_read_write(v, size);
+#ifndef __DISABLE_BUG_TABLE
+	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
+#endif
 }
 
 /**
--- a/lib/Kconfig.debug~atomic-add-alignment-check-to-instrumented-atomic-operations
+++ a/lib/Kconfig.debug
@@ -1360,6 +1360,16 @@ config DEBUG_PREEMPT
 	  depending on workload as it triggers debugging routines for each
 	  this_cpu operation. It should only be used for debugging purposes.
 
+config DEBUG_ATOMIC
+	bool "Debug atomic variables"
+	depends on DEBUG_KERNEL
+	help
+	  If you say Y here then the kernel will add a runtime alignment check
+	  to atomic accesses. Useful for architectures that do not have trap on
+	  mis-aligned access.
+
+	  This option has potentially significant overhead.
+
 menu "Lock Debugging (spinlocks, mutexes, etc...)"
 
 config LOCK_DEBUGGING_SUPPORT
_

Patches currently in -mm which might be from peterz@infradead.org are

atomic-add-alignment-check-to-instrumented-atomic-operations.patch

