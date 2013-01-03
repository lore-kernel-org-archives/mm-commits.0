From: akpm@linux-foundation.org
Subject: + generic-dynamic-per-cpu-refcounting.patch added to -mm tree
Date: Thu, 03 Jan 2013 15:41:05 -0800
Message-ID: <20130103234105.6F86782004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42187 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab3ACXlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 18:41:07 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so1724067qaq.1
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 15:41:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: generic dynamic per cpu refcounting
has been added to the -mm tree.  Its filename is
     generic-dynamic-per-cpu-refcounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: generic dynamic per cpu refcounting

This implements a refcount with similar semantics to
atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
but dynamically switches to per cpu refcounting when the rate of gets/puts
becomes too high.

It also implements two stage shutdown, as we need it to tear down the
percpu counts.  Before dropping the initial refcount, you must call
percpu_ref_kill(); this puts the refcount in "shutting down mode" and
switches back to a single atomic refcount with the appropriate barriers
(synchronize_rcu()).

It's also legal to call percpu_ref_kill() multiple times - it only returns
true once, so callers don't have to reimplement shutdown synchronization.

For the sake of simplicity/efficiency, the heuristic is pretty simple - it
just switches to percpu refcounting if there are more than x gets in one
second (completely arbitrarily, 4096).

It'd be more correct to count the number of cache misses or something else
more profile driven, but doing so would require accessing the shared ref
twice per get - by just counting the number of gets(), we can stick that
counter in the high bits of the refcount and increment both with a single
atomic64_add().  But I expect this'll be good enough in practice.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-refcount.h |   29 +++++
 lib/Makefile                    |    2 
 lib/percpu-refcount.c           |  164 ++++++++++++++++++++++++++++++
 3 files changed, 194 insertions(+), 1 deletion(-)

diff -puN /dev/null include/linux/percpu-refcount.h
--- /dev/null
+++ a/include/linux/percpu-refcount.h
@@ -0,0 +1,29 @@
+#ifndef _LINUX_PERCPU_REFCOUNT_H
+#define _LINUX_PERCPU_REFCOUNT_H
+
+#include <linux/atomic.h>
+#include <linux/percpu.h>
+
+struct percpu_ref {
+	atomic64_t		count;
+	unsigned __percpu	*pcpu_count;
+};
+
+void percpu_ref_init(struct percpu_ref *ref);
+void __percpu_ref_get(struct percpu_ref *ref, bool alloc);
+int percpu_ref_put(struct percpu_ref *ref);
+
+int percpu_ref_kill(struct percpu_ref *ref);
+int percpu_ref_dead(struct percpu_ref *ref);
+
+static inline void percpu_ref_get(struct percpu_ref *ref)
+{
+	__percpu_ref_get(ref, true);
+}
+
+static inline void percpu_ref_get_noalloc(struct percpu_ref *ref)
+{
+	__percpu_ref_get(ref, false);
+}
+
+#endif
diff -puN lib/Makefile~generic-dynamic-per-cpu-refcounting lib/Makefile
--- a/lib/Makefile~generic-dynamic-per-cpu-refcounting
+++ a/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o
+	 earlycpio.o percpu-refcount.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff -puN /dev/null lib/percpu-refcount.c
--- /dev/null
+++ a/lib/percpu-refcount.c
@@ -0,0 +1,164 @@
+#define pr_fmt(fmt) "%s: " fmt "\n", __func__
+
+#include <linux/kernel.h>
+#include <linux/percpu-refcount.h>
+#include <linux/rcupdate.h>
+
+#define PCPU_COUNT_BITS		50
+#define PCPU_COUNT_MASK		((1LL << PCPU_COUNT_BITS) - 1)
+
+#define PCPU_STATUS_BITS	2
+#define PCPU_STATUS_MASK	((1 << PCPU_STATUS_BITS) - 1)
+
+#define PCPU_REF_PTR		0
+#define PCPU_REF_NONE		1
+#define PCPU_REF_DYING		2
+#define PCPU_REF_DEAD		3
+
+#define REF_STATUS(count)	((unsigned long) count & PCPU_STATUS_MASK)
+
+void percpu_ref_init(struct percpu_ref *ref)
+{
+	unsigned long now = jiffies;
+
+	atomic64_set(&ref->count, 1);
+
+	now <<= PCPU_STATUS_BITS;
+	now |= PCPU_REF_NONE;
+
+	ref->pcpu_count = (void *) now;
+}
+
+static void percpu_ref_alloc(struct percpu_ref *ref, unsigned __user *pcpu_count)
+{
+	unsigned __percpu *new;
+	unsigned long last = (unsigned long) pcpu_count;
+	unsigned long now = jiffies;
+
+	now <<= PCPU_STATUS_BITS;
+	now |= PCPU_REF_NONE;
+
+	if (now - last <= HZ << PCPU_STATUS_BITS) {
+		rcu_read_unlock();
+		new = alloc_percpu(unsigned);
+		rcu_read_lock();
+
+		if (!new)
+			goto update_time;
+
+		BUG_ON(((unsigned long) new) & PCPU_STATUS_MASK);
+
+		if (cmpxchg(&ref->pcpu_count, pcpu_count, new) != pcpu_count)
+			free_percpu(new);
+		else
+			pr_debug("created");
+	} else {
+update_time:	new = (void *) now;
+		cmpxchg(&ref->pcpu_count, pcpu_count, new);
+	}
+}
+
+void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
+{
+	unsigned __percpu *pcpu_count;
+	uint64_t v;
+
+	pcpu_count = rcu_dereference(ref->pcpu_count);
+
+	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
+		__this_cpu_inc(*pcpu_count);
+	} else {
+		v = atomic64_add_return(1 + (1ULL << PCPU_COUNT_BITS),
+					&ref->count);
+
+		if (!(v >> PCPU_COUNT_BITS) &&
+		    REF_STATUS(pcpu_count) == PCPU_REF_NONE && alloc)
+			percpu_ref_alloc(ref, pcpu_count);
+	}
+}
+
+int percpu_ref_put(struct percpu_ref *ref)
+{
+	unsigned __percpu *pcpu_count;
+	uint64_t v;
+	int ret = 0;
+
+	rcu_read_lock();
+
+	pcpu_count = rcu_dereference(ref->pcpu_count);
+
+	switch (REF_STATUS(pcpu_count)) {
+	case PCPU_REF_PTR:
+		__this_cpu_dec(*pcpu_count);
+		break;
+	case PCPU_REF_NONE:
+	case PCPU_REF_DYING:
+		atomic64_dec(&ref->count);
+		break;
+	case PCPU_REF_DEAD:
+		v = atomic64_dec_return(&ref->count);
+		v &= PCPU_COUNT_MASK;
+
+		ret = v == 0;
+		break;
+	}
+
+	rcu_read_unlock();
+
+	return ret;
+}
+
+int percpu_ref_kill(struct percpu_ref *ref)
+{
+	unsigned __percpu *old, *new, *pcpu_count = ref->pcpu_count;
+	unsigned long status;
+
+	do {
+		status = REF_STATUS(pcpu_count);
+
+		switch (status) {
+		case PCPU_REF_PTR:
+			new = (void *) PCPU_REF_DYING;
+			break;
+		case PCPU_REF_NONE:
+			new = (void *) PCPU_REF_DEAD;
+			break;
+		case PCPU_REF_DYING:
+		case PCPU_REF_DEAD:
+			return 0;
+		}
+
+		old = pcpu_count;
+		pcpu_count = cmpxchg(&ref->pcpu_count, old, new);
+	} while (pcpu_count != old);
+
+	if (status == PCPU_REF_PTR) {
+		unsigned count = 0, cpu;
+
+		synchronize_rcu();
+
+		for_each_possible_cpu(cpu)
+			count += *per_cpu_ptr(pcpu_count, cpu);
+
+		pr_debug("global %lli pcpu %i",
+			 atomic64_read(&ref->count) & PCPU_COUNT_MASK,
+			 (int) count);
+
+		atomic64_add((int) count, &ref->count);
+		smp_wmb();
+		/* Between setting global count and setting PCPU_REF_DEAD */
+		ref->pcpu_count = (void *) PCPU_REF_DEAD;
+
+		free_percpu(pcpu_count);
+	}
+
+	return 1;
+}
+
+int percpu_ref_dead(struct percpu_ref *ref)
+{
+	unsigned status = REF_STATUS(ref->pcpu_count);
+
+	return status == PCPU_REF_DYING ||
+		status == PCPU_REF_DEAD;
+}
_

Patches currently in -mm which might be from koverstreet@google.com are

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-smoosh-struct-kiocb.patch

