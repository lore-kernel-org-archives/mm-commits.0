Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D072CCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbjJRVgJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjJRVft (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02A1128
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC18C433BF;
        Wed, 18 Oct 2023 21:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664909;
        bh=2+q7Hj8M7CQ3qu1Ll3O5Ebx1FkcmvwtD9WHO7vpY1ZY=;
        h=Date:To:From:Subject:From;
        b=CGB7TmZEn+Kx/YP81I2yre4/sQipiaQMAgXfMG4vu/pq1ou/+1ecGHZxRwswkoWcZ
         bMzDtQeyKDCBCxZhHiDYl+o5t/51Cuxd7TgnnMZdswDdfs+NUU13SeItgMCrxIEPNP
         h22utEk4EpwfCgb1XlLxVmmgbhA8ADIm5Fgu2074=
Date:   Wed, 18 Oct 2023 14:35:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tim.c.chen@intel.com, jack@suse.cz, hannes@cmpxchg.org,
        djwong@kernel.org, dchinner@redhat.com, chuck.lever@oracle.com,
        cem@kernel.org, brauner@kernel.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu_counter-extend-_limited_add-to-negative-amounts.patch removed from -mm tree
Message-Id: <20231018213509.1BC18C433BF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: percpu_counter: extend _limited_add() to negative amounts
has been removed from the -mm tree.  Its filename was
     percpu_counter-extend-_limited_add-to-negative-amounts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: percpu_counter: extend _limited_add() to negative amounts
Date: Wed, 11 Oct 2023 21:40:09 -0700 (PDT)

Though tmpfs does not need it, percpu_counter_limited_add() can be twice
as useful if it works sensibly with negative amounts (subs) - typically
decrements towards a limit of 0 or nearby: as suggested by Dave Chinner.

And in the course of that reworking, skip the percpu counter sum if it is
already obvious that the limit would be passed: as suggested by Tim Chen.

Extend the comment above __percpu_counter_limited_add(), defining the
behaviour with positive and negative amounts, allowing negative limits,
but not bothering about overflow beyond S64_MAX.

Link: https://lkml.kernel.org/r/8f86083b-c452-95d4-365b-f16a2e4ebcd4@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |   11 +++++-
 lib/percpu_counter.c           |   54 ++++++++++++++++++++++---------
 2 files changed, 49 insertions(+), 16 deletions(-)

--- a/include/linux/percpu_counter.h~percpu_counter-extend-_limited_add-to-negative-amounts
+++ a/include/linux/percpu_counter.h
@@ -198,14 +198,21 @@ static inline bool
 percpu_counter_limited_add(struct percpu_counter *fbc, s64 limit, s64 amount)
 {
 	unsigned long flags;
+	bool good = false;
 	s64 count;
 
+	if (amount == 0)
+		return true;
+
 	local_irq_save(flags);
 	count = fbc->count + amount;
-	if (count <= limit)
+	if ((amount > 0 && count <= limit) ||
+	    (amount < 0 && count >= limit)) {
 		fbc->count = count;
+		good = true;
+	}
 	local_irq_restore(flags);
-	return count <= limit;
+	return good;
 }
 
 /* non-SMP percpu_counter_add_local is the same with percpu_counter_add */
--- a/lib/percpu_counter.c~percpu_counter-extend-_limited_add-to-negative-amounts
+++ a/lib/percpu_counter.c
@@ -279,8 +279,16 @@ int __percpu_counter_compare(struct perc
 EXPORT_SYMBOL(__percpu_counter_compare);
 
 /*
- * Compare counter, and add amount if the total is within limit.
- * Return true if amount was added, false if it would exceed limit.
+ * Compare counter, and add amount if total is: less than or equal to limit if
+ * amount is positive, or greater than or equal to limit if amount is negative.
+ * Return true if amount is added, or false if total would be beyond the limit.
+ *
+ * Negative limit is allowed, but unusual.
+ * When negative amounts (subs) are given to percpu_counter_limited_add(),
+ * the limit would most naturally be 0 - but other limits are also allowed.
+ *
+ * Overflow beyond S64_MAX is not allowed for: counter, limit and amount
+ * are all assumed to be sane (far from S64_MIN and S64_MAX).
  */
 bool __percpu_counter_limited_add(struct percpu_counter *fbc,
 				  s64 limit, s64 amount, s32 batch)
@@ -288,10 +296,10 @@ bool __percpu_counter_limited_add(struct
 	s64 count;
 	s64 unknown;
 	unsigned long flags;
-	bool good;
+	bool good = false;
 
-	if (amount > limit)
-		return false;
+	if (amount == 0)
+		return true;
 
 	local_irq_save(flags);
 	unknown = batch * num_online_cpus();
@@ -299,7 +307,8 @@ bool __percpu_counter_limited_add(struct
 
 	/* Skip taking the lock when safe */
 	if (abs(count + amount) <= batch &&
-	    fbc->count + unknown <= limit) {
+	    ((amount > 0 && fbc->count + unknown <= limit) ||
+	     (amount < 0 && fbc->count - unknown >= limit))) {
 		this_cpu_add(*fbc->counters, amount);
 		local_irq_restore(flags);
 		return true;
@@ -309,7 +318,19 @@ bool __percpu_counter_limited_add(struct
 	count = fbc->count + amount;
 
 	/* Skip percpu_counter_sum() when safe */
-	if (count + unknown > limit) {
+	if (amount > 0) {
+		if (count - unknown > limit)
+			goto out;
+		if (count + unknown <= limit)
+			good = true;
+	} else {
+		if (count + unknown < limit)
+			goto out;
+		if (count - unknown >= limit)
+			good = true;
+	}
+
+	if (!good) {
 		s32 *pcount;
 		int cpu;
 
@@ -317,15 +338,20 @@ bool __percpu_counter_limited_add(struct
 			pcount = per_cpu_ptr(fbc->counters, cpu);
 			count += *pcount;
 		}
+		if (amount > 0) {
+			if (count > limit)
+				goto out;
+		} else {
+			if (count < limit)
+				goto out;
+		}
+		good = true;
 	}
 
-	good = count <= limit;
-	if (good) {
-		count = __this_cpu_read(*fbc->counters);
-		fbc->count += count + amount;
-		__this_cpu_sub(*fbc->counters, count);
-	}
-
+	count = __this_cpu_read(*fbc->counters);
+	fbc->count += count + amount;
+	__this_cpu_sub(*fbc->counters, count);
+out:
 	raw_spin_unlock(&fbc->lock);
 	local_irq_restore(flags);
 	return good;
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

