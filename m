Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795745152;
	b=McHe9DvbEcbXRFLGQAO0L7/M1tFZGX+sLJR6gSzIQkJBSI4wsuu5gJ0ft5j6kBXfQRxP
	 8O/2l33kd4UTODdGGqNOb8zLOFDC9b0AssXYkEH6zTMG2iEI7H9Dpmy6aXBp+EGTUvUoW
	 MDkWX5kZtkEokw4Swe7JoF/zeMr2AObmliUpoahzvr1jSJ7qZW4elXpUpNGO94hr24289
	 X7FJkEHfgot15vAgMFfyL+n4EyzC1XaMJMQsH5wyIknvtqDEbOOnuNR5YRb+cVBUCdg0G
	 Y1/5xLm+j6HB/pVSG+6cPBccWs5bnh8jJn+WNYjnY6tbU+95wm45fVD+JjFh+B9SZKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795745152;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=fqMgBPD9H3CrHeUrj4ntaejjGpq00GCCI2hRemfrNA4=;
	b=ZvMtC4OZy1R8KPQDKahWFLN+aiLNgovpLCfcTCl/2SL7m3VasiF9KVgKfJpAGfqV12eA
	 5eyFxbK49xvSXmOO9dhemLHjIFyco86kzyIuO5X+mPG0O8x/MB/t9TvuLghFTf15yr//v
	 cGdpwQ65zkeWgT12h/OX/xX5vm8cM9v/vMgz998Peu+jB66crZ2EPIIWCX4pVgl82oXnc
	 3lDiS7DWp6I9OMPjGPM0x/CpBwmI31KdTtPRuAyuo+kSw4zXvRl2l95lLmFA9hMrrVdSx
	 BGG2rHzSo0vh7kWWLePRFU6MbKzJ/WlGlX5t3ikdyGlpznDSNw27fsWbd5mGW26uK5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=k+dgGTTd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87B7606A332
	for <mm-commits@vger.kernel.org>; Fri, 27 Nov 2026 02:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=k+dgGTTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2921F00897;
	Fri, 27 Nov 2026 02:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795745151;
	bh=fqMgBPD9H3CrHeUrj4ntaejjGpq00GCCI2hRemfrNA4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=k+dgGTTduN2mKLSLQJjK99B1YO6TYIvJu1Qgt5FgQTGzko8Aka4kYtp2mJCv4/rve
	 DninN5cRXpLBpjPm7wnkrYQIBT3T05M3ob/iZJ0eaweb6sOPrlNtEa9wQHT5ICnoje
	 lPKNuAmx9oxc+hz9yYicaLiNwPJjWsAMiBzxlawA=
Date: Thu, 26 Nov 2026 18:05:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,
	tom.leiming@gmail.com,tj@kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,ljs@kernel.org,jack@suse.cz,hch@lst.de,hannes@cmpxchg.org,
	gthelen@google.com,greg@kroah.com,david@kernel.org,brauner@kernel.org,
	axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>
References: <20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>
Subject: + mm-vmscan-scope-freeze-writeback-skip-to-the-reclaim-target.patch added to mm-new branch
Message-Id: <20261127020551.7A2921F00897@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vmscan: scope freeze writeback skip to the reclaim target
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-scope-freeze-writeback-skip-to-the-reclaim-target.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-scope-freeze-writeback-skip-to-the-reclaim-target.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmscan: scope freeze writeback skip to the reclaim target
Date: Tue, 17 Nov 2026 14:04:43 -0800

The freeze workaround sets memcg_wb_wait_skip globally when a memcg's
writeback wait times out.  While any superblock freeze is pending, this
makes reclaimers in unrelated memcgs bypass their writeback waits and can
drive an otherwise recoverable cgroup to OOM.

Store the flag in the reclaim target memcg instead.  Use
sc->target_mem_cgroup, not the folio's memcg: reclaim against a parent
limit scans descendants.  This also keeps the skip across successive
try_to_free_mem_cgroup_pages() calls in try_charge_memcg(), each of which
creates a new scan_control.  Reclaim against a different target must first
time out on its own writeback.

Reclaimers sharing the target can still OOM early during a freeze.

Reclaimers of the same target can run concurrently, without a lock
protecting this flag.  Keep READ_ONCE() and WRITE_ONCE() for its lockless
loads and stores.  The flag does not publish any other data.  As with the
global flag, a clear racing with a new timeout may cost another 15-second
wait; the timeout path can set the flag again.

Link: https://lore.kernel.org/20261126180228.9b672a945d480e3d3f301985@linux-foundation.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner (Amutable) <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>

 include/linux/memcontrol.h |    2 +
 mm/vmscan.c                |   52 ++++++++++++++++++++---------------
 2 files changed, 33 insertions(+), 21 deletions(-)

--- a/include/linux/memcontrol.h~mm-vmscan-scope-freeze-writeback-skip-to-the-reclaim-target
+++ a/include/linux/memcontrol.h
@@ -248,6 +248,8 @@ struct mem_cgroup {
 	struct list_head memory_peaks;
 	struct list_head swap_peaks;
 	spinlock_t	 peaks_lock;
+	/* Legacy writeback wait timed out during a filesystem freeze. */
+	bool wb_wait_skip;
 
 	/* memory.events and memory.events.local */
 	struct cgroup_file events_file;
--- a/mm/vmscan.c~mm-vmscan-scope-freeze-writeback-skip-to-the-reclaim-target
+++ a/mm/vmscan.c
@@ -1171,39 +1171,49 @@ static bool may_enter_fs(struct folio *f
  *
  * Reclaim can't tell which filesystem a writeback depends on. As a crude
  * workaround, memcg_wait_writeback() times out and, if any filesystem is being
- * frozen at that point, sets memcg_wb_wait_skip. While it is set, legacy memcg
- * reclaim neither waits for nor throttles on writeback, so that the task a
- * freeze may be waiting for isn't held up in reclaim and can drop its freeze
- * protection. This can cause premature memcg OOM kills.
+ * frozen at that point, sets a skip flag on the reclaim target memcg. While
+ * it is set, reclaim against that target neither waits for nor throttles on
+ * writeback, so that the task a freeze may be waiting for isn't held up in
+ * reclaim and can drop its freeze protection. This can cause premature memcg
+ * OOM kills in that reclaim target.
  */
-static bool memcg_wb_wait_skip;
-
-/*
- * Test memcg_wb_wait_skip. It takes effect only while a filesystem is being
- * frozen and is cleared here once none is. A freeze that starts before it is
- * cleared inherits the skip.
- */
-static bool memcg_skip_wb_wait(void)
+#ifdef CONFIG_MEMCG
+/* Retain the skip across separate reclaim attempts against the same limit. */
+static bool memcg_skip_wb_wait(struct scan_control *sc)
 {
-	if (!READ_ONCE(memcg_wb_wait_skip))
+	struct mem_cgroup *memcg = sc->target_mem_cgroup;
+
+	if (!memcg || !READ_ONCE(memcg->wb_wait_skip))
 		return false;
 	if (atomic_read(&sb_nr_freezing))
 		return true;
-	WRITE_ONCE(memcg_wb_wait_skip, false);
+	WRITE_ONCE(memcg->wb_wait_skip, false);
 	return false;
 }
 
-/* wait for writeback of @folio, see memcg_wb_wait_skip for the timeout */
-static void memcg_wait_writeback(struct folio *folio)
+/* Wait for writeback, unless a freeze stalls this reclaim target. */
+static void memcg_wait_writeback(struct folio *folio, struct scan_control *sc)
 {
 	while (!folio_wait_bit_timeout(folio, PG_writeback, 15 * HZ)) {
 		if (atomic_read(&sb_nr_freezing)) {
-			WRITE_ONCE(memcg_wb_wait_skip, true);
-			pr_warn("memcg1 writeback wait timed out during fs freeze, skipping waits, may OOM early\n");
+			WRITE_ONCE(sc->target_mem_cgroup->wb_wait_skip, true);
+			pr_warn("memcg writeback wait timed out during fs freeze; "
+				"skipping waits for reclaim target, may OOM early\n");
 			return;
 		}
 	}
 }
+#else
+static bool memcg_skip_wb_wait(struct scan_control *sc)
+{
+	return false;
+}
+
+static void memcg_wait_writeback(struct folio *folio, struct scan_control *sc)
+{
+	folio_wait_writeback(folio);
+}
+#endif
 
 /*
  * shrink_folio_list() returns the number of reclaimed pages
@@ -1351,7 +1361,7 @@ retry:
 
 			/* Case 2 above */
 			} else if (writeback_throttling_sane(sc) ||
-			    memcg_skip_wb_wait() ||
+			    memcg_skip_wb_wait(sc) ||
 			    !folio_test_reclaim(folio) ||
 			    !may_enter_fs(folio, sc->gfp_mask) ||
 			    (mapping &&
@@ -1377,7 +1387,7 @@ retry:
 			/* Case 3 above */
 			} else {
 				folio_unlock(folio);
-				memcg_wait_writeback(folio);
+				memcg_wait_writeback(folio, sc);
 				/* then go back and try same folio again */
 				list_add_tail(&folio->lru, folio_list);
 				continue;
@@ -2138,7 +2148,7 @@ static void handle_reclaim_writeback(uns
 		 * enough for cgroupv1 writeback throttling to work
 		 * on a large system.
 		 */
-		if (!writeback_throttling_sane(sc) && !memcg_skip_wb_wait())
+		if (!writeback_throttling_sane(sc) && !memcg_skip_wb_wait(sc))
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vma-drop-mm-asynchronously-in-vma_start_read-fix.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2.patch
kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
afs-do-not-put-error-pointer-after-address-lookup-failure.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-0.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-1.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-3.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-4.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-5.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-6.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7.patch
mm-vmscan-scope-freeze-writeback-skip-to-the-reclaim-target.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch
proc-serialize-task-owner-updates.patch
proc-dont-lock-task-inodes-whose-owner-has-not-changed.patch
scripts-bloat-o-meter-describe-output-fields-in-help-text-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

