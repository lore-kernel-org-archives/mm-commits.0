Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CEC3B95F6
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294504; cv=none; b=X23HrGFZdZSgus3lMwZLIsb/VVlM1sNZyixwsN/VUcc9R+3cTE0O6EMaRQ7E+pRTwlpgfgVEHt3RUKLZsgsLJtpE74FksqBD6cA/wOu3fOyJQLzNjh2AGKscX7k1iuLfOiyOoEKuj5zLtkRkIB40w78+XVnmdvtfQymuJ0AFD1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294504; c=relaxed/simple;
	bh=IOmFKK5npK81qigf3fBLsFHcr3KdujmjMujqDS3l/dM=;
	h=Date:To:From:Subject:Message-Id; b=c8YB75CMjP7YdyCy0At+04OOg8pDIhg13jeUZAfeU4VpsgOloPf40g90rXct4+RnfhBFvGV+X9M0XqQj8ECc5BrsnIRWyH16lvaVodqUhc7ajiJ0crhLKVASjNu8CwQftYKl2VvGvM9l16r6MowrVO38VY+fXxTRysm9pOySZaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oecWbNMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oecWbNMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8834C19425;
	Mon, 27 Apr 2026 12:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294504;
	bh=IOmFKK5npK81qigf3fBLsFHcr3KdujmjMujqDS3l/dM=;
	h=Date:To:From:Subject:From;
	b=oecWbNMHrwhcD/18J7j6GEO8OFidVM6GOhESf3Vz3OtWcBKzcIsU2GgD9pnkeALuN
	 /ns7rUX8oKomFs4quEUlpNEj0UxQHOFUBeuAJME1OgLptPT1MoUQtk3MvU4gYB9MfO
	 piLCMLwQVVi8j20ccfWanhmnIJcKvUV4byhwqzck=
Date: Mon, 27 Apr 2026 05:55:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,miklos@szeredi.hu,jack@suse.cz,hch@infradead.org,hannes@cmpxchg.org,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis.patch removed from -mm tree
Message-Id: <20260427125503.E8834C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: start background writeback based on per-wb threshold for strictlimit BDIs
has been removed from the -mm tree.  Its filename was
     mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm: start background writeback based on per-wb threshold for strictlimit BDIs
Date: Thu, 26 Mar 2026 16:46:29 -0700

The proactive nr_dirty > gdtc->bg_thresh check in balance_dirty_pages()
only checks the global dirty threshold to start background writeback while
the writer is still free-running, but for strictlimit BDIs (eg fuse), the
per-wb dirty count can exceed the per-wb background threshold while the
global threshold is not yet exceeded, so background writeback for this
case never gets proactively started.

Add a per-wb threshold check for strictlimit BDIs so that background
writeback is started when wb_dirty exceeds wb_bg_thresh, which drains
dirty pages before the writer hits the throttle wall, matching the
proactive behavior that the global check provides for non-strictlimit
BDIs.

fio runs on fuse show about a 3-4% improvement in perf for buffered
writes:
fio --name=writeback_test --ioengine=psync --rw=write --bs=128k \
    --size=2G --numjobs=4 --ramp_time=10 --runtime=20 \
    --time_based --group_reporting=1 --direct=0

Link: https://lore.kernel.org/20260326234629.840938-2-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/page-writeback.c~mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis
+++ a/mm/page-writeback.c
@@ -1835,7 +1835,9 @@ static int balance_dirty_pages(struct bd
 			balance_domain_limits(mdtc, strictlimit);
 		}
 
-		if (nr_dirty > gdtc->bg_thresh && !writeback_in_progress(wb))
+		if (!writeback_in_progress(wb) &&
+		    (nr_dirty > gdtc->bg_thresh ||
+		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh)))
 			wb_start_background_writeback(wb);
 
 		/*
@@ -1862,15 +1864,9 @@ free_running:
 		 * Unconditionally start background writeback if it's not
 		 * already in progress. We need to do this because the global
 		 * dirty threshold check above (nr_dirty > gdtc->bg_thresh)
-		 * doesn't account for these cases:
-		 *
-		 * a) strictlimit BDIs: throttling is calculated using per-wb
-		 * thresholds. The per-wb threshold can be exceeded even when
-		 * nr_dirty < gdtc->bg_thresh
-		 *
-		 * b) memcg-based throttling: memcg uses its own dirty count and
-		 * thresholds and can trigger throttling even when global
-		 * nr_dirty < gdtc->bg_thresh
+		 * doesn't account for the memcg-based throttling case. memcg
+		 * uses its own dirty count and thresholds and can trigger
+		 * throttling even when global nr_dirty < gdtc->bg_thresh
 		 *
 		 * Writeback needs to be started else the writer stalls in the
 		 * throttle loop waiting for dirty pages to be written back
_

Patches currently in -mm which might be from joannelkoong@gmail.com are


