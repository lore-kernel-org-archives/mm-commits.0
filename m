Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BCB1C5F39
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777127995; cv=none; b=B87lCl24VajjbRqCR1nGwjLqz1cjbexHl7dVu9er+YlSAZUtEcUy3LdWIpeeAUlwiUIsNxcwhFJf8BEGlywnDiftB/PNCaP+sa7z1YuWBoMeUMr2/mEf16T9kIKNCu53nTErF2aZP9suKP/rEyZrJkKQu1vJuAQSpdh2n7tNyqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777127995; c=relaxed/simple;
	bh=kOHU1ubCHR9vA2AyhAv6m/M1JuLcIULQRxSQQSy7qfY=;
	h=Date:To:From:Subject:Message-Id; b=c1pytkHLOz/bW/fd8KT7jaZp1vk+kqqVXUFm8v5Y24oKAODRHfaK8f2lon0pcy49ydT5OxZccIINdfjsX0CcCZfRRmGfZVFeUydX2K2/z3lJAvv98iLuKPastRYFaC0IF3V+8dU9SmqcfYUHs/GzdikEUVzbziIvymfHlTjcVZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jZByQz9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jZByQz9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0334C2BCB0;
	Sat, 25 Apr 2026 14:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777127995;
	bh=kOHU1ubCHR9vA2AyhAv6m/M1JuLcIULQRxSQQSy7qfY=;
	h=Date:To:From:Subject:From;
	b=jZByQz9/l7hhKWrg3esVDEnsC/y8NWr+lYJjKjsMVgry/MczmkzN0cQrfdqfP0bu1
	 w+RY7jQclgMCdNswTxb+lGbhRhBffF6+vHKDyjT//rx1M3BSmsmNXHZ3CpqJsCUxXl
	 3eEWV9eu3uDdcXSoUAik6VrvcqEZJQRcQ42Ew0FE=
Date: Sat, 25 Apr 2026 07:39:54 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,riel@surriel.com,nphamcs@gmail.com,mhocko@suse.com,kasong@tencent.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,axelrasmussen@google.com,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lruvec-preemptively-free-dead-folios-during-lru_add-drain.patch added to mm-new branch
Message-Id: <20260425143954.E0334C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/lruvec: preemptively free dead folios during lru_add drain
has been added to the -mm mm-new branch.  Its filename is
     mm-lruvec-preemptively-free-dead-folios-during-lru_add-drain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lruvec-preemptively-free-dead-folios-during-lru_add-drain.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Subject: mm/lruvec: preemptively free dead folios during lru_add drain
Date: Fri, 24 Apr 2026 22:34:17 -0700

Of all observable lruvec lock contention in our fleet, we find that ~24%
occurs when dead folios are present in lru_add batches at drain time. 
This is wasteful in the sense that the folio is added to the LRU just to
be immediately removed via folios_put_refs(), incurring two unnecessary
lock acquisitions.

Eliminate this overhead by preemptively cleaning up dead folios before
they make it into the LRU.  Use folio_ref_freeze() to filter folios whose
only remaining refcount is the batch ref.  When dead folios are found,
move them off the add batch and onto a temporary batch to be freed.

PG_active may be set on a batched folio as well as PG_unevictable (via
migration path).  Since filtered folios bypass the normal lru_add()
cleanup, both flags must be cleared before freeing.

During A/B testing on one of our prod instagram workloads (high-frequency
short-lived requests), the patch intercepted almost all dead folios before
they entered the LRU.  Data collected using the mm_lru_insertion
tracepoint shows the effectiveness of the patch:

Per-host LRU add averages at 95% CPU load
(60 hosts each side, 3 x 60s intervals)

            dead folios/min  total folios/min   dead %
unpatched:        1,297,785        19,341,986  6.7097%
patched:                 14        19,039,996  0.0001%

Within this workload, we save ~2.6M lock acquisitions per minute per host
as a result.

System-wide memory stats improved on the patched side also at 95% CPU load:
 - direct reclaim scanning reduced 7%
 - allocation stalls reduced 5.2%
 - compaction stalls reduced 12.3%
 - page frees reduced 4.9%

No regressions were observed in requests served per second or request tail
latency (p99).  Both metrics showed directional improvement at higher CPU
utilization (comparing 85% to 95%).

Note that tests were performed using classic LRU.

Link: https://lore.kernel.org/20260425053417.351146-1-jp.kobryn@linux.dev
Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

--- a/mm/swap.c~mm-lruvec-preemptively-free-dead-folios-during-lru_add-drain
+++ a/mm/swap.c
@@ -160,14 +160,42 @@ static void folio_batch_move_lru(struct
 	int i;
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
+	struct folio_batch free_fbatch;
+	bool is_lru_add = (move_fn == lru_add);
+
+	/*
+	 * If we're adding to the LRU, preemptively filter dead folios. Use
+	 * this dedicated folio batch for temp storage and deferred cleanup.
+	 */
+	if (is_lru_add)
+		folio_batch_init(&free_fbatch);
 
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
 		/* block memcg migration while the folio moves between lru */
-		if (move_fn != lru_add && !folio_test_clear_lru(folio))
+		if (!is_lru_add && !folio_test_clear_lru(folio))
 			continue;
 
+		/*
+		 * Filter dead folios by moving them from the add batch to the temp
+		 * batch for freeing after this loop.
+		 *
+		 * We're bypassing normal cleanup. Clear flags that are not
+		 * applicable to dead folios.
+		 *
+		 * Since the folio may be part of a huge page, unqueue from
+		 * deferred split list to avoid a dangling list entry.
+		 */
+		if (is_lru_add && folio_ref_freeze(folio, 1)) {
+			__folio_clear_active(folio);
+			__folio_clear_unevictable(folio);
+			folio_unqueue_deferred_split(folio);
+			fbatch->folios[i] = NULL;
+			folio_batch_add(&free_fbatch, folio);
+			continue;
+		}
+
 		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
 
@@ -176,6 +204,13 @@ static void folio_batch_move_lru(struct
 
 	if (lruvec)
 		lruvec_unlock_irqrestore(lruvec, flags);
+
+	/* Cleanup filtered dead folios. */
+	if (is_lru_add) {
+		mem_cgroup_uncharge_folios(&free_fbatch);
+		free_unref_folios(&free_fbatch);
+	}
+
 	folios_put(fbatch);
 }
 
@@ -964,6 +999,10 @@ void folios_put_refs(struct folio_batch
 		struct folio *folio = folios->folios[i];
 		unsigned int nr_refs = refs ? refs[i] : 1;
 
+		/* Folio batch entry may have been preemptively removed during drain. */
+		if (!folio)
+			continue;
+
 		if (is_huge_zero_folio(folio))
 			continue;
 
_

Patches currently in -mm which might be from jp.kobryn@linux.dev are

mm-vmpressure-skip-socket-pressure-for-costly-order-reclaim.patch
mm-lruvec-preemptively-free-dead-folios-during-lru_add-drain.patch

