From: akpm@osdl.org
Subject: - local_t-architecture-independent-extension.patch removed from -mm tree
Date: Sat, 27 Jan 2007 02:19:00 -0800
Message-ID: <200701271019.l0RAJoMR007102@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47880 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbXA0KXb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 05:23:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ak@suse.de, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, kyle@mcmartin.ca, paulus@samba.org, ralf@linux-mips.org, rth@twiddle.net, schwidefsky@de.ibm.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     local_t: architecture independent extension
has been removed from the -mm tree.  Its filename was
     local_t-architecture-independent-extension.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: local_t: architecture independent extension
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

These patches extend and standardise local_t operations on each architectures,
allowing a rich set of atomic operations to be done on per-cpu data with
minimal performance impact.  On architectures where there seems to be no
difference between the SMP and UP operation (same memory barriers, same
LOCKing), local.h simply includes asm-generic/local.h, which removes
duplicated code from the current kernel tree.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-generic/local.h |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff -puN include/asm-generic/local.h~local_t-architecture-independent-extension include/asm-generic/local.h
--- a/include/asm-generic/local.h~local_t-architecture-independent-extension
+++ a/include/asm-generic/local.h
@@ -33,6 +33,19 @@ typedef struct
 #define local_add(i,l)	atomic_long_add((i),(&(l)->a))
 #define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
 
+#define local_sub_and_test(i, l) atomic_long_sub_and_test((i), (&(l)->a))
+#define local_dec_and_test(l) atomic_long_dec_and_test(&(l)->a)
+#define local_inc_and_test(l) atomic_long_inc_and_test(&(l)->a)
+#define local_add_negative(i, l) atomic_long_add_negative((i), (&(l)->a))
+#define local_add_return(i, l) atomic_long_add_return((i), (&(l)->a))
+#define local_sub_return(i, l) atomic_long_sub_return((i), (&(l)->a))
+#define local_inc_return(l) atomic_long_inc_return(&(l)->a)
+
+#define local_cmpxchg(l, old, new) atomic_long_cmpxchg((&(l)->a), (old), (new))
+#define local_xchg(l, new) atomic_long_xchg((&(l)->a), (new))
+#define local_add_unless(l, a, u) atomic_long_add_unless((&(l)->a), (a), (u))
+#define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
+
 /* Non-atomic variants, ie. preemption disabled and won't be touched
  * in interrupt, etc.  Some archs can optimize this case well. */
 #define __local_inc(l)		local_set((l), local_read(l) + 1)
@@ -44,19 +57,19 @@ typedef struct
  * much more efficient than these naive implementations.  Note they take
  * a variable (eg. mystruct.foo), not an address.
  */
-#define cpu_local_read(v)	local_read(&__get_cpu_var(v))
-#define cpu_local_set(v, i)	local_set(&__get_cpu_var(v), (i))
-#define cpu_local_inc(v)	local_inc(&__get_cpu_var(v))
-#define cpu_local_dec(v)	local_dec(&__get_cpu_var(v))
-#define cpu_local_add(i, v)	local_add((i), &__get_cpu_var(v))
-#define cpu_local_sub(i, v)	local_sub((i), &__get_cpu_var(v))
+#define cpu_local_read(l)	local_read(&__get_cpu_var(l))
+#define cpu_local_set(l, i)	local_set(&__get_cpu_var(l), (i))
+#define cpu_local_inc(l)	local_inc(&__get_cpu_var(l))
+#define cpu_local_dec(l)	local_dec(&__get_cpu_var(l))
+#define cpu_local_add(i, l)	local_add((i), &__get_cpu_var(l))
+#define cpu_local_sub(i, l)	local_sub((i), &__get_cpu_var(l))
 
 /* Non-atomic increments, ie. preemption disabled and won't be touched
  * in interrupt, etc.  Some archs can optimize this case well.
  */
-#define __cpu_local_inc(v)	__local_inc(&__get_cpu_var(v))
-#define __cpu_local_dec(v)	__local_dec(&__get_cpu_var(v))
-#define __cpu_local_add(i, v)	__local_add((i), &__get_cpu_var(v))
-#define __cpu_local_sub(i, v)	__local_sub((i), &__get_cpu_var(v))
+#define __cpu_local_inc(l)	__local_inc(&__get_cpu_var(l))
+#define __cpu_local_dec(l)	__local_dec(&__get_cpu_var(l))
+#define __cpu_local_add(i, l)	__local_add((i), &__get_cpu_var(l))
+#define __cpu_local_sub(i, l)	__local_sub((i), &__get_cpu_var(l))
 
 #endif /* _ASM_GENERIC_LOCAL_H */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
local_t-architecture-independent-extension.patch
local_t-alpha-extension.patch
local_t-alpha-extension-fix.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
