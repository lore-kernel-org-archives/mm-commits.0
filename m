From: akpm@linux-foundation.org
Subject: - rename-div64_64-to-div64_u64.patch removed from -mm tree
Date: Fri, 02 May 2008 12:41:53 -0700
Message-ID: <200805021941.m42JfrSa011122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932211AbYEBTnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, avi@qumranet.com, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, jdike@addtoit.com, kaber@trash.net, mingo@elte.hu, ralf@linux-mips.org, rmk@ar


The patch titled
     rename div64_64 to div64_u64
has been removed from the -mm tree.  Its filename was
     rename-div64_64-to-div64_u64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rename div64_64 to div64_u64
From: Roman Zippel <zippel@linux-m68k.org>

Rename div64_64 to div64_u64 to make it consistent with the other divide
functions, so it clearly includes the type of the divide.  Move its definition
to math64.h as currently no architecture overrides the generic implementation.
 They can still override it of course, but the duplicated declarations are
avoided.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kvm/kvm-ia64.c     |    3 +--
 arch/x86/kvm/i8254.c         |    6 +++---
 arch/x86/kvm/lapic.c         |    6 +++---
 include/asm-arm/div64.h      |    2 --
 include/asm-generic/div64.h  |    7 -------
 include/asm-m68k/div64.h     |    1 -
 include/asm-mips/div64.h     |    6 ------
 include/asm-mn10300/div64.h  |    3 ---
 include/asm-um/div64.h       |    1 -
 include/asm-x86/div64.h      |    2 --
 include/linux/math64.h       |   12 ++++++++++++
 kernel/sched.c               |    6 +++---
 kernel/sched_debug.c         |    4 ++--
 lib/div64.c                  |   12 ++++++------
 net/ipv4/tcp_cubic.c         |    4 ++--
 net/netfilter/xt_connbytes.c |    5 ++---
 16 files changed, 34 insertions(+), 46 deletions(-)

diff -puN arch/ia64/kvm/kvm-ia64.c~rename-div64_64-to-div64_u64 arch/ia64/kvm/kvm-ia64.c
--- a/arch/ia64/kvm/kvm-ia64.c~rename-div64_64-to-div64_u64
+++ a/arch/ia64/kvm/kvm-ia64.c
@@ -1,4 +1,3 @@
-
 /*
  * kvm_ia64.c: Basic KVM suppport On Itanium series processors
  *
@@ -431,7 +430,7 @@ int kvm_emulate_halt(struct kvm_vcpu *vc
 	if (itc_diff < 0)
 		itc_diff = -itc_diff;
 
-	expires = div64_64(itc_diff, cyc_per_usec);
+	expires = div64_u64(itc_diff, cyc_per_usec);
 	kt = ktime_set(0, 1000 * expires);
 	vcpu->arch.ht_active = 1;
 	hrtimer_start(p_ht, kt, HRTIMER_MODE_ABS);
diff -puN arch/x86/kvm/i8254.c~rename-div64_64-to-div64_u64 arch/x86/kvm/i8254.c
--- a/arch/x86/kvm/i8254.c~rename-div64_64-to-div64_u64
+++ a/arch/x86/kvm/i8254.c
@@ -35,7 +35,7 @@
 #include "i8254.h"
 
 #ifndef CONFIG_X86_64
-#define mod_64(x, y) ((x) - (y) * div64_64(x, y))
+#define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
 #else
 #define mod_64(x, y) ((x) % (y))
 #endif
@@ -60,8 +60,8 @@ static u64 muldiv64(u64 a, u32 b, u32 c)
 	rl = (u64)u.l.low * (u64)b;
 	rh = (u64)u.l.high * (u64)b;
 	rh += (rl >> 32);
-	res.l.high = div64_64(rh, c);
-	res.l.low = div64_64(((mod_64(rh, c) << 32) + (rl & 0xffffffff)), c);
+	res.l.high = div64_u64(rh, c);
+	res.l.low = div64_u64(((mod_64(rh, c) << 32) + (rl & 0xffffffff)), c);
 	return res.ll;
 }
 
diff -puN arch/x86/kvm/lapic.c~rename-div64_64-to-div64_u64 arch/x86/kvm/lapic.c
--- a/arch/x86/kvm/lapic.c~rename-div64_64-to-div64_u64
+++ a/arch/x86/kvm/lapic.c
@@ -25,13 +25,13 @@
 #include <linux/hrtimer.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/math64.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/page.h>
 #include <asm/current.h>
 #include <asm/apicdef.h>
 #include <asm/atomic.h>
-#include <asm/div64.h>
 #include "irq.h"
 
 #define PRId64 "d"
@@ -526,8 +526,8 @@ static u32 apic_get_tmcct(struct kvm_lap
 	} else
 		passed = ktime_sub(now, apic->timer.last_update);
 
-	counter_passed = div64_64(ktime_to_ns(passed),
-				  (APIC_BUS_CYCLE_NS * apic->timer.divide_count));
+	counter_passed = div64_u64(ktime_to_ns(passed),
+				   (APIC_BUS_CYCLE_NS * apic->timer.divide_count));
 
 	if (counter_passed > tmcct) {
 		if (unlikely(!apic_lvtt_period(apic))) {
diff -puN include/asm-arm/div64.h~rename-div64_64-to-div64_u64 include/asm-arm/div64.h
--- a/include/asm-arm/div64.h~rename-div64_64-to-div64_u64
+++ a/include/asm-arm/div64.h
@@ -224,6 +224,4 @@
 
 #endif
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
-
 #endif
diff -puN include/asm-generic/div64.h~rename-div64_64-to-div64_u64 include/asm-generic/div64.h
--- a/include/asm-generic/div64.h~rename-div64_64-to-div64_u64
+++ a/include/asm-generic/div64.h
@@ -30,11 +30,6 @@
 	__rem;							\
  })
 
-static inline uint64_t div64_64(uint64_t dividend, uint64_t divisor)
-{
-	return dividend / divisor;
-}
-
 #elif BITS_PER_LONG == 32
 
 extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
@@ -54,8 +49,6 @@ extern uint32_t __div64_32(uint64_t *div
 	__rem;						\
  })
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
-
 #else /* BITS_PER_LONG == ?? */
 
 # error do_div() does not yet support the C64
diff -puN include/asm-m68k/div64.h~rename-div64_64-to-div64_u64 include/asm-m68k/div64.h
--- a/include/asm-m68k/div64.h~rename-div64_64-to-div64_u64
+++ a/include/asm-m68k/div64.h
@@ -25,5 +25,4 @@
 	__rem;							\
 })
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 #endif /* _M68K_DIV64_H */
diff -puN include/asm-mips/div64.h~rename-div64_64-to-div64_u64 include/asm-mips/div64.h
--- a/include/asm-mips/div64.h~rename-div64_64-to-div64_u64
+++ a/include/asm-mips/div64.h
@@ -82,7 +82,6 @@
 	(n) = __quot; \
 	__mod; })
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 #endif /* (_MIPS_SZLONG == 32) */
 
 #if (_MIPS_SZLONG == 64)
@@ -106,11 +105,6 @@ extern uint64_t div64_64(uint64_t divide
 	(n) = __quot; \
 	__mod; })
 
-static inline uint64_t div64_64(uint64_t dividend, uint64_t divisor)
-{
-	return dividend / divisor;
-}
-
 #endif /* (_MIPS_SZLONG == 64) */
 
 #endif /* _ASM_DIV64_H */
diff -puN include/asm-mn10300/div64.h~rename-div64_64-to-div64_u64 include/asm-mn10300/div64.h
--- a/include/asm-mn10300/div64.h~rename-div64_64-to-div64_u64
+++ a/include/asm-mn10300/div64.h
@@ -97,7 +97,4 @@ signed __muldiv64s(signed val, signed mu
 	return result;
 }
 
-extern __attribute__((const))
-uint64_t div64_64(uint64_t dividend, uint64_t divisor);
-
 #endif /* _ASM_DIV64 */
diff -puN include/asm-um/div64.h~rename-div64_64-to-div64_u64 include/asm-um/div64.h
--- a/include/asm-um/div64.h~rename-div64_64-to-div64_u64
+++ a/include/asm-um/div64.h
@@ -3,5 +3,4 @@
 
 #include "asm/arch/div64.h"
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 #endif
diff -puN include/asm-x86/div64.h~rename-div64_64-to-div64_u64 include/asm-x86/div64.h
--- a/include/asm-x86/div64.h~rename-div64_64-to-div64_u64
+++ a/include/asm-x86/div64.h
@@ -71,8 +71,6 @@ static inline u64 div_u64_rem(u64 divide
 }
 #define div_u64_rem	div_u64_rem
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
-
 #else
 # include <asm-generic/div64.h>
 #endif /* CONFIG_X86_32 */
diff -puN include/linux/math64.h~rename-div64_64-to-div64_u64 include/linux/math64.h
--- a/include/linux/math64.h~rename-div64_64-to-div64_u64
+++ a/include/linux/math64.h
@@ -27,6 +27,14 @@ static inline s64 div_s64_rem(s64 divide
 	return dividend / divisor;
 }
 
+/**
+ * div64_u64 - unsigned 64bit divide with 64bit divisor
+ */
+static inline u64 div64_u64(u64 dividend, u64 divisor)
+{
+	return dividend / divisor;
+}
+
 #elif BITS_PER_LONG == 32
 
 #ifndef div_u64_rem
@@ -41,6 +49,10 @@ static inline u64 div_u64_rem(u64 divide
 extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);
 #endif
 
+#ifndef div64_u64
+extern u64 div64_u64(u64 dividend, u64 divisor);
+#endif
+
 #endif /* BITS_PER_LONG */
 
 /**
diff -puN kernel/sched.c~rename-div64_64-to-div64_u64 kernel/sched.c
--- a/kernel/sched.c~rename-div64_64-to-div64_u64
+++ a/kernel/sched.c
@@ -8025,7 +8025,7 @@ static void init_tg_cfs_entry(struct tas
 
 	se->my_q = cfs_rq;
 	se->load.weight = tg->shares;
-	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
+	se->load.inv_weight = div64_u64(1ULL<<32, se->load.weight);
 	se->parent = parent;
 }
 #endif
@@ -8692,7 +8692,7 @@ static void __set_se_shares(struct sched
 		dequeue_entity(cfs_rq, se, 0);
 
 	se->load.weight = shares;
-	se->load.inv_weight = div64_64((1ULL<<32), shares);
+	se->load.inv_weight = div64_u64((1ULL<<32), shares);
 
 	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);
@@ -8787,7 +8787,7 @@ static unsigned long to_ratio(u64 period
 	if (runtime == RUNTIME_INF)
 		return 1ULL << 16;
 
-	return div64_64(runtime << 16, period);
+	return div64_u64(runtime << 16, period);
 }
 
 #ifdef CONFIG_CGROUP_SCHED
diff -puN kernel/sched_debug.c~rename-div64_64-to-div64_u64 kernel/sched_debug.c
--- a/kernel/sched_debug.c~rename-div64_64-to-div64_u64
+++ a/kernel/sched_debug.c
@@ -357,8 +357,8 @@ void proc_sched_show_task(struct task_st
 
 		avg_per_cpu = p->se.sum_exec_runtime;
 		if (p->se.nr_migrations) {
-			avg_per_cpu = div64_64(avg_per_cpu,
-					       p->se.nr_migrations);
+			avg_per_cpu = div64_u64(avg_per_cpu,
+						p->se.nr_migrations);
 		} else {
 			avg_per_cpu = -1LL;
 		}
diff -puN lib/div64.c~rename-div64_64-to-div64_u64 lib/div64.c
--- a/lib/div64.c~rename-div64_64-to-div64_u64
+++ a/lib/div64.c
@@ -78,9 +78,10 @@ EXPORT_SYMBOL(div_s64_rem);
 #endif
 
 /* 64bit divisor, dividend and result. dynamic precision */
-uint64_t div64_64(uint64_t dividend, uint64_t divisor)
+#ifndef div64_u64
+u64 div64_u64(u64 dividend, u64 divisor)
 {
-	uint32_t high, d;
+	u32 high, d;
 
 	high = divisor >> 32;
 	if (high) {
@@ -91,10 +92,9 @@ uint64_t div64_64(uint64_t dividend, uin
 	} else
 		d = divisor;
 
-	do_div(dividend, d);
-
-	return dividend;
+	return div_u64(dividend, d);
 }
-EXPORT_SYMBOL(div64_64);
+EXPORT_SYMBOL(div64_u64);
+#endif
 
 #endif /* BITS_PER_LONG == 32 */
diff -puN net/ipv4/tcp_cubic.c~rename-div64_64-to-div64_u64 net/ipv4/tcp_cubic.c
--- a/net/ipv4/tcp_cubic.c~rename-div64_64-to-div64_u64
+++ a/net/ipv4/tcp_cubic.c
@@ -15,8 +15,8 @@
 
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/math64.h>
 #include <net/tcp.h>
-#include <asm/div64.h>
 
 #define BICTCP_BETA_SCALE    1024	/* Scale factor beta calculation
 					 * max_cwnd = snd_cwnd * beta
@@ -128,7 +128,7 @@ static u32 cubic_root(u64 a)
 	 * x    = ( 2 * x  +  a / x  ) / 3
 	 *  k+1          k         k
 	 */
-	x = (2 * x + (u32)div64_64(a, (u64)x * (u64)(x - 1)));
+	x = (2 * x + (u32)div64_u64(a, (u64)x * (u64)(x - 1)));
 	x = ((x * 341) >> 10);
 	return x;
 }
diff -puN net/netfilter/xt_connbytes.c~rename-div64_64-to-div64_u64 net/netfilter/xt_connbytes.c
--- a/net/netfilter/xt_connbytes.c~rename-div64_64-to-div64_u64
+++ a/net/netfilter/xt_connbytes.c
@@ -4,12 +4,11 @@
 #include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/skbuff.h>
+#include <linux/math64.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_connbytes.h>
 #include <net/netfilter/nf_conntrack.h>
 
-#include <asm/div64.h>
