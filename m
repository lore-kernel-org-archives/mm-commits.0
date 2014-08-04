From: akpm@linux-foundation.org
Subject: [merged] dm-bufio-fully-initialize-shrinker.patch removed from
 -mm tree
Date: Mon, 04 Aug 2014 13:33:42 -0700
Message-ID: <53dfee26.6DQXGotMWODEielL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:45337 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaHDUdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2014 16:33:43 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1332173pdj.2
        for <mm-commits@vger.kernel.org>; Mon, 04 Aug 2014 13:33:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, agk@redhat.com, dchinner@redhat.com, mpatocka@redhat.com, neilb@suse.de, snitzer@redhat.com, stable@vger.kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dm bufio: fully initialize shrinker
has been removed from the -mm tree.  Its filename was
     dm-bufio-fully-initialize-shrinker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: dm bufio: fully initialize shrinker

1d3d4437eae1 ("vmscan: per-node deferred work") added a flags field to
struct shrinker assuming that all shrinkers were zero filled.  The dm
bufio shrinker is not zero filled, which leaves arbitrary kmalloc() data
in flags.  So far the only defined flags bit is SHRINKER_NUMA_AWARE.
But there are proposed patches which add other bits to shrinker.flags
(e.g. memcg awareness).

Rather than simply initializing the shrinker, this patch uses kzalloc()
when allocating the dm_bufio_client to ensure that the embedded shrinker
and any other similar structures are zeroed.

This fixes theoretical over aggressive shrinking of dm bufio objects.
If the uninitialized dm_bufio_client.shrinker.flags contains
SHRINKER_NUMA_AWARE then shrink_slab() would call the dm shrinker for
each numa node rather than just once.  This has been broken since 3.12.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Dave Chinner <dchinner@redhat.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-bufio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/dm-bufio.c~dm-bufio-fully-initialize-shrinker drivers/md/dm-bufio.c
--- a/drivers/md/dm-bufio.c~dm-bufio-fully-initialize-shrinker
+++ a/drivers/md/dm-bufio.c
@@ -1541,7 +1541,7 @@ struct dm_bufio_client *dm_bufio_client_
 	BUG_ON(block_size < 1 << SECTOR_SHIFT ||
 	       (block_size & (block_size - 1)));
 
-	c = kmalloc(sizeof(*c), GFP_KERNEL);
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
 	if (!c) {
 		r = -ENOMEM;
 		goto bad_client;
_

Patches currently in -mm which might be from gthelen@google.com are

memcg-remove-lookup_cgroup_page-prototype.patch

