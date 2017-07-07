From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?compiler-clang-always-inline-when-config=5Foptimize=5Finlini?=
 =?US-ASCII?Q?ng-is-disabled.patch?= removed from -mm tree
Date: Fri, 07 Jul 2017 12:07:00 -0700
Message-ID: <20170707190700.zpZAPnkKF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60492 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdGGTHB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:07:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mark.rutland@arm.com, mingo@kernel.org, mka@chromium.org, mm-commits@vger.kernel.org, peterz@infradead.org, psodagud@codeaurora.org, rientjes@google.com, stable@vger.kernel.org, will.deacon@arm.com


The patch titled
     Subject: compiler, clang: always inline when CONFIG_OPTIMIZE_INLINING is disabled
has been removed from the -mm tree.  Its filename was
     compiler-clang-always-inline-when-config_optimize_inlining-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: compiler, clang: always inline when CONFIG_OPTIMIZE_INLINING is disabled

The motivation of abb2ea7dfd82 ("compiler, clang: suppress warning for
unused static inline functions") is to suppress clang's warnings about
unused static inline functions.

For configs without CONFIG_OPTIMIZE_INLINING enabled, such as any non-x86
architecture, `inline' in the kernel implies that
__attribute__((always_inline)) is used.

Some code depends on that behavior, see
https://lkml.org/lkml/2017/6/13/918:

net/built-in.o: In function `__xchg_mb':
arch/arm64/include/asm/cmpxchg.h:99: undefined reference to `__compiletime_assert_99'
arch/arm64/include/asm/cmpxchg.h:99: undefined reference to `__compiletime_assert_99

The full fix would be to identify these breakages and annotate the
functions with __always_inline instead of `inline'.  But since we are late
in the 4.12-rc cycle, simply carry forward the forced inlining behavior
and work toward moving arm64, and other architectures, toward
CONFIG_OPTIMIZE_INLINING behavior.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1706261552200.1075@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Sodagudi Prasad <psodagud@codeaurora.org>
Tested-by: Sodagudi Prasad <psodagud@codeaurora.org>
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    8 --------
 include/linux/compiler-gcc.h   |   18 +++++++++++-------
 2 files changed, 11 insertions(+), 15 deletions(-)

diff -puN include/linux/compiler-clang.h~compiler-clang-always-inline-when-config_optimize_inlining-is-disabled include/linux/compiler-clang.h
--- a/include/linux/compiler-clang.h~compiler-clang-always-inline-when-config_optimize_inlining-is-disabled
+++ a/include/linux/compiler-clang.h
@@ -15,11 +15,3 @@
  * with any version that can compile the kernel
  */
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
-
-/*
- * GCC does not warn about unused static inline functions for
- * -Wunused-function.  This turns out to avoid the need for complex #ifdef
- * directives.  Suppress the warning in clang as well.
- */
-#undef inline
-#define inline inline __attribute__((unused)) notrace
diff -puN include/linux/compiler-gcc.h~compiler-clang-always-inline-when-config_optimize_inlining-is-disabled include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-clang-always-inline-when-config_optimize_inlining-is-disabled
+++ a/include/linux/compiler-gcc.h
@@ -66,18 +66,22 @@
 
 /*
  * Force always-inline if the user requests it so via the .config,
- * or if gcc is too old:
+ * or if gcc is too old.
+ * GCC does not warn about unused static inline functions for
+ * -Wunused-function.  This turns out to avoid the need for complex #ifdef
+ * directives.  Suppress the warning in clang as well by using "unused"
+ * function attribute, which is redundant but not harmful for gcc.
  */
 #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) ||		\
     !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
-#define inline		inline		__attribute__((always_inline)) notrace
-#define __inline__	__inline__	__attribute__((always_inline)) notrace
-#define __inline	__inline	__attribute__((always_inline)) notrace
+#define inline inline		__attribute__((always_inline,unused)) notrace
+#define __inline__ __inline__	__attribute__((always_inline,unused)) notrace
+#define __inline __inline	__attribute__((always_inline,unused)) notrace
 #else
 /* A lot of inline functions can cause havoc with function tracing */
-#define inline		inline		notrace
-#define __inline__	__inline__	notrace
-#define __inline	__inline	notrace
+#define inline inline		__attribute__((unused)) notrace
+#define __inline__ __inline__	__attribute__((unused)) notrace
+#define __inline __inline	__attribute__((unused)) notrace
 #endif
 
 #define __always_inline	inline __attribute__((always_inline))
_

Patches currently in -mm which might be from rientjes@google.com are

mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low.patch
mm-vmpressure-pass-through-notification-support.patch
mm-hugetlb-schedule-when-potentially-allocating-many-hugepages.patch
fs-epoll-short-circuit-fetching-events-if-thread-has-been-killed.patch

