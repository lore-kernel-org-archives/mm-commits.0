Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A3324468B;
	Fri, 27 Mar 2026 00:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774572706; cv=none; b=l3/VzDCgZ1gHHUYePTRxPi1DfRf38KVVDhEwr75eyzkEG4WB4VPkg1rol+m04RJj/opGRJe6w/kjWC2pgLYOyWpIvi9PnJ4RP0XrHQA8ZgofsWVbMvrVInzTy2tnE6yDwGE4BSKI7Vai09yR7FGGQItkOc2m5ZRNxAwRUdgAZmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774572706; c=relaxed/simple;
	bh=NaAB+U4FjkCmZsunfUfk7y95LS0w7btp2dL/bA1OujI=;
	h=Date:To:From:Subject:Message-Id; b=bRuRbGl8Pr692WMe3HMJZPgvQK8pDMw4n3CmpO3p60tWd4f0h0PLBnD2rN0oBEppL2RdVWIC/iwzcBijEa6EoxZKDmdYpA7hiR7Qt3dGPS1KJ8E4k7PWHMnP826kmZM9HgIy4it3OlAocfF3pK8Ii0vaOuSM4ajrKE5n4ar69HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IVACX+/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IVACX+/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD3EC116C6;
	Fri, 27 Mar 2026 00:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774572706;
	bh=NaAB+U4FjkCmZsunfUfk7y95LS0w7btp2dL/bA1OujI=;
	h=Date:To:From:Subject:From;
	b=IVACX+/508djJS65EKWgboqrK2Xg4/fjiiAe7hRHXc0PQFRxoEUM11R09Jo2pxvs0
	 AwKwFXvrNIQFmWUzCfv8rsXCtS2n/fEgJWaJWZzfBmfxNTAPr/rwcHkdjqlTCV7ycP
	 bmRR47wt95D/qYzrYcjnDnQVNQ43wZV/tflV02nM=
Date: Thu, 26 Mar 2026 17:51:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,jack@suse.cz,hch@infradead.org,hannes@cmpxchg.org,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reinstate-unconditional-writeback-start-in-balance_dirty_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20260327005145.EFD3EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: reinstate unconditional writeback start in balance_dirty_pages()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-reinstate-unconditional-writeback-start-in-balance_dirty_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reinstate-unconditional-writeback-start-in-balance_dirty_pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm: reinstate unconditional writeback start in balance_dirty_pages()
Date: Thu, 26 Mar 2026 14:51:27 -0700

Commit 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") removed this
unconditional writeback start from balance_dirty_pages():

       if (unlikely(!writeback_in_progress(wb)))
	       wb_start_background_writeback(wb);

This logic needs to be reinstated to prevent performance regressions for
strictlimited BDIs and memcg setups.  The problem occurs because:

a) For strictlimited BDIs, throttling is calculated using per-wb
   thresholds.  The per-wb threshold can be exceeded even when the global
   dirty threshold was not exceeded (nr_dirty < gdtc->bg_thresh)

b) For memcg-based throttling, memcg uses its own dirty count /
   thresholds and can trigger throttling even when the global threshold
   isn't exceeded

Without the unconditional writeback start, IO is throttled as it waits for
dirty pages to be written back but there is no writeback running.  This
leads to severe stalls.  On fuse, buffered write performance dropped from
1400 MiB/s to 2000 KiB/s.

Reinstate the unconditional writeback start so that writeback is
guaranteed to be running whenever IO needs to be throttled.

Link: https://lkml.kernel.org/r/20260326215127.3857682-2-joannelkoong@gmail.com
Fixes: 64dd89ae01f2 ("mm/block/fs: remove laptop_mode")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/mm/page-writeback.c~mm-reinstate-unconditional-writeback-start-in-balance_dirty_pages
+++ a/mm/page-writeback.c
@@ -1858,6 +1858,27 @@ free_running:
 			break;
 		}
 
+		/*
+		 * Unconditionally start background writeback if it's not
+		 * already in progress. We need to do this because the global
+		 * dirty threshold check above (nr_dirty > gdtc->bg_thresh)
+		 * doesn't account for these cases:
+		 *
+		 * a) strictlimit BDIs: throttling is calculated using per-wb
+		 * thresholds. The per-wb threshold can be exceeded even when
+		 * nr_dirty < gdtc->bg_thresh
+		 *
+		 * b) memcg-based throttling: memcg uses its own dirty count and
+		 * thresholds and can trigger throttling even when global
+		 * nr_dirty < gdtc->bg_thresh
+		 *
+		 * Writeback needs to be started else the writer stalls in the
+		 * throttle loop waiting for dirty pages to be written back
+		 * while no writeback is running.
+		 */
+		if (unlikely(!writeback_in_progress(wb)))
+			wb_start_background_writeback(wb);
+
 		mem_cgroup_flush_foreign(wb);
 
 		/*
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-reinstate-unconditional-writeback-start-in-balance_dirty_pages.patch

