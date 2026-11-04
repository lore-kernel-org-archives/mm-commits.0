Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793777182;
	b=aaoSdjHBhmqIZw7CUNMetCg+xPdnvjUsRNwm9DHECA6MSWalFGAskbsVY1iLKQsqoz+B
	 44BPufZJY7r3eHP8QGMNDj5a80Rinf2oW3+FzATZ9Be7FIAOFhmQy9i1yqcrE1oW/54iO
	 U8qYCSN7AUBH6ynLouvDOVBn14vyb/4LVxFkQxCOYBoN0IXYgN+DOQe4v7V/rDFR+/Dft
	 p47rwdw554pA+LCJCdmQxvxwOMGjIRSDZtDWO5D2jYrKjKRYqZvxllC39cRe/2NK04MCu
	 tSBs2TzWh+wWbyhQSHWgCdRNfa80oHLqJW7jZkYPUXD/yEOwMUHzG2jom5w0QVZbOag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793777182;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=OWvbH1R6pq2bU0RtFwDcupXJ+JOivv4rPu1qw4sFG84=;
	b=t+dfFMcfghDjV19Q0r0vOOjq1TtyZajN5989WdHsAcBBG0zjMb7tkZaYe4jLOVXIaxmh
	 b0LNn8tmwmCHrmBZsWTdSgAi/KUJ8hj5KVNdew1TUx2uCpBD2bVsmn2EmpjlB+UE9iWYE
	 K6YhOdSBRKiXpwv0Ec5d4ocHEuYKeQl8Fiu+J36jGFR4ul5NZZlVQXIqqPucs+DEr+lGm
	 lJR8LnviVAvllJkNguLbC3wLrYhge6f2wITAa/8+bqCMAEKWYRc1KRQCCPrSkNXKUlOhM
	 ZuduaP9u/GMMRz+eG7ezXwUfiIm6AW1T5mYkHGU3UfIczXiOUw/KNTdjRSAADnWIL2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Zopjr2Iy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87B6606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 07:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Zopjr2Iy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821BF1F000C1;
	Wed,  4 Nov 2026 07:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793777181;
	bh=OWvbH1R6pq2bU0RtFwDcupXJ+JOivv4rPu1qw4sFG84=;
	h=Date:To:From:Subject;
	b=Zopjr2IyAKv8WwI45BfDSjxaA2CEmuFpq6SFCyXAdsRN14iPamgwXwzCXKnyJvCN1
	 pRFyqi+HQPc7JErt7BCakfu7YtC8jJ4FgCLDLJ8zn89tDoT4wmHAn9GChOQdz8od0p
	 kIZfaxqNcZf4ixtdHdiOHwVVV0HxiYN0zfWd8RJE=
Date: Tue, 03 Nov 2026 23:26:21 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,yosry@kernel.org,
	vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,
	shikemeng@huaweicloud.com,ryncsn@gmail.com,rppt@kernel.org,nphamcs@gmail.com,
	neil@brown.name,mt4022@columbia.edu,mhocko@suse.com,mason@kernel.org,
	ljs@kernel.org,liam@infradead.org,kasong@tencent.com,josef@toxicpanda.com,
	hch@lst.de,hanchuanhua@oppo.com,david@kernel.org,chrisl@kernel.org,
	chengming.zhou@linux.dev,baoquan.he@linux.dev,baohua@kernel.org,
	hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-keep-the-swap-in-pressure-window-open-across-a-batch.patch added to mm-new branch
Message-Id: <20261104072621.821BF1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/swap: keep the swap-in pressure window open across a batch
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-keep-the-swap-in-pressure-window-open-across-a-batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-keep-the-swap-in-pressure-window-open-across-a-batch.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm/swap: keep the swap-in pressure window open across a batch
Date: Wed, 04 Nov 2026 00:18:17 +0800

For asynchronous block devices, swap reads are batched and submitted later
since commit dda8fb68b590 ("mm/swap: also use struct swap_iocb for block
I/O"), but the caller submits the batch after the pressure window in
swap_read_folio() has closed.  Batching is cheap, the submission is the
part that can block, and that is no longer counted as pressure since then.

Keep the pressure window open across the batch instead: swap_read_folio()
opens it on the first folio, and swap_read_submit() closes it after the
submission, also when the batch ends up with no folio queued.  Each batch
is then billed for its own read.

A single workingset refault marks its whole batch as stalled, which is
fine here: the batch is submitted as a whole, so its submission holds
up that refault too.  Before the batching, a blocking submission was billed
only to the folio that issued it, even when it also delayed the refaults
queued behind it in the same task, so this might be more accurate rather
than less.  Synchronous reads are already one folio per batch after the
previous patch, which keeps their attribution tight.

The same hole has been there for a swap file on a file system that submits
through swap_fs_prepare_rw(), since commit 5169b844b7dd ("mm: submit
multipage reads for SWP_FS_OPS swap-space"), which started batching its
reads and deferring the submission to the caller, so this covers it there
as well.

[kasong@tencent.com: added commit message and slight tweaks]
Link: https://lore.kernel.org/20261104-swap-fixes-v2-4-204be064be5b@tencent.com
Link: https://lore.kernel.org/linux-mm/auOz00OGB_8dgniC@cmpxchg.org/
Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
Fixes: 5169b844b7dd ("mm: submit multipage reads for SWP_FS_OPS swap-space")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Mani Tofigh <mt4022@columbia.edu>
Cc: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Chris Mason <mason@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
---

 include/linux/swap_ops.h |   10 ++++
 mm/page_io.c             |   79 +++++++++++++++++++++++--------------
 2 files changed, 60 insertions(+), 29 deletions(-)

--- a/include/linux/swap_ops.h~mm-swap-keep-the-swap-in-pressure-window-open-across-a-batch
+++ a/include/linux/swap_ops.h
@@ -17,6 +17,16 @@ struct swap_iocb {
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
 	struct swap_info_struct	*sis;
+
+	/*
+	 * Pressure window: opened by swap_read_folio() on the first folio
+	 * of a batch, closed by swap_read_submit(). Mirrors per-task
+	 * state, so the task that opened it must be the one to close it.
+	 */
+	bool			workingset;
+	bool			in_delayacct;
+	bool			in_thrashing;
+	unsigned long		in_memstall;
 };
 
 /*
--- a/mm/page_io.c~mm-swap-keep-the-swap-in-pressure-window-open-across-a-batch
+++ a/mm/page_io.c
@@ -350,13 +350,11 @@ static void swap_add_folio(struct swap_i
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct swap_iocb *sio = ctx->sio;
 
-	if (sio && !swap_can_merge(ctx, folio, rw)) {
-		if (rw == WRITE)
-			swap_write_submit(ctx);
-		else
-			swap_read_submit(ctx);
-		sio = ctx->sio;
-	}
+	/*
+	 * Callers flush a batch this folio can't join before adding it,
+	 * see swap_read_folio() and __swap_writeout().
+	 */
+	VM_WARN_ON_ONCE(sio && !swap_can_merge(ctx, folio, rw));
 
 	if (!sio) {
 		ctx->sis = sis;
@@ -399,6 +397,14 @@ void __swap_writeout(struct swap_io_ctx
 
 	folio_start_writeback(folio);
 	folio_unlock(folio);
+
+	/*
+	 * Flush a batch this folio can't join before adding it, as in
+	 * swap_read_folio(). But the write path opens no pressure window,
+	 * so there is nothing to order this against.
+	 */
+	if (ctx->sio && !swap_can_merge(ctx, folio, WRITE))
+		swap_write_submit(ctx);
 	swap_add_folio(ctx, folio, WRITE);
 }
 
@@ -470,31 +476,44 @@ void swap_read_folio(struct swap_io_ctx
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
-	unsigned long pflags;
-	bool in_thrashing;
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_uptodate(folio), folio);
 
 	/*
+	 * A batch this folio can't join is submitted before the pressure
+	 * window opens, so that each batch is billed for its own read
+	 * rather than for the next folio's lookup and decompression.
+	 */
+	if (ctx->sio && !swap_can_merge(ctx, folio, READ))
+		swap_read_submit(ctx);
+
+	/*
 	 * Count submission time as memory stall and delay. When the device
 	 * is congested, or the submitting cgroup IO-throttled, submission
-	 * can be a significant part of overall IO time.
+	 * can be a significant part of overall IO time. Reads are batched and
+	 * submitted later, so both windows stay open on @ctx, and are closed
+	 * by swap_read_submit() after the submission, also when the batch
+	 * ends up with no folio queued.
 	 */
-	if (workingset) {
-		delayacct_thrashing_start(&in_thrashing);
-		psi_memstall_enter(&pflags);
+	if (!ctx->in_delayacct) {
+		delayacct_swapin_start();
+		ctx->in_delayacct = true;
+	}
+	if (workingset && !ctx->workingset) {
+		delayacct_thrashing_start(&ctx->in_thrashing);
+		psi_memstall_enter(&ctx->in_memstall);
+		ctx->workingset = true;
 	}
-	delayacct_swapin_start();
 
 	if (swap_read_folio_zeromap(folio)) {
 		folio_unlock(folio);
-		goto finish;
+		return;
 	}
 
 	if (zswap_load(folio) != -ENOENT)
-		goto finish;
+		return;
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
@@ -506,13 +525,6 @@ void swap_read_folio(struct swap_io_ctx
 	 */
 	if (synchronous)
 		swap_read_submit(ctx);
-
-finish:
-	if (workingset) {
-		delayacct_thrashing_end(&in_thrashing);
-		psi_memstall_leave(&pflags);
-	}
-	delayacct_swapin_end();
 }
 
 static void swap_write_end(struct swap_iocb *sio, bool failed)
@@ -725,10 +737,19 @@ void swap_write_submit(struct swap_io_ct
 
 void swap_read_submit(struct swap_io_ctx *ctx)
 {
-	if (!ctx->sio)
-		return;
-	count_vm_events(NRSWPIN, 1);
-	ctx->sis->ops->submit_read(ctx);
-	ctx->sio = NULL;
-	ctx->sis = NULL;
+	if (ctx->sio) {
+		count_vm_events(NRSWPIN, 1);
+		ctx->sis->ops->submit_read(ctx);
+		ctx->sio = NULL;
+		ctx->sis = NULL;
+	}
+	if (ctx->workingset) {
+		delayacct_thrashing_end(&ctx->in_thrashing);
+		psi_memstall_leave(&ctx->in_memstall);
+		ctx->workingset = false;
+	}
+	if (ctx->in_delayacct) {
+		delayacct_swapin_end();
+		ctx->in_delayacct = false;
+	}
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-swap-keep-the-swap-in-pressure-window-open-across-a-batch.patch

