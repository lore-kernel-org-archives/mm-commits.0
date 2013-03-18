From: akpm@linux-foundation.org
Subject: [folded-merged] generic-dynamic-per-cpu-refcounting-sparse-fixes.patch removed from -mm tree
Date: Mon, 18 Mar 2013 13:33:32 -0700
Message-ID: <20130318203333.331715A44D1@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:36087 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3CRUde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 16:33:34 -0400
Received: by mail-vb0-f73.google.com with SMTP id fj18so609208vbb.2
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 13:33:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: percpu-refcount: sparse fixes
has been removed from the -mm tree.  Its filename was
     generic-dynamic-per-cpu-refcounting-sparse-fixes.patch

This patch was dropped because it was folded into generic-dynamic-per-cpu-refcounting.patch

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: percpu-refcount: sparse fixes

Here's some more fixes, the percpu refcount code is now sparse clean for
me.  It's kind of ugly, but I'm not sure it's really any uglier than it
was before.  Seem reasonable?

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-refcount.h |    2 -
 lib/percpu-refcount.c           |   51 +++++++++++++++---------------
 2 files changed, 28 insertions(+), 25 deletions(-)

diff -puN include/linux/percpu-refcount.h~generic-dynamic-per-cpu-refcounting-sparse-fixes include/linux/percpu-refcount.h
--- a/include/linux/percpu-refcount.h~generic-dynamic-per-cpu-refcounting-sparse-fixes
+++ a/include/linux/percpu-refcount.h
@@ -6,7 +6,7 @@
 
 struct percpu_ref {
 	atomic64_t		count;
-	unsigned __percpu	*pcpu_count;
+	unsigned long		pcpu_count;
 };
 
 void percpu_ref_init(struct percpu_ref *ref);
diff -puN lib/percpu-refcount.c~generic-dynamic-per-cpu-refcounting-sparse-fixes lib/percpu-refcount.c
--- a/lib/percpu-refcount.c~generic-dynamic-per-cpu-refcounting-sparse-fixes
+++ a/lib/percpu-refcount.c
@@ -16,7 +16,7 @@
 #define PCPU_REF_DYING		2
 #define PCPU_REF_DEAD		3
 
-#define REF_STATUS(count)	((unsigned long) count & PCPU_STATUS_MASK)
+#define REF_STATUS(count)	(count & PCPU_STATUS_MASK)
 
 void percpu_ref_init(struct percpu_ref *ref)
 {
@@ -27,47 +27,47 @@ void percpu_ref_init(struct percpu_ref *
 	now <<= PCPU_STATUS_BITS;
 	now |= PCPU_REF_NONE;
 
-	ref->pcpu_count = (void *) now;
+	ref->pcpu_count = now;
 }
 
-static void percpu_ref_alloc(struct percpu_ref *ref, unsigned __user *pcpu_count)
+static void percpu_ref_alloc(struct percpu_ref *ref, unsigned long pcpu_count)
 {
-	unsigned __percpu *new;
-	unsigned long last = (unsigned long) pcpu_count;
-	unsigned long now = jiffies;
+	unsigned long new, now = jiffies;
 
 	now <<= PCPU_STATUS_BITS;
 	now |= PCPU_REF_NONE;
 
-	if (now - last <= HZ << PCPU_STATUS_BITS) {
+	if (now - pcpu_count <= HZ << PCPU_STATUS_BITS) {
 		rcu_read_unlock();
-		new = alloc_percpu(unsigned);
+		new = (unsigned long) alloc_percpu(unsigned);
 		rcu_read_lock();
 
 		if (!new)
 			goto update_time;
 
-		BUG_ON(((unsigned long) new) & PCPU_STATUS_MASK);
+		BUG_ON(new & PCPU_STATUS_MASK);
 
 		if (cmpxchg(&ref->pcpu_count, pcpu_count, new) != pcpu_count)
-			free_percpu(new);
+			free_percpu((void __percpu *) new);
 		else
 			pr_debug("created");
 	} else {
-update_time:	new = (void *) now;
+update_time:	new = now;
 		cmpxchg(&ref->pcpu_count, pcpu_count, new);
 	}
 }
 
 void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
 {
-	unsigned __percpu *pcpu_count;
+	unsigned long pcpu_count;
 	uint64_t v;
 
-	pcpu_count = rcu_dereference(ref->pcpu_count);
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (REF_STATUS(pcpu_count) == PCPU_REF_PTR) {
-		__this_cpu_inc(*pcpu_count);
+		/* for rcu - we're not using rcu_dereference() */
+		smp_read_barrier_depends();
+		__this_cpu_inc(*((unsigned __percpu *) pcpu_count));
 	} else {
 		v = atomic64_add_return(1 + (1ULL << PCPU_COUNT_BITS),
 					&ref->count);
@@ -80,17 +80,19 @@ void __percpu_ref_get(struct percpu_ref
 
 int percpu_ref_put(struct percpu_ref *ref)
 {
-	unsigned __percpu *pcpu_count;
+	unsigned long pcpu_count;
 	uint64_t v;
 	int ret = 0;
 
 	rcu_read_lock();
 
-	pcpu_count = rcu_dereference(ref->pcpu_count);
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	switch (REF_STATUS(pcpu_count)) {
 	case PCPU_REF_PTR:
-		__this_cpu_dec(*pcpu_count);
+		/* for rcu - we're not using rcu_dereference() */
+		smp_read_barrier_depends();
+		__this_cpu_dec(*((unsigned __percpu *) pcpu_count));
 		break;
 	case PCPU_REF_NONE:
 	case PCPU_REF_DYING:
@@ -111,18 +113,19 @@ int percpu_ref_put(struct percpu_ref *re
 
 int percpu_ref_kill(struct percpu_ref *ref)
 {
-	unsigned __percpu *old, *new, *pcpu_count = ref->pcpu_count;
-	unsigned long status;
+	unsigned long old, new, status, pcpu_count;
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	do {
 		status = REF_STATUS(pcpu_count);
 
 		switch (status) {
 		case PCPU_REF_PTR:
-			new = (void *) PCPU_REF_DYING;
+			new = PCPU_REF_DYING;
 			break;
 		case PCPU_REF_NONE:
-			new = (void *) PCPU_REF_DEAD;
+			new = PCPU_REF_DEAD;
 			break;
 		case PCPU_REF_DYING:
 		case PCPU_REF_DEAD:
@@ -139,7 +142,7 @@ int percpu_ref_kill(struct percpu_ref *r
 		synchronize_rcu();
 
 		for_each_possible_cpu(cpu)
-			count += *per_cpu_ptr(pcpu_count, cpu);
+			count += *per_cpu_ptr((unsigned __percpu *) pcpu_count, cpu);
 
 		pr_debug("global %lli pcpu %i",
 			 atomic64_read(&ref->count) & PCPU_COUNT_MASK,
@@ -148,9 +151,9 @@ int percpu_ref_kill(struct percpu_ref *r
 		atomic64_add((int) count, &ref->count);
 		smp_wmb();
 		/* Between setting global count and setting PCPU_REF_DEAD */
-		ref->pcpu_count = (void *) PCPU_REF_DEAD;
+		ref->pcpu_count = PCPU_REF_DEAD;
 
-		free_percpu(pcpu_count);
+		free_percpu((unsigned __percpu *) pcpu_count);
 	}
 
 	return 1;
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
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc.patch
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

