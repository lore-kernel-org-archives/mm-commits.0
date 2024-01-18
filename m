Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091CB1E486
	for <mm-commits@vger.kernel.org>; Thu, 18 Jan 2024 22:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616159; cv=none; b=iWrQ5g6Y92RtN8c6T66OhEaznauqt53u+kMi9pf6sRrw7PCGjNY1qC7Nc3hPxXgmGxYnq1kP213utfYllCJdtJ3JFGhMoZa3rNhhjxQqeBEv94ZPssryTxey13irKIttZhy/exTolfJjBq8vPSf2yCl/2L4hwggRbyO/Sy/JCH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616159; c=relaxed/simple;
	bh=6gKb7bpHAJS/jqMqxG00XDox6utSBdzomu9vsZzPQMU=;
	h=Date:To:From:Subject:Message-Id; b=XlreE9aMHiSzEyxMwNJGgnQPAAGes/EIUNez6NZ5xqOjFVN8mSfdceiixtSjEflvtHHsI9lOgIaBWUCAKIIbOVIoMYWDJbxT4fpxrkiTE6/jSXX5E6JJTesATrMTSGUUyV0n+M8YrmxF6wvAJG067F1vkkjY/zuGSE4941X5gRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AsLZSPFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AsLZSPFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A78C433C7;
	Thu, 18 Jan 2024 22:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705616157;
	bh=6gKb7bpHAJS/jqMqxG00XDox6utSBdzomu9vsZzPQMU=;
	h=Date:To:From:Subject:From;
	b=AsLZSPFN0DPfoLTsSDrPKpidHQA+VIIYo4kw2MwfYSPbnZ2q2dBOYSUq6KHIRa6A4
	 rseQh4t11h+vDQaCla0dFzwWGhvReLZdZ5vwd44KEsPMC6Beqeaa7JHmfOLcuNRHUo
	 rdIGoAEr48Q+hQk5JDlbwZPsoP5BO6nmgsaq3CgE=
Date: Thu, 18 Jan 2024 14:15:54 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + flex_proportions-remove-unused-fprop_local_single.patch added to mm-nonmm-unstable branch
Message-Id: <20240118221557.24A78C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: flex_proportions: remove unused fprop_local_single
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     flex_proportions-remove-unused-fprop_local_single.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/flex_proportions-remove-unused-fprop_local_single.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: flex_proportions: remove unused fprop_local_single
Date: Fri, 19 Jan 2024 04:13:21 +0800

The single variant of flex_proportions is not used.  Simply remove it.

Link: https://lkml.kernel.org/r/20240118201321.759174-1-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>
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

flex_proportions-remove-unused-fprop_local_single.patch

