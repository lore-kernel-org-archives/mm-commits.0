Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C3F357703
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967419; cv=none; b=dcD/dWDzdg4UBntpJn91J3BZIHgyHYUlj7ZdLLGMPkEB8MESDjMbMOALVuT86yA5KtHFWmsLw1kZARXFDPFfiCkAtSAFmzr5auqGuuyBtKdHHedc9CkLr8+IWZOOdWiUtaG59j8E0OS0GlT1zwfSCpieFYG/A+tL+waUgNxxhJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967419; c=relaxed/simple;
	bh=k2ZUKJOcswgCAZQI6eM5ETyDQoL8zARToCUudEWXQ2M=;
	h=Date:To:From:Subject:Message-Id; b=UFB69RvovsB4rNhfLuvsalrk8dTHBJc8TWwoSZKJxG/zOLNFp7JnDfH8RSXmBXfP6ZOrrIBg1YsWQBIpLuUEDut14Pll86eSESXDhIZsqeASCfL5DyGthdAccjy3p+ygpUNc/ZXTECp3hEbe9Z5XhHidRlRzUcEwHpD4EVR/ITY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=id5iLsSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="id5iLsSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A918C116D0;
	Wed, 21 Jan 2026 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967418;
	bh=k2ZUKJOcswgCAZQI6eM5ETyDQoL8zARToCUudEWXQ2M=;
	h=Date:To:From:Subject:From;
	b=id5iLsSHqLrMBbJ09yrjER2Xp9y4p5NAUK1FzqwMb9Km/Qep3vkmB8N/ZX0ApujV/
	 GOi37iltzFz5wbws42Ix0xcDxwVeEYjiYQwGPcE23DQHIP+mY50EAoOfL/yO3/Aqkt
	 /BtBOpdf4uWbLTFtAIdubfEw9Lb3xu4Ltlc116cs=
Date: Tue, 20 Jan 2026 19:50:18 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,will@kernel.org,tglx@linutronix.de,stefan.kristiansson@saunalahti.fi,song@kernel.org,shorne@gmail.com,sdf@fomichev.me,sashal@kernel.org,mingo@redhat.com,martin.lau@linux.dev,mark.rutland@arm.com,kpsingh@kernel.org,jonas@southpole.se,jolsa@kernel.org,john.fastabend@gmail.com,hpa@zytor.com,haoluo@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,gary@garyguo.net,fthain@linux-m68k.org,eddyz87@gmail.com,dinguyen@kernel.org,dave.hansen@linux.intel.com,daniel@iogearbox.net,dalias@libc.org,bp@alien8.de,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,ardb@kernel.org,andrii@kernel.org,peterz@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] atomic-add-alignment-check-to-instrumented-atomic-operations.patch removed from -mm tree
Message-Id: <20260121035018.7A918C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: atomic: add alignment check to instrumented atomic operations
has been removed from the -mm tree.  Its filename was
     atomic-add-alignment-check-to-instrumented-atomic-operations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: atomic: add alignment check to instrumented atomic operations
Date: Tue, 13 Jan 2026 16:22:28 +1100

Add a Kconfig option for debug builds which logs a warning when an
instrumented atomic operation takes place that's misaligned.  Some
platforms don't trap for this.

[fthain@linux-m68k.org: added __DISABLE_EXPORTS conditional and refactored as helper function]
Link: https://lkml.kernel.org/r/51ebf844e006ca0de408f5d3a831e7b39d7fc31c.1768281748.git.fthain@linux-m68k.org
Link: https://lore.kernel.org/lkml/20250901093600.GF4067720@noisy.programming.kicks-ass.net/
Link: https://lore.kernel.org/linux-next/df9fbd22-a648-ada4-fee0-68fe4325ff82@linux-m68k.org/
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
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

 include/linux/instrumented.h |   11 +++++++++++
 lib/Kconfig.debug            |   10 ++++++++++
 2 files changed, 21 insertions(+)

--- a/include/linux/instrumented.h~atomic-add-alignment-check-to-instrumented-atomic-operations
+++ a/include/linux/instrumented.h
@@ -7,6 +7,7 @@
 #ifndef _LINUX_INSTRUMENTED_H
 #define _LINUX_INSTRUMENTED_H
 
+#include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/kasan-checks.h>
 #include <linux/kcsan-checks.h>
@@ -55,6 +56,13 @@ static __always_inline void instrument_r
 	kcsan_check_read_write(v, size);
 }
 
+static __always_inline void instrument_atomic_check_alignment(const volatile void *v, size_t size)
+{
+#ifndef __DISABLE_EXPORTS
+	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
+#endif
+}
+
 /**
  * instrument_atomic_read - instrument atomic read access
  * @v: address of access
@@ -67,6 +75,7 @@ static __always_inline void instrument_a
 {
 	kasan_check_read(v, size);
 	kcsan_check_atomic_read(v, size);
+	instrument_atomic_check_alignment(v, size);
 }
 
 /**
@@ -81,6 +90,7 @@ static __always_inline void instrument_a
 {
 	kasan_check_write(v, size);
 	kcsan_check_atomic_write(v, size);
+	instrument_atomic_check_alignment(v, size);
 }
 
 /**
@@ -95,6 +105,7 @@ static __always_inline void instrument_a
 {
 	kasan_check_write(v, size);
 	kcsan_check_atomic_read_write(v, size);
+	instrument_atomic_check_alignment(v, size);
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


