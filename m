From: akpm@linux-foundation.org
Subject: [merged] atomic-add-atomic_inc_not_zero_hint.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:01 -0800
Message-ID: <201011161933.oAGJXDvc003086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504Ab0KPTd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, acme@infradead.org, andi@firstfloor.org, cl@linux-foundation.org, davem@davemloft.net, mingo@elte.hu, npiggin@kernel.dk, paulmck@linux.vnet.ibm.com, mm-commits


The patch titled
     atomic: add atomic_inc_not_zero_hint()
has been removed from the -mm tree.  Its filename was
     atomic-add-atomic_inc_not_zero_hint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atomic: add atomic_inc_not_zero_hint()
From: Eric Dumazet <eric.dumazet@gmail.com>

Followup of perf tools session in Netfilter WorkShop 2010

In the network stack we make high usage of atomic_inc_not_zero() in
contexts we know the probable value of atomic before increment (2 for udp
sockets for example)

Using a special version of atomic_inc_not_zero() giving this hint can help
processor to use less bus transactions.

On x86 (MESI protocol) for example, this avoids entering Shared state,
because "lock cmpxchg" issues an RFO (Read For Ownership)

akpm: Adds a new include/linux/atomic.h.  This means that new code should
henceforth include linux/atomic.h and not asm/atomic.h.  The presence of
include/linux/atomic.h will in fact cause checkpatch.pl to warn about use
of asm/atomic.h.  The new include/linux/atomic.h becomes the place where
arch-neutral atomic_t code should be placed.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Miller <davem@davemloft.net>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/atomic.h |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff -puN /dev/null include/linux/atomic.h
--- /dev/null
+++ a/include/linux/atomic.h
@@ -0,0 +1,37 @@
+#ifndef _LINUX_ATOMIC_H
+#define _LINUX_ATOMIC_H
+#include <asm/atomic.h>
+
+/**
+ * atomic_inc_not_zero_hint - increment if not null
+ * @v: pointer of type atomic_t
+ * @hint: probable value of the atomic before the increment
+ *
+ * This version of atomic_inc_not_zero() gives a hint of probable
+ * value of the atomic. This helps processor to not read the memory
+ * before doing the atomic read/modify/write cycle, lowering
+ * number of bus transactions on some arches.
+ *
+ * Returns: 0 if increment was not done, 1 otherwise.
+ */
+#ifndef atomic_inc_not_zero_hint
+static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
+{
+	int val, c = hint;
+
+	/* sanity test, should be removed by compiler if hint is a constant */
+	if (!hint)
+		return atomic_inc_not_zero(v);
+
+	do {
+		val = atomic_cmpxchg(v, c, c + 1);
+		if (val == c)
+			return 1;
+		c = val;
+	} while (c);
+
+	return 0;
+}
+#endif
+
+#endif /* _LINUX_ATOMIC_H */
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

linux-next.patch
irq-use-per_cpu-kstat_irqs.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
percpucounter-optimize-__percpu_counter_add-a-bit-through-the-use-of-this_cpu-operations.patch

