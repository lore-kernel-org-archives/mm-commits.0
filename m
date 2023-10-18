Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E69CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbjJRVgZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjJRVft (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719C412B
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43354C433BC;
        Wed, 18 Oct 2023 21:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664908;
        bh=38uLEHodoUVBOO061JCTGYIWWwPLnAnlvgY1jk7JAi8=;
        h=Date:To:From:Subject:From;
        b=lu5dH8G+WyuZnVRkDZ6jZsbMrmMNhc3GzSAWx/y1XypgpKsLUfknfhlzACdNeQ7Qj
         ff3CGgAFOpF/CMU5hT5yY48d2ig1sxI/wAXWvEZdFQFS2IkD0w2ZIguR9ov6fZQr21
         Svb5x2MDGCzw2PmLE1fTOBxfP6J0uwTG9cvArrSU=
Date:   Wed, 18 Oct 2023 14:35:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tim.c.chen@intel.com, jack@suse.cz, hannes@cmpxchg.org,
        djwong@kernel.org, dchinner@redhat.com, chuck.lever@oracle.com,
        cem@kernel.org, brauner@kernel.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmempercpu_counter-add-_limited_addfbc-limit-amount.patch removed from -mm tree
Message-Id: <20231018213508.43354C433BC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem,percpu_counter: add _limited_add(fbc, limit, amount)
has been removed from the -mm tree.  Its filename was
     shmempercpu_counter-add-_limited_addfbc-limit-amount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem,percpu_counter: add _limited_add(fbc, limit, amount)
Date: Fri, 29 Sep 2023 20:42:45 -0700 (PDT)

Percpu counter's compare and add are separate functions: without locking
around them (which would defeat their purpose), it has been possible to
overflow the intended limit.  Imagine all the other CPUs fallocating tmpfs
huge pages to the limit, in between this CPU's compare and its add.

I have not seen reports of that happening; but tmpfs's recent addition of
dquot_alloc_block_nodirty() in between the compare and the add makes it
even more likely, and I'd be uncomfortable to leave it unfixed.

Introduce percpu_counter_limited_add(fbc, limit, amount) to prevent it.

I believe this implementation is correct, and slightly more efficient than
the combination of compare and add (taking the lock once rather than twice
when nearing full - the last 128MiB of a tmpfs volume on a machine with
128 CPUs and 4KiB pages); but it does beg for a better design - when
nearing full, there is no new batching, but the costly percpu counter sum
across CPUs still has to be done, while locked.

Follow __percpu_counter_sum()'s example, including cpu_dying_mask as well
as cpu_online_mask: but shouldn't __percpu_counter_compare() and
__percpu_counter_limited_add() then be adding a num_dying_cpus() to
num_online_cpus(), when they calculate the maximum which could be held
across CPUs?  But the times when it matters would be vanishingly rare.

Link: https://lkml.kernel.org/r/bb817848-2d19-bcc8-39ca-ea179af0f0b4@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |   23 +++++++++++++
 lib/percpu_counter.c           |   53 +++++++++++++++++++++++++++++++
 mm/shmem.c                     |   10 ++---
 3 files changed, 81 insertions(+), 5 deletions(-)

--- a/include/linux/percpu_counter.h~shmempercpu_counter-add-_limited_addfbc-limit-amount
+++ a/include/linux/percpu_counter.h
@@ -57,6 +57,8 @@ void percpu_counter_add_batch(struct per
 			      s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
 int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch);
+bool __percpu_counter_limited_add(struct percpu_counter *fbc, s64 limit,
+				  s64 amount, s32 batch);
 void percpu_counter_sync(struct percpu_counter *fbc);
 
 static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
@@ -69,6 +71,13 @@ static inline void percpu_counter_add(st
 	percpu_counter_add_batch(fbc, amount, percpu_counter_batch);
 }
 
+static inline bool
+percpu_counter_limited_add(struct percpu_counter *fbc, s64 limit, s64 amount)
+{
+	return __percpu_counter_limited_add(fbc, limit, amount,
+					    percpu_counter_batch);
+}
+
 /*
  * With percpu_counter_add_local() and percpu_counter_sub_local(), counts
  * are accumulated in local per cpu counter and not in fbc->count until
@@ -185,6 +194,20 @@ percpu_counter_add(struct percpu_counter
 	local_irq_restore(flags);
 }
 
+static inline bool
+percpu_counter_limited_add(struct percpu_counter *fbc, s64 limit, s64 amount)
+{
+	unsigned long flags;
+	s64 count;
+
+	local_irq_save(flags);
+	count = fbc->count + amount;
+	if (count <= limit)
+		fbc->count = count;
+	local_irq_restore(flags);
+	return count <= limit;
+}
+
 /* non-SMP percpu_counter_add_local is the same with percpu_counter_add */
 static inline void
 percpu_counter_add_local(struct percpu_counter *fbc, s64 amount)
--- a/lib/percpu_counter.c~shmempercpu_counter-add-_limited_addfbc-limit-amount
+++ a/lib/percpu_counter.c
@@ -278,6 +278,59 @@ int __percpu_counter_compare(struct perc
 }
 EXPORT_SYMBOL(__percpu_counter_compare);
 
+/*
+ * Compare counter, and add amount if the total is within limit.
+ * Return true if amount was added, false if it would exceed limit.
+ */
+bool __percpu_counter_limited_add(struct percpu_counter *fbc,
+				  s64 limit, s64 amount, s32 batch)
+{
+	s64 count;
+	s64 unknown;
+	unsigned long flags;
+	bool good;
+
+	if (amount > limit)
+		return false;
+
+	local_irq_save(flags);
+	unknown = batch * num_online_cpus();
+	count = __this_cpu_read(*fbc->counters);
+
+	/* Skip taking the lock when safe */
+	if (abs(count + amount) <= batch &&
+	    fbc->count + unknown <= limit) {
+		this_cpu_add(*fbc->counters, amount);
+		local_irq_restore(flags);
+		return true;
+	}
+
+	raw_spin_lock(&fbc->lock);
+	count = fbc->count + amount;
+
+	/* Skip percpu_counter_sum() when safe */
+	if (count + unknown > limit) {
+		s32 *pcount;
+		int cpu;
+
+		for_each_cpu_or(cpu, cpu_online_mask, cpu_dying_mask) {
+			pcount = per_cpu_ptr(fbc->counters, cpu);
+			count += *pcount;
+		}
+	}
+
+	good = count <= limit;
+	if (good) {
+		count = __this_cpu_read(*fbc->counters);
+		fbc->count += count + amount;
+		__this_cpu_sub(*fbc->counters, count);
+	}
+
+	raw_spin_unlock(&fbc->lock);
+	local_irq_restore(flags);
+	return good;
+}
+
 static int __init percpu_counter_startup(void)
 {
 	int ret;
--- a/mm/shmem.c~shmempercpu_counter-add-_limited_addfbc-limit-amount
+++ a/mm/shmem.c
@@ -217,15 +217,15 @@ static int shmem_inode_acct_blocks(struc
 
 	might_sleep();	/* when quotas */
 	if (sbinfo->max_blocks) {
-		if (percpu_counter_compare(&sbinfo->used_blocks,
-					   sbinfo->max_blocks - pages) > 0)
+		if (!percpu_counter_limited_add(&sbinfo->used_blocks,
+						sbinfo->max_blocks, pages))
 			goto unacct;
 
 		err = dquot_alloc_block_nodirty(inode, pages);
-		if (err)
+		if (err) {
+			percpu_counter_sub(&sbinfo->used_blocks, pages);
 			goto unacct;
-
-		percpu_counter_add(&sbinfo->used_blocks, pages);
+		}
 	} else {
 		err = dquot_alloc_block_nodirty(inode, pages);
 		if (err)
_

Patches currently in -mm which might be from hughd@google.com are

hugetlbfs-drop-shared-numa-mempolicy-pretence.patch
kernfs-drop-shared-numa-mempolicy-hooks.patch
mempolicy-fix-migrate_pages2-syscall-return-nr_failed.patch
mempolicy-trivia-delete-those-ancient-pr_debugs.patch
mempolicy-trivia-slightly-more-consistent-naming.patch
mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree.patch
mempolicy-mpol_shared_policy_init-without-pseudo-vma.patch
mempolicy-remove-confusing-mpol_mf_lazy-dead-code.patch
mm-add-page_rmappable_folio-wrapper.patch
mempolicy-alloc_pages_mpol-for-numa-policy-without-vma.patch
mempolicy-mmap_lock-is-not-needed-while-migrating-folios.patch
mempolicy-migration-attempt-to-match-interleave-nodes.patch

