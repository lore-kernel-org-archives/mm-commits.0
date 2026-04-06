Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4AA2989B5;
	Mon,  6 Apr 2026 18:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775499261; cv=none; b=Enwbqd1ygJ3bgj9uDblT3BKfRkO/DYr354tOvgKmUW1eK/ebBs8TsBB9lkYEStG/EiOiYFoAE5BUP2seX+74K/ZbaopnLEKoZiuoABJ1B560WMc4V/bzy5DIZYuBskOxgQspRXWRTiv7VkGrjiQRQ2NfYDJkaj8OUh0dKjPC0mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775499261; c=relaxed/simple;
	bh=QH1Wsyj9Jjeq0aTziZRXd2KAMn23pwsIyk95YpuA5fI=;
	h=Date:To:From:Subject:Message-Id; b=t5jPgXmrezwfPTzXffHf4xxKxenbu9rDQFKOLOwvRKduJm7moi2iGvdx3VkmL0agOEZWx3Qd5lH2bL/qqwtzwAhPyi1oRualsljzFT6S6N6cPaBISaVRONOhSt3PJ14GnpbRLeJEuXUkLSr6ItojEjijBTmNTCgftSJKgejCtEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rRo7nWra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rRo7nWra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A5CC4CEF7;
	Mon,  6 Apr 2026 18:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775499260;
	bh=QH1Wsyj9Jjeq0aTziZRXd2KAMn23pwsIyk95YpuA5fI=;
	h=Date:To:From:Subject:From;
	b=rRo7nWraWj4W+qSN7scw4AZ6pXMU74Fu6RTwQfdb+VLBOms9xaBD0sRBv4C+Wqbuc
	 vHMDMR7XGLzEW1MNBRXbnJLb4+x006Q4NMPolmbLEqdnd98F//Nn8Gn6rT/qpCzJH7
	 CBhGBIgyCQx5lvtF9pVreVywn5gQ/8TEsuNP35Kg=
Date: Mon, 06 Apr 2026 11:14:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,jack@suse.cz,hch@lst.de,hannes@cmpxchg.org,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-reinstate-unconditional-writeback-start-in-balance_dirty_pages.patch removed from -mm tree
Message-Id: <20260406181420.A3A5CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: reinstate unconditional writeback start in balance_dirty_pages()
has been removed from the -mm tree.  Its filename was
     mm-reinstate-unconditional-writeback-start-in-balance_dirty_pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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

mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis.patch

