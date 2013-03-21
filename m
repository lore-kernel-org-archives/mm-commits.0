From: akpm@linux-foundation.org
Subject: + generic-dynamic-per-cpu-refcounting.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:38:30 -0700
Message-ID: <20130321223831.1192031C121@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:32946 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3CUWid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:38:33 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so311547qen.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:38:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com


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

[akpm@linux-foundation.org: fix build]
[akpm@linux-foundation.org: coding-style tweak]
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
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-refcount.h |  114 ++++++++++++++
 lib/Makefile                    |    2 
 lib/percpu-refcount.c           |  243 ++++++++++++++++++++++++++++++
 3 files changed, 358 insertions(+), 1 deletion(-)

diff -puN /dev/null include/linux/percpu-refcount.h
--- /dev/null
+++ a/include/linux/percpu-refcount.h
@@ -0,0 +1,114 @@
+/*
+ * Dynamic percpu refcounts:
+ * (C) 2012 Google, Inc.
+ * Author: Kent Overstreet <koverstreet@google.com>
+ *
+ * This implements a refcount with similar semantics to atomic_t - atomic_inc(),
+ * atomic_dec_and_test() - but potentially percpu.
+ *
+ * There's one important difference between percpu refs and normal atomic_t
+ * refcounts; you have to keep track of your initial refcount, and then when you
+ * start shutting down you call percpu_ref_kill() _before_ dropping the initial
+ * refcount.
+ *
+ * Before you call percpu_ref_kill(), percpu_ref_put() does not check for the
+ * refcount hitting 0 - it can't, if it was in percpu mode. percpu_ref_kill()
+ * puts the ref back in single atomic_t mode, collecting the per cpu refs and
+ * issuing the appropriate barriers, and then marks the ref as shutting down so
+ * that percpu_ref_put() will check for the ref hitting 0.  After it returns,
+ * it's safe to drop the initial ref.
+ *
+ * BACKGROUND:
+ *
+ * Percpu refcounts are quite useful for performance, but if we blindly
+ * converted all refcounts to percpu counters we'd waste quite a bit of memory.
+ *
+ * Think about all the refcounts embedded in kobjects, files, etc. most of which
+ * aren't used much. These start out as simple atomic counters - a little bigger
+ * than a bare atomic_t, 16 bytes instead of 4 - but if we exceed some arbitrary
+ * number of gets in one second, we then switch to percpu counters.
+ *
+ * This heuristic isn't perfect because it'll fire if the refcount was only
+ * being used on one cpu; ideally we'd be able to count the number of cache
+ * misses on percpu_ref_get() or something similar, but that'd make the non
+ * percpu path significantly heavier/more complex. We can count the number of
+ * gets() without any extra atomic instructions on arches that support
+ * atomic64_t - simply by changing the atomic_inc() to atomic_add_return().
+ *
+ * USAGE:
+ *
+ * See fs/aio.c for some example usage; it's used there for struct kioctx, which
+ * is created when userspaces calls io_setup(), and destroyed when userspace
+ * calls io_destroy() or the process exits.
+ *
+ * In the aio code, kill_ioctx() is called when we wish to destroy a kioctx; it
+ * calls percpu_ref_kill(), then hlist_del_rcu() and sychronize_rcu() to remove
+ * the kioctx from the proccess's list of kioctxs - after that, there can't be
+ * any new users of the kioctx (from lookup_ioctx()) and it's then safe to drop
+ * the initial ref with percpu_ref_put().
+ *
+ * Code that does a two stage shutdown like this often needs some kind of
+ * explicit synchronization to ensure the initial refcount can only be dropped
+ * once - percpu_ref_kill() does this for you, it returns true once and false if
+ * someone else already called it. The aio code uses it this way, but it's not
+ * necessary if the code has some other mechanism to synchronize teardown.
+ *
+ * As mentioned previously, we decide when to convert a ref to percpu counters
+ * in percpu_ref_get(). However, since percpu_ref_get() will often be called
+ * with rcu_read_lock() held, it's not done there - percpu_ref_get() returns
+ * true if the ref should be converted to percpu counters.
+ *
+ * The caller should then call percpu_ref_alloc() after dropping
+ * rcu_read_lock(); if there is an uncommonly used codepath where it's
+ * inconvenient to call percpu_ref_alloc() after get(), it may be safely skipped
+ * and percpu_ref_get() will return true again the next time the counter wraps
+ * around.
+ */
+
+#ifndef _LINUX_PERCPU_REFCOUNT_H
+#define _LINUX_PERCPU_REFCOUNT_H
+
+#include <linux/atomic.h>
+#include <linux/percpu.h>
+
+struct percpu_ref {
+	atomic64_t		count;
+	unsigned long		pcpu_count;
+};
+
+void percpu_ref_init(struct percpu_ref *ref);
+void __percpu_ref_get(struct percpu_ref *ref, bool alloc);
+int percpu_ref_put(struct percpu_ref *ref);
+
+int percpu_ref_kill(struct percpu_ref *ref);
+int percpu_ref_dead(struct percpu_ref *ref);
+
+/**
+ * percpu_ref_get - increment a dynamic percpu refcount
+ *
+ * Increments @ref and possibly converts it to percpu counters. Must be called
+ * with rcu_read_lock() held, and may potentially drop/reacquire rcu_read_lock()
+ * to allocate percpu counters - if sleeping/allocation isn't safe for some
+ * other reason (e.g. a spinlock), see percpu_ref_get_noalloc().
+ *
+ * Analagous to atomic_inc().
+  */
+static inline void percpu_ref_get(struct percpu_ref *ref)
+{
+	__percpu_ref_get(ref, true);
+}
+
+/**
+ * percpu_ref_get_noalloc - increment a dynamic percpu refcount
+ *
+ * Increments @ref, to be used when it's not safe to allocate percpu counters.
+ * Must be called with rcu_read_lock() held.
+ *
+ * Analagous to atomic_inc().
+  */
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
@@ -0,0 +1,243 @@
+#define pr_fmt(fmt) "%s: " fmt "\n", __func__
+
+#include <linux/kernel.h>
+#include <linux/jiffies.h>
+#include <linux/percpu-refcount.h>
+#include <linux/rcupdate.h>
+
+/*
+ * A percpu refcount can be in 4 different modes. The state is tracked in the
+ * low two bits of percpu_ref->pcpu_count:
+ *
+ * PCPU_REF_NONE - the initial state, no percpu counters allocated.
+ *
+ * PCPU_REF_PTR - using percpu counters for the refcount.
+ *
+ * PCPU_REF_DYING - we're shutting down so get()/put() should use the embedded
+ * atomic counter, but we're not finished updating the atomic counter from the
+ * percpu counters - this means that percpu_ref_put() can't check for the ref
+ * hitting 0 yet.
+ *
+ * PCPU_REF_DEAD - we've finished the teardown sequence, percpu_ref_put() should
+ * now check for the ref hitting 0.
+ *
+ * In PCPU_REF_NONE mode, we need to count the number of times percpu_ref_get()
+ * is called; this is done with the high bits of the raw atomic counter. We also
+ * track the time, in jiffies, when the get count last wrapped - this is done
+ * with the remaining bits of percpu_ref->percpu_count.
+ *
+ * So, when percpu_ref_get() is called it increments the get count and checks if
+ * it wrapped; if it did, it checks if the last time it wrapped was less than
+ * one second ago; if so, we want to allocate percpu counters.
+ *
+ * PCPU_COUNT_BITS determines the threshold where we convert to percpu: of the
+ * raw 64 bit counter, we use PCPU_COUNT_BITS for the refcount, and the
+ * remaining (high) bits to count the number of times percpu_ref_get() has been
+ * called. It's currently (completely arbitrarily) 16384 times in one second.
+ *
+ * Percpu mode (PCPU_REF_PTR):
+ *
+ * In percpu mode all we do on get and put is increment or decrement the cpu
+ * local counter, which is a 32 bit unsigned int.
+ *
+ * Note that all the gets() could be happening on one cpu, and all the puts() on
+ * another - the individual cpu counters can wrap (potentially many times).
+ *
+ * But this is fine because we don't need to check for the ref hitting 0 in
+ * percpu mode; before we set the state to PCPU_REF_DEAD we simply sum up all
+ * the percpu counters and add them to the atomic counter. Since addition and
+ * subtraction in modular arithmatic is still associative, the result will be
+ * correct.
+ */
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
+#define REF_STATUS(count)	(count & PCPU_STATUS_MASK)
+
+/**
+ * percpu_ref_init - initialize a dynamic percpu refcount
+ *
+ * Initializes the refcount in single atomic counter mode with a refcount of 1;
+ * analagous to atomic_set(ref, 1).
+ */
+void percpu_ref_init(struct percpu_ref *ref)
+{
+	unsigned long now = jiffies;
+
+	atomic64_set(&ref->count, 1);
+
+	now <<= PCPU_STATUS_BITS;
+	now |= PCPU_REF_NONE;
+
+	ref->pcpu_count = now;
+}
+
+static void percpu_ref_alloc(struct percpu_ref *ref, unsigned long pcpu_count)
+{
+	unsigned long new, now = jiffies;
+
+	now <<= PCPU_STATUS_BITS;
+	now |= PCPU_REF_NONE;
+
+	if (now - pcpu_count <= HZ << PCPU_STATUS_BITS) {
+		rcu_read_unlock();
+		new = (unsigned long) alloc_percpu(unsigned);
+		rcu_read_lock();
+
+		if (!new)
+			goto update_time;
+
+		BUG_ON(new & PCPU_STATUS_MASK);
+
+		if (cmpxchg(&ref->pcpu_count, pcpu_count, new) != pcpu_count)
+			free_percpu((void __percpu *) new);
+		else
+			pr_debug("created");
+	} else {
+update_time:
+		new = now;
+		cmpxchg(&ref->pcpu_count, pcpu_count, new);
+	}
+}
+
+void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
+{
+	unsigned long pcpu_count;
+	uint64_t v;
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
+		/* for rcu - we're not using rcu_dereference() */
+		smp_read_barrier_depends();
+		__this_cpu_inc(*((unsigned __percpu *) pcpu_count));
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
+/**
+ * percpu_ref_put - decrement a dynamic percpu refcount
+ *
+ * Returns true if the result is 0, otherwise false; only checks for the ref
+ * hitting 0 after percpu_ref_kill() has been called. Analagous to
+ * atomic_dec_and_test().
+ */
+int percpu_ref_put(struct percpu_ref *ref)
+{
+	unsigned long pcpu_count;
+	uint64_t v;
+	int ret = 0;
+
+	rcu_read_lock();
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	switch (REF_STATUS(pcpu_count)) {
+	case PCPU_REF_PTR:
+		/* for rcu - we're not using rcu_dereference() */
+		smp_read_barrier_depends();
+		__this_cpu_dec(*((unsigned __percpu *) pcpu_count));
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
+/**
+ * percpu_ref_kill - prepare a dynamic percpu refcount for teardown
+ *
+ * Must be called before dropping the initial ref, so that percpu_ref_put()
+ * knows to check for the refcount hitting 0. If the refcount was in percpu
+ * mode, converts it back to single atomic counter mode.
+ *
+ * Returns true the first time called on @ref and false if @ref is already
+ * shutting down, so it may be used by the caller for synchronizing other parts
+ * of a two stage shutdown.
+ */
+int percpu_ref_kill(struct percpu_ref *ref)
+{
+	unsigned long old, new, status, pcpu_count;
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	do {
+		status = REF_STATUS(pcpu_count);
+
+		switch (status) {
+		case PCPU_REF_PTR:
+			new = PCPU_REF_DYING;
+			break;
+		case PCPU_REF_NONE:
+			new = PCPU_REF_DEAD;
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
+			count += *per_cpu_ptr((unsigned __percpu *) pcpu_count, cpu);
+
+		pr_debug("global %lli pcpu %i",
+			 atomic64_read(&ref->count) & PCPU_COUNT_MASK,
+			 (int) count);
+
+		atomic64_add((int) count, &ref->count);
+		smp_wmb();
+		/* Between setting global count and setting PCPU_REF_DEAD */
+		ref->pcpu_count = PCPU_REF_DEAD;
+
+		free_percpu((unsigned __percpu *) pcpu_count);
+	}
+
+	return 1;
+}
+
+/**
+ * percpu_ref_dead - check if a dynamic percpu refcount is shutting down
+ *
+ * Returns true if percpu_ref_kill() has been called on @ref, false otherwise.
+ */
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
aio-add-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

