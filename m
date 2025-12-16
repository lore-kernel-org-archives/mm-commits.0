Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A792DE6F5
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 19:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765914603; cv=none; b=bUEO4ZQ1FZOnx9HzjlmAjW0cm93DssdSZGXZleSdlqus4Vzp3BiYp+ZysM6gVtggTn5H6ySeFW5lnT77jNkEl94nHby14mHxyM2edrApK2s0DBZzXjuCojXpUSvyssU3mM3uKOrvGX50N6N91MCbVixLpAznKBex/KDCf5Fc9QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765914603; c=relaxed/simple;
	bh=Vl0LxBakcd/MjifS8TTFwMyWAarQLKsUBhq0POOvt/U=;
	h=Date:To:From:Subject:Message-Id; b=hQN95GVvLnOF9c/Ud9s3FRuNzKZLtnUmoRVwEVpn+hNb8y4d5RQM4w8SVtexyRSDZxJdbw9LuT9nZ12KrBmcVquoA0EifTub5kzaW22w+tXA/ZBH4sg2GS6w+osSQeCp02xqfCE6fS0jvI7i99nKjmlSt/bwXKd2kZLCd6qiiTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FE+DHInT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FE+DHInT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5783BC4CEF1;
	Tue, 16 Dec 2025 19:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765914603;
	bh=Vl0LxBakcd/MjifS8TTFwMyWAarQLKsUBhq0POOvt/U=;
	h=Date:To:From:Subject:From;
	b=FE+DHInTeUjEfO/g5VXEJxNarYDbX9nGrrBe0jqlrjyEDJHJpYqVDPLhdEY7Nz3FE
	 lFjNdDO0fE4mcNscZWRf6XNE358u/iZwuelW0wo4QLU0lvZx3GIx1N/GouKSH7Npxc
	 aZUKL2WAgJxdm7I4cnMO6aVq/hY/COAjix6zPQKM=
Date: Tue, 16 Dec 2025 11:50:02 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,will@kernel.org,stefan.kristiansson@saunalahti.fi,song@kernel.org,shorne@gmail.com,sdf@fomichev.me,martin.lau@linux.dev,mark.rutland@arm.com,kpsingh@kernel.org,jonas@southpole.se,jolsa@kernel.org,john.fastabend@gmail.com,haoluo@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,gary@garyguo.net,fthain@linux-m68k.org,eddyz87@gmail.com,dinguyen@kernel.org,daniel@iogearbox.net,dalias@libc.org,boqun.feng@gmail.com,ast@kernel.org,arnd@arndb.de,andrii@kernel.org,peterz@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + atomic-add-alignment-check-to-instrumented-atomic-operations.patch added to mm-nonmm-unstable branch
Message-Id: <20251216195003.5783BC4CEF1@smtp.kernel.org>
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
Date: Tue, 16 Dec 2025 17:31:05 +1100

Add a Kconfig option for debug builds which logs a warning when an
instrumented atomic operation takes place that's misaligned.  Some
platforms don't trap for this.

Link: https://lore.kernel.org/lkml/20250901093600.GF4067720@noisy.programming.kicks-ass.net/
Link: https://lkml.kernel.org/r/0c18fd08ef19497768070783da28086e01d11a00.1765866665.git.fthain@linux-m68k.org
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
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

 include/linux/instrumented.h |    4 ++++
 lib/Kconfig.debug            |   10 ++++++++++
 2 files changed, 14 insertions(+)

--- a/include/linux/instrumented.h~atomic-add-alignment-check-to-instrumented-atomic-operations
+++ a/include/linux/instrumented.h
@@ -7,6 +7,7 @@
 #ifndef _LINUX_INSTRUMENTED_H
 #define _LINUX_INSTRUMENTED_H
 
+#include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/kasan-checks.h>
 #include <linux/kcsan-checks.h>
@@ -67,6 +68,7 @@ static __always_inline void instrument_a
 {
 	kasan_check_read(v, size);
 	kcsan_check_atomic_read(v, size);
+	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
 }
 
 /**
@@ -81,6 +83,7 @@ static __always_inline void instrument_a
 {
 	kasan_check_write(v, size);
 	kcsan_check_atomic_write(v, size);
+	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
 }
 
 /**
@@ -95,6 +98,7 @@ static __always_inline void instrument_a
 {
 	kasan_check_write(v, size);
 	kcsan_check_atomic_read_write(v, size);
+	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
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

