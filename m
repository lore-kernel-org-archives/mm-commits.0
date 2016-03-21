From: akpm@linux-foundation.org
Subject: [merged]
 asm-generic-force-inlining-of-some-atomic_long-operations.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:42:22 -0700
Message-ID: <56f0408e.kRdhOBUpgM9dMzbK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930AbcCUTVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvlasenk@redhat.com, arnd@arndb.de, mingo@kernel.org, peterz@infradead.org, rientjes@google.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: include/asm-generic/atomic-long.h: force inlining of some atomic_long operations
has been removed from the -mm tree.  Its filename was
     asm-generic-force-inlining-of-some-atomic_long-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: include/asm-generic/atomic-long.h: force inlining of some atomic_long operations

Sometimes gcc mysteriously doesn't inline
very small functions we expect to be inlined. See
    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66122

With this .config:
http://busybox.net/~vda/kernel_config_OPTIMIZE_INLINING_and_Os,
atomic_long_inc(), atomic_long_dec() and atomic_long_add()
functions get deinlined about 40 times. Examples of disassembly:

<atomic_long_inc> (21 copies, 147 calls):
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       f0 48 ff 07             lock incq (%rdi)
       5d                      pop    %rbp
       c3                      retq

<atomic_long_dec> (4 copies, 14 calls) is similar to inc.

<atomic_long_add> (11 copies, 41 calls):
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       f0 48 01 3e             lock add %rdi,(%rsi)
       5d                      pop    %rbp
       c3                      retq

This patch fixes this via s/inline/__always_inline/.
Code size decrease after the patch is ~1.3k:

    text     data      bss       dec     hex filename
92203657 20826112 36417536 149447305 8e86289 vmlinux
92202377 20826112 36417536 149446025 8e85d89 vmlinux4_atomiclong_after

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic-long.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-generic/atomic-long.h~asm-generic-force-inlining-of-some-atomic_long-operations include/asm-generic/atomic-long.h
--- a/include/asm-generic/atomic-long.h~asm-generic-force-inlining-of-some-atomic_long-operations
+++ a/include/asm-generic/atomic-long.h
@@ -98,14 +98,14 @@ ATOMIC_LONG_ADD_SUB_OP(sub, _release)
 #define atomic_long_xchg(v, new) \
 	(ATOMIC_LONG_PFX(_xchg)((ATOMIC_LONG_PFX(_t) *)(v), (new)))
 
-static inline void atomic_long_inc(atomic_long_t *l)
+static __always_inline void atomic_long_inc(atomic_long_t *l)
 {
 	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;
 
 	ATOMIC_LONG_PFX(_inc)(v);
 }
 
-static inline void atomic_long_dec(atomic_long_t *l)
+static __always_inline void atomic_long_dec(atomic_long_t *l)
 {
 	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;
 
@@ -113,7 +113,7 @@ static inline void atomic_long_dec(atomi
 }
 
 #define ATOMIC_LONG_OP(op)						\
-static inline void							\
+static __always_inline void						\
 atomic_long_##op(long i, atomic_long_t *l)				\
 {									\
 	ATOMIC_LONG_PFX(_t) *v = (ATOMIC_LONG_PFX(_t) *)l;		\
_

Patches currently in -mm which might be from dvlasenk@redhat.com are


