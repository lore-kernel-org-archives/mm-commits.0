From: akpm@linux-foundation.org
Subject: [folded-merged] generic-dynamic-per-cpu-refcounting-doc.patch removed from -mm tree
Date: Mon, 18 Mar 2013 13:33:38 -0700
Message-ID: <20130318203338.A56415A44D1@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55995 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab3CRUdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 16:33:40 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so438819vcb.5
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 13:33:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: generic-dynamic-per-cpu-refcounting-doc
has been removed from the -mm tree.  Its filename was
     generic-dynamic-per-cpu-refcounting-doc.patch

This patch was dropped because it was folded into generic-dynamic-per-cpu-refcounting.patch

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: generic-dynamic-per-cpu-refcounting-doc

percpu-refcount: Documentation

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-refcount.h |   86 ++++++++++++++++++++++++++++++
 lib/percpu-refcount.c           |   74 +++++++++++++++++++++++++
 2 files changed, 160 insertions(+)

diff -puN include/linux/percpu-refcount.h~generic-dynamic-per-cpu-refcounting-doc include/linux/percpu-refcount.h
--- a/include/linux/percpu-refcount.h~generic-dynamic-per-cpu-refcounting-doc
+++ a/include/linux/percpu-refcount.h
@@ -1,3 +1,71 @@
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
+ * converted all refcounts to percpu counters we'd waste quite a bit of memory
+ * think about all the refcounts embedded in kobjects, files, etc. most of which
+ * aren't used much.
+ *
+ * These start out as simple atomic counters - a little bigger than a bare
+ * atomic_t, 16 bytes instead of 4 - but if we exceed some arbitrary number of
+ * gets in one second, we then switch to percpu counters.
+ *
+ * This heuristic isn't perfect because it'll fire if the refcount was only
+ * being used on one cpu; ideally we'd be able to count the number of cache
+ * misses on percpu_ref_get() or something similar, but that'd make the non
+ * percpu path significantly heavier/more complex. We can count the number of
+ * gets() without any extra atomic instructions, on arches that support
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
 #ifndef _LINUX_PERCPU_REFCOUNT_H
 #define _LINUX_PERCPU_REFCOUNT_H
 
@@ -16,11 +84,29 @@ int percpu_ref_put(struct percpu_ref *re
 int percpu_ref_kill(struct percpu_ref *ref);
 int percpu_ref_dead(struct percpu_ref *ref);
 
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
 static inline void percpu_ref_get(struct percpu_ref *ref)
 {
 	__percpu_ref_get(ref, true);
 }
 
+/**
+ * percpu_ref_get_noalloc - increment a dynamic percpu refcount
+ *
+ * Increments @ref, to be used when it's not safe to allocate percpu counters.
+ * Must be called with rcu_read_lock() held.
+ *
+ * Analagous to atomic_inc().
+  */
 static inline void percpu_ref_get_noalloc(struct percpu_ref *ref)
 {
 	__percpu_ref_get(ref, false);
diff -puN lib/percpu-refcount.c~generic-dynamic-per-cpu-refcounting-doc lib/percpu-refcount.c
--- a/lib/percpu-refcount.c~generic-dynamic-per-cpu-refcounting-doc
+++ a/lib/percpu-refcount.c
@@ -5,6 +5,51 @@
 #include <linux/percpu-refcount.h>
 #include <linux/rcupdate.h>
 
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
 #define PCPU_COUNT_BITS		50
 #define PCPU_COUNT_MASK		((1LL << PCPU_COUNT_BITS) - 1)
 
@@ -18,6 +63,12 @@
 
 #define REF_STATUS(count)	(count & PCPU_STATUS_MASK)
 
+/**
+ * percpu_ref_init - initialize a dynamic percpu refcount
+ *
+ * Initializes the refcount in single atomic counter mode with a refcount of 1;
+ * analagous to atomic_set(ref, 1).
+ */
 void percpu_ref_init(struct percpu_ref *ref)
 {
 	unsigned long now = jiffies;
@@ -79,6 +130,13 @@ void __percpu_ref_get(struct percpu_ref
 	}
 }
 
+/**
+ * percpu_ref_put - decrement a dynamic percpu refcount
+ *
+ * Returns true if the result is 0, otherwise false; only checks for the ref
+ * hitting 0 after percpu_ref_kill() has been called. Analagous to
+ * atomic_dec_and_test().
+ */
 int percpu_ref_put(struct percpu_ref *ref)
 {
 	unsigned long pcpu_count;
@@ -112,6 +170,17 @@ int percpu_ref_put(struct percpu_ref *re
 	return ret;
 }
 
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
 int percpu_ref_kill(struct percpu_ref *ref)
 {
 	unsigned long old, new, status, pcpu_count;
@@ -160,6 +229,11 @@ int percpu_ref_kill(struct percpu_ref *r
 	return 1;
 }
 
+/**
+ * percpu_ref_dead - check if a dynamic percpu refcount is shutting down
+ *
+ * Returns true if percpu_ref_kill() has been called on @ref, false otherwise.
+ */
 int percpu_ref_dead(struct percpu_ref *ref)
 {
 	unsigned status = REF_STATUS(ref->pcpu_count);
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
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix-fix.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion-fix.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-v3-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

