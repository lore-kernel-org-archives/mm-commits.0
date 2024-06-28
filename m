Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBC917C2;
	Fri, 28 Jun 2024 00:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719533204; cv=none; b=nQ6iCKxtluAM5vdSEw3HBsyTwy32zW2iuA2PUZUTA/nSQpw5ur2BoOgSAqibU9H0CylTBL+m2iOHQv6sAq8aCwiuGPRJtDs5tS9hpJAD5fr9P7sUmabJB4u6qqV+ZlXiwazSfPmIWTxwWI4T3O6QSp077dGS3T4ziiYSN9fB2JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719533204; c=relaxed/simple;
	bh=8lMxHlX7j0vwxWQansSFcrurtOB5MHEQRcTLeYRg7Zg=;
	h=Date:To:From:Subject:Message-Id; b=Fma9Nv8uJ2z5k5ECkvmlNMq80WQe9lDw6MatXr32B3iSTagv5Iq4rNiiFN1u56xTP8TT4l0UfEJYDVhNTI8KST1Xb9wTVlUqOK0HZY9rYvJciN60s7BiYymKPkLepaJChVLpLENg0o33Ud+0cYabtemYlYWYmWssHuuyXLNn8Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L5MaLGSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L5MaLGSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCF8C2BBFC;
	Fri, 28 Jun 2024 00:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719533204;
	bh=8lMxHlX7j0vwxWQansSFcrurtOB5MHEQRcTLeYRg7Zg=;
	h=Date:To:From:Subject:From;
	b=L5MaLGSQEgVCOihxDpqpgmOlTagkoDVWuoCobjBPq+BHrtW5DPUJ9r7kczTtjA+MN
	 IHgTKgte5UHGjbbs2UWB2kmKTPP09QvzBSOi8TWrXnGG/dnZcN7vJPHgMqsrI5gn6t
	 FwQjJQyS4RY36XjDrp/yknl90cWoHLdjI2waOTeg=
Date: Thu, 27 Jun 2024 17:06:43 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,stable@vger.kernel.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-avoid-overflows-in-dirty-throttling-logic.patch removed from -mm tree
Message-Id: <20240628000644.5DCF8C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: avoid overflows in dirty throttling logic
has been removed from the -mm tree.  Its filename was
     mm-avoid-overflows-in-dirty-throttling-logic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: avoid overflows in dirty throttling logic
Date: Fri, 21 Jun 2024 16:42:38 +0200

The dirty throttling logic is interspersed with assumptions that dirty
limits in PAGE_SIZE units fit into 32-bit (so that various multiplications
fit into 64-bits).  If limits end up being larger, we will hit overflows,
possible divisions by 0 etc.  Fix these problems by never allowing so
large dirty limits as they have dubious practical value anyway.  For
dirty_bytes / dirty_background_bytes interfaces we can just refuse to set
so large limits.  For dirty_ratio / dirty_background_ratio it isn't so
simple as the dirty limit is computed from the amount of available memory
which can change due to memory hotplug etc.  So when converting dirty
limits from ratios to numbers of pages, we just don't allow the result to
exceed UINT_MAX.

This is root-only triggerable problem which occurs when the operator
sets dirty limits to >16 TB.

Link: https://lkml.kernel.org/r/20240621144246.11148-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-By: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

--- a/mm/page-writeback.c~mm-avoid-overflows-in-dirty-throttling-logic
+++ a/mm/page-writeback.c
@@ -415,13 +415,20 @@ static void domain_dirty_limits(struct d
 	else
 		bg_thresh = (bg_ratio * available_memory) / PAGE_SIZE;
 
-	if (bg_thresh >= thresh)
-		bg_thresh = thresh / 2;
 	tsk = current;
 	if (rt_task(tsk)) {
 		bg_thresh += bg_thresh / 4 + global_wb_domain.dirty_limit / 32;
 		thresh += thresh / 4 + global_wb_domain.dirty_limit / 32;
 	}
+	/*
+	 * Dirty throttling logic assumes the limits in page units fit into
+	 * 32-bits. This gives 16TB dirty limits max which is hopefully enough.
+	 */
+	if (thresh > UINT_MAX)
+		thresh = UINT_MAX;
+	/* This makes sure bg_thresh is within 32-bits as well */
+	if (bg_thresh >= thresh)
+		bg_thresh = thresh / 2;
 	dtc->thresh = thresh;
 	dtc->bg_thresh = bg_thresh;
 
@@ -471,7 +478,11 @@ static unsigned long node_dirty_limit(st
 	if (rt_task(tsk))
 		dirty += dirty / 4;
 
-	return dirty;
+	/*
+	 * Dirty throttling logic assumes the limits in page units fit into
+	 * 32-bits. This gives 16TB dirty limits max which is hopefully enough.
+	 */
+	return min_t(unsigned long, dirty, UINT_MAX);
 }
 
 /**
@@ -508,10 +519,17 @@ static int dirty_background_bytes_handle
 		void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
+	unsigned long old_bytes = dirty_background_bytes;
 
 	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
-	if (ret == 0 && write)
+	if (ret == 0 && write) {
+		if (DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE) >
+								UINT_MAX) {
+			dirty_background_bytes = old_bytes;
+			return -ERANGE;
+		}
 		dirty_background_ratio = 0;
+	}
 	return ret;
 }
 
@@ -537,6 +555,10 @@ static int dirty_bytes_handler(struct ct
 
 	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 	if (ret == 0 && write && vm_dirty_bytes != old_bytes) {
+		if (DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE) > UINT_MAX) {
+			vm_dirty_bytes = old_bytes;
+			return -ERANGE;
+		}
 		writeback_set_ratelimit();
 		vm_dirty_ratio = 0;
 	}
_

Patches currently in -mm which might be from jack@suse.cz are

readahead-make-sure-sync-readahead-reads-needed-page.patch
filemap-fix-page_cache_next_miss-when-no-hole-found.patch
readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch
readahead-drop-pointless-index-from-force_page_cache_ra.patch
readahead-drop-index-argument-of-page_cache_async_readahead.patch
readahead-drop-dead-code-in-page_cache_ra_order.patch
readahead-drop-dead-code-in-ondemand_readahead.patch
readahead-disentangle-async-and-sync-readahead.patch
readahead-fold-try_context_readahead-into-its-single-caller.patch
readahead-simplify-gotos-in-page_cache_sync_ra.patch

