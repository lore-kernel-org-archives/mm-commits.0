Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE72137935
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645183; cv=none; b=BLsAACHxNTGHfZyhcvT+w8tVktXqHJNhBI5ZnRFEtLwO5f+MKvNwab9Bdvbxv7Nc7rJEXGkAtfRUYcS4nAd3VtK61LzytJkQ3h6lxzaE/+/QltxxIysHFGYBzuN/mIcwCwsI4fxzuwUedlBmryVWzGIuGRAx7Gsh9vgjap2OdQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645183; c=relaxed/simple;
	bh=WUdc61l97vPtLomerXqJ8oYXBaLUREJaYDtMubv3bG4=;
	h=Date:To:From:Subject:Message-Id; b=LEofuGfHdPKlGfJEin9sujW8l/l8xr6ARa1i4iqYTHKGdGWWydOwLT21Br95OEynLBq/lez74Bbtj6+hyC5o643so2JfFIb3gYVSMCFEYWMbvYYTiQeVlLwE5PysjggtU2mz0MFtCQlHXpXul94canh3AddlOdD4CQ+fO5LOzKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0nsIaTGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0nsIaTGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF50C433F1;
	Thu, 22 Feb 2024 23:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645182;
	bh=WUdc61l97vPtLomerXqJ8oYXBaLUREJaYDtMubv3bG4=;
	h=Date:To:From:Subject:From;
	b=0nsIaTGbUybmvTIBARrPyMo5cjDM1gx2wESc33jy6HlOoW2+vviIqYtsS0E01RheD
	 /+KZjom0CQkFfib9m/R40s51uqxgoIBXvmncm3Qyb2gUqmHIAgIrp+9bpk8etveo81
	 qXA1Y4WnfKeVlzd8gr5t9hY5NZv2abe0q7O81HeA=
Date: Thu, 22 Feb 2024 15:39:42 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] flex_proportions-remove-unused-fprop_local_single.patch removed from -mm tree
Message-Id: <20240222233942.CAF50C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: flex_proportions: remove unused fprop_local_single
has been removed from the -mm tree.  Its filename was
     flex_proportions-remove-unused-fprop_local_single.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: flex_proportions: remove unused fprop_local_single
Date: Fri, 19 Jan 2024 04:13:21 +0800

The single variant of flex_proportions is not used.  Simply remove it.

Link: https://lkml.kernel.org/r/20240118201321.759174-1-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/flex_proportions.h |   32 ------------
 lib/flex_proportions.c           |   77 -----------------------------
 2 files changed, 109 deletions(-)

--- a/include/linux/flex_proportions.h~flex_proportions-remove-unused-fprop_local_single
+++ a/include/linux/flex_proportions.h
@@ -39,38 +39,6 @@ void fprop_global_destroy(struct fprop_g
 bool fprop_new_period(struct fprop_global *p, int periods);
 
 /*
- *  ---- SINGLE ----
- */
-struct fprop_local_single {
-	/* the local events counter */
-	unsigned long events;
-	/* Period in which we last updated events */
-	unsigned int period;
-	raw_spinlock_t lock;	/* Protect period and numerator */
-};
-
-#define INIT_FPROP_LOCAL_SINGLE(name)			\
-{	.lock = __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
-}
-
-int fprop_local_init_single(struct fprop_local_single *pl);
-void fprop_local_destroy_single(struct fprop_local_single *pl);
-void __fprop_inc_single(struct fprop_global *p, struct fprop_local_single *pl);
-void fprop_fraction_single(struct fprop_global *p,
-	struct fprop_local_single *pl, unsigned long *numerator,
-	unsigned long *denominator);
-
-static inline
-void fprop_inc_single(struct fprop_global *p, struct fprop_local_single *pl)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__fprop_inc_single(p, pl);
-	local_irq_restore(flags);
-}
-
-/*
  * ---- PERCPU ----
  */
 struct fprop_local_percpu {
--- a/lib/flex_proportions.c~flex_proportions-remove-unused-fprop_local_single
+++ a/lib/flex_proportions.c
@@ -84,83 +84,6 @@ bool fprop_new_period(struct fprop_globa
 }
 
 /*
- * ---- SINGLE ----
- */
-
-int fprop_local_init_single(struct fprop_local_single *pl)
-{
-	pl->events = 0;
-	pl->period = 0;
-	raw_spin_lock_init(&pl->lock);
-	return 0;
-}
-
-void fprop_local_destroy_single(struct fprop_local_single *pl)
-{
-}
-
-static void fprop_reflect_period_single(struct fprop_global *p,
-					struct fprop_local_single *pl)
-{
-	unsigned int period = p->period;
-	unsigned long flags;
-
-	/* Fast path - period didn't change */
-	if (pl->period == period)
-		return;
-	raw_spin_lock_irqsave(&pl->lock, flags);
-	/* Someone updated pl->period while we were spinning? */
-	if (pl->period >= period) {
-		raw_spin_unlock_irqrestore(&pl->lock, flags);
-		return;
-	}
-	/* Aging zeroed our fraction? */
-	if (period - pl->period < BITS_PER_LONG)
-		pl->events >>= period - pl->period;
-	else
-		pl->events = 0;
-	pl->period = period;
-	raw_spin_unlock_irqrestore(&pl->lock, flags);
-}
-
-/* Event of type pl happened */
-void __fprop_inc_single(struct fprop_global *p, struct fprop_local_single *pl)
-{
-	fprop_reflect_period_single(p, pl);
-	pl->events++;
-	percpu_counter_add(&p->events, 1);
-}
-
-/* Return fraction of events of type pl */
-void fprop_fraction_single(struct fprop_global *p,
-			   struct fprop_local_single *pl,
-			   unsigned long *numerator, unsigned long *denominator)
-{
-	unsigned int seq;
-	s64 num, den;
-
-	do {
-		seq = read_seqcount_begin(&p->sequence);
-		fprop_reflect_period_single(p, pl);
-		num = pl->events;
-		den = percpu_counter_read_positive(&p->events);
-	} while (read_seqcount_retry(&p->sequence, seq));
-
-	/*
-	 * Make fraction <= 1 and denominator > 0 even in presence of percpu
-	 * counter errors
-	 */
-	if (den <= num) {
-		if (num)
-			den = num;
-		else
-			den = 1;
-	}
-	*denominator = den;
-	*numerator = num;
-}
-
-/*
  * ---- PERCPU ----
  */
 #define PROP_BATCH (8*(1+ilog2(nr_cpu_ids)))
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


