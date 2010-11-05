From: akpm@linux-foundation.org
Subject: + atomic-add-atomic_inc_not_zero_hint.patch added to -mm tree
Date: Fri, 05 Nov 2010 12:42:11 -0700
Message-ID: <201011051942.oA5JgBUm028976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845Ab0KETnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 15:43:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, acme@infradead.org, andi@firstfloor.org, cl@linux-foundation.org, davem@davemloft.net, mingo@elte.hu, npiggin@kernel.dk, paulmck@linux.vnet.ibm.com


The patch titled
     atomic: add atomic_inc_not_zero_hint()
has been added to the -mm tree.  Its filename is
     atomic-add-atomic_inc_not_zero_hint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Miller <davem@davemloft.net>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>
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
+ 	do {
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

atomic-add-atomic_inc_not_zero_hint.patch
net-avoid-limits-overflow.patch
percpucounter-optimize-__percpu_counter_add-a-bit-through-the-use-of-this_cpu-operations.patch

