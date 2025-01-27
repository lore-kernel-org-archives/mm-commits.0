Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9CB198E6F
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738011509; cv=none; b=EmGyk/sdTnyfpeL6HHU13QkvmQAOEiPNxXyMc2lzu5ff2pWd4qvMKv8hrmcsaQZ8f6fpoQ+mSjYrguNNzrHEJX3S8sCLUF49jqcKX4Kqkat+OvtZmR1JrYkQF7UE4ZwCBFcxCTrUmRemU/Fu8sW9nmXX6fyXbpkJO7Brb8+bh8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738011509; c=relaxed/simple;
	bh=lHCKGUo41rZePeadyi0b44Qiey0WFdeze1UUnqiZQgE=;
	h=Date:To:From:Subject:Message-Id; b=uUo//DWOGLyGpr2fl6fE2tH+7MydNiRfYIuOVIeOqmxTiTZL15wSHqSHa9lOHyzJZhPfsf9bqxOo2OOJcPGDkQ3lvhKQ5KnP39+PhYwaxyD8I5bHVVu3LmuNaCkyudVv3qtB6UGZ5Ak5lWkxo5iTUaiM3E4BFuoRUP8VAUH4T/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HRoYbF3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HRoYbF3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7727C4CED2;
	Mon, 27 Jan 2025 20:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738011509;
	bh=lHCKGUo41rZePeadyi0b44Qiey0WFdeze1UUnqiZQgE=;
	h=Date:To:From:Subject:From;
	b=HRoYbF3tbnw5Bnmx5a7vu5bZwUawt/+xKhyoNmy1Fe7yngZggYl8JG/ZcCG8OHBXk
	 c/uL+1N5cDe3jAxVl4KvFfno264HudVXHf019xduEpBDxANF8G42WBpRFU91SGb0J6
	 BoYsjMwsP7COchBovKbSKBsWzVgDlmi3K6HVWVEI=
Date: Mon, 27 Jan 2025 12:58:28 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-unlock-slot-during-recompression.patch added to mm-unstable branch
Message-Id: <20250127205828.E7727C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: unlock slot during recompression
has been added to the -mm mm-unstable branch.  Its filename is
     zram-unlock-slot-during-recompression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-unlock-slot-during-recompression.patch

This patch will later appear in the mm-unstable branch at
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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: unlock slot during recompression
Date: Mon, 27 Jan 2025 16:29:20 +0900

Recompression, like writeback, makes a local copy of slot data (we need to
decompress it anyway) before post-processing so we can unlock slot-entry
once we have that local copy.

Unlock the entry write-lock before recompression loop (secondary
algorithms can be tried out one by one, in order of priority) and
re-acquire it right after the loop.

There is one more potentially costly operation recompress_slot() does -
new zs_handle allocation, which can schedule().  Release the slot-entry
write-lock before zsmalloc allocation and grab it again after the
allocation.

In both cases, once the slot-lock is re-acquired we examine slot's
ZRAM_PP_SLOT flag to make sure that the slot has not been modified by a
concurrent operation.

Link: https://lkml.kernel.org/r/20250127072932.1289973-10-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   53 ++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 15 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-unlock-slot-during-recompression
+++ a/drivers/block/zram/zram_drv.c
@@ -1908,6 +1908,14 @@ static int recompress_slot(struct zram *
 	zram_clear_flag(zram, index, ZRAM_IDLE);
 
 	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
+
+	/*
+	 * Set prio to one past current slot's compression prio, so that
+	 * we automatically skip lower priority algorithms.
+	 */
+	prio = zram_get_priority(zram, index) + 1;
+	/* Slot data copied out - unlock its bucket */
+	zram_slot_write_unlock(zram, index);
 	/*
 	 * Iterate the secondary comp algorithms list (in order of priority)
 	 * and try to recompress the page.
@@ -1916,13 +1924,6 @@ static int recompress_slot(struct zram *
 		if (!zram->comps[prio])
 			continue;
 
-		/*
-		 * Skip if the object is already re-compressed with a higher
-		 * priority algorithm (or same algorithm).
-		 */
-		if (prio <= zram_get_priority(zram, index))
-			continue;
-
 		num_recomps++;
 		zstrm = zcomp_stream_get(zram->comps[prio]);
 		src = kmap_local_page(page);
@@ -1930,10 +1931,8 @@ static int recompress_slot(struct zram *
 				     src, &comp_len_new);
 		kunmap_local(src);
 
-		if (ret) {
-			zcomp_stream_put(zram->comps[prio], zstrm);
-			return ret;
-		}
+		if (ret)
+			break;
 
 		class_index_new = zs_lookup_class_index(zram->mem_pool,
 							comp_len_new);
@@ -1949,6 +1948,19 @@ static int recompress_slot(struct zram *
 		break;
 	}
 
+	zram_slot_write_lock(zram, index);
+	/* Compression error */
+	if (ret) {
+		zcomp_stream_put(zram->comps[prio], zstrm);
+		return ret;
+	}
+
+	/* Slot has been modified concurrently */
+	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
+		zcomp_stream_put(zram->comps[prio], zstrm);
+		return 0;
+	}
+
 	/*
 	 * We did not try to recompress, e.g. when we have only one
 	 * secondary algorithm and the page is already recompressed
@@ -1986,17 +1998,28 @@ static int recompress_slot(struct zram *
 	if (threshold && comp_len_new >= threshold)
 		return 0;
 
-	/*
-	 * If we cannot alloc memory for recompressed object then we bail out
-	 * and simply keep the old (existing) object in zsmalloc.
-	 */
+	/* zsmalloc handle allocation can schedule, unlock slot's bucket */
+	zram_slot_write_unlock(zram, index);
 	handle_new = zs_malloc(zram->mem_pool, comp_len_new,
 			       GFP_NOIO | __GFP_HIGHMEM | __GFP_MOVABLE);
+	zram_slot_write_lock(zram, index);
+
+	/*
+	 * If we couldn't allocate memory for recompressed object then bail
+	 * out and simply keep the old (existing) object in mempool.
+	 */
 	if (IS_ERR_VALUE(handle_new)) {
 		zcomp_stream_put(zram->comps[prio], zstrm);
 		return PTR_ERR((void *)handle_new);
 	}
 
+	/* Slot has been modified concurrently */
+	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
+		zcomp_stream_put(zram->comps[prio], zstrm);
+		zs_free(zram->mem_pool, handle_new);
+		return 0;
+	}
+
 	dst = zs_map_object(zram->mem_pool, handle_new, ZS_MM_WO);
 	memcpy(dst, zstrm->buffer, comp_len_new);
 	zcomp_stream_put(zram->comps[prio], zstrm);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-switch-to-non-atomic-entry-locking.patch
zram-do-not-use-per-cpu-compression-streams.patch
zram-remove-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-two-staged-handle-allocation.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-permit-reclaim-in-recompression-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-unlock-slot-during-recompression.patch

