Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196D225E822
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 23:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755040986; cv=none; b=cIFhPaBxZlP7GvJO7k9zaVCh9+gVU91DlYkR2D43HhOxGmh807iKLl/w1zL72ePNhxaQCbSgU/GI57mKd8QWVnZ7i+qXIxf/EdSEQlb3ZLI3VBTktBmEtBTTGpOV86O1wJW/G727TbxjtE1P4XKhp8bBdinlKtPYXSsdBbsdNRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755040986; c=relaxed/simple;
	bh=qBY4gTauXdeP7k8lFvem3+EUBlaiScv2TU3beGaypNg=;
	h=Date:To:From:Subject:Message-Id; b=RmMBKAiwvxQkz9qeqbf1Ua+UWgzX4DRgacEAQEQuc3Vy2kHY2qVsKY3nudu9K2TdgIoYE5/IE66R8t2iUm+jHG7t2GXTUyTMEfK/dyoXbIqo6E3/mmhAe7e7VKL+th1X5agPEFT6zwxg8Ba2j6tl/rxCVuBSsfcOxGSvs0udusU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x8I7P9rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x8I7P9rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C55C4CEF0;
	Tue, 12 Aug 2025 23:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755040984;
	bh=qBY4gTauXdeP7k8lFvem3+EUBlaiScv2TU3beGaypNg=;
	h=Date:To:From:Subject:From;
	b=x8I7P9rlnnq0SdtV3VxiU2G8ZfjPSQFZLHQhhKuJYncNakfPSGTvCSuv9QrQTpDQY
	 0rE2gBKq09jQ8H1xfDa5FP1keg32pP4wIbbfgChWvCvOXTBQXPE9/RKZtpuK8FaQFT
	 6CTkKGVEbWIOIWja1PF1KtuH/t8mkY6wVEn5dpL8=
Date: Tue, 12 Aug 2025 16:23:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,rientjes@google.com,harry.yoo@oracle.com,cl@gentwo.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mempool-rename-struct-mempool_s-to-struct-mempool.patch added to mm-new branch
Message-Id: <20250812232304.93C55C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mempool: rename struct mempool_s to struct mempool
has been added to the -mm mm-new branch.  Its filename is
     mempool-rename-struct-mempool_s-to-struct-mempool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempool-rename-struct-mempool_s-to-struct-mempool.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Christoph Hellwig <hch@lst.de>
Subject: mempool: rename struct mempool_s to struct mempool
Date: Tue, 12 Aug 2025 10:30:08 +0200

Drop the pointless _s prefix and align to the usual struct naming to
prepare for actually using the struct instead of the typedef so that
random headers don't need to include mempool.h for just having a pointer
to the mempool.

Link: https://lkml.kernel.org/r/20250812083105.371295-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h  |    2 +-
 include/linux/mempool.h |    2 +-
 include/linux/netfs.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/blkdev.h~mempool-rename-struct-mempool_s-to-struct-mempool
+++ a/include/linux/blkdev.h
@@ -199,7 +199,7 @@ struct gendisk {
 	unsigned int		zone_wplugs_hash_bits;
 	atomic_t		nr_zone_wplugs;
 	spinlock_t		zone_wplugs_lock;
-	struct mempool_s	*zone_wplugs_pool;
+	struct mempool		*zone_wplugs_pool;
 	struct hlist_head	*zone_wplugs_hash;
 	struct workqueue_struct *zone_wplugs_wq;
 #endif /* CONFIG_BLK_DEV_ZONED */
--- a/include/linux/mempool.h~mempool-rename-struct-mempool_s-to-struct-mempool
+++ a/include/linux/mempool.h
@@ -15,7 +15,7 @@ struct kmem_cache;
 typedef void * (mempool_alloc_t)(gfp_t gfp_mask, void *pool_data);
 typedef void (mempool_free_t)(void *element, void *pool_data);
 
-typedef struct mempool_s {
+typedef struct mempool {
 	spinlock_t lock;
 	int min_nr;		/* nr of elements at *elements */
 	int curr_nr;		/* Current nr of elements at *elements */
--- a/include/linux/netfs.h~mempool-rename-struct-mempool_s-to-struct-mempool
+++ a/include/linux/netfs.h
@@ -21,7 +21,7 @@
 #include <linux/rolling_buffer.h>
 
 enum netfs_sreq_ref_trace;
-typedef struct mempool_s mempool_t;
+typedef struct mempool mempool_t;
 struct folio_queue;
 
 /**
_

Patches currently in -mm which might be from hch@lst.de are

mempool-rename-struct-mempool_s-to-struct-mempool.patch

