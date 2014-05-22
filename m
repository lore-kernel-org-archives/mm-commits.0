From: akpm@linux-foundation.org
Subject: + fs-superblock-unregister-sb-shrinker-before-kill_sb.patch added to -mm tree
Date: Thu, 22 May 2014 11:05:16 -0700
Message-ID: <537e3c5c.AOyyHAjqr+GPOHBp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaEVSFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 May 2014 14:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuanhan.liu@linux.intel.com, viro@zeniv.linux.org.uk, tim.c.chen@linux.intel.com, riel@redhat.com, mgorman@suse.de, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, bob.liu@oracle.com, david@fromorbit.com

Subject: + fs-superblock-unregister-sb-shrinker-before-kill_sb.patch added to -mm tree
To: david@fromorbit.com,bob.liu@oracle.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mgorman@suse.de,riel@redhat.com,tim.c.chen@linux.intel.com,viro@zeniv.linux.org.uk,yuanhan.liu@linux.intel.com
From: akpm@linux-foundation.org
Date: Thu, 22 May 2014 11:05:16 -0700


The patch titled
     Subject: fs/superblock: unregister sb shrinker before ->kill_sb()
has been added to the -mm tree.  Its filename is
     fs-superblock-unregister-sb-shrinker-before-kill_sb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-superblock-unregister-sb-shrinker-before-kill_sb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-superblock-unregister-sb-shrinker-before-kill_sb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Chinner <david@fromorbit.com>
Subject: fs/superblock: unregister sb shrinker before ->kill_sb()

This series is aimed at regressions noticed during reclaim activity.  The
first two patches are shrinker patches that were posted ages ago but never
merged for reasons that are unclear to me.  I'm posting them again to see
if there was a reason they were dropped or if they just got lost.  Dave? 
Time?  The last patch adjusts proportional reclaim.  Yuanhan Liu, can you
retest the vm scalability test cases on a larger machine?  Hugh, does this
work for you on the memcg test cases?

Based on ext4, I get the following results but unfortunately my larger
test machines are all unavailable so this is based on a relatively small
machine.

postmark
                                  3.15.0-rc5            3.15.0-rc5
                                     vanilla       proportion-v1r4
Ops/sec Transactions         21.00 (  0.00%)       25.00 ( 19.05%)
Ops/sec FilesCreate          39.00 (  0.00%)       45.00 ( 15.38%)
Ops/sec CreateTransact       10.00 (  0.00%)       12.00 ( 20.00%)
Ops/sec FilesDeleted       6202.00 (  0.00%)     6202.00 (  0.00%)
Ops/sec DeleteTransact       11.00 (  0.00%)       12.00 (  9.09%)
Ops/sec DataRead/MB          25.97 (  0.00%)       30.02 ( 15.59%)
Ops/sec DataWrite/MB         49.99 (  0.00%)       57.78 ( 15.58%)

ffsb (mail server simulator)
                                 3.15.0-rc5             3.15.0-rc5
                                    vanilla        proportion-v1r4
Ops/sec readall           9402.63 (  0.00%)      9805.74 (  4.29%)
Ops/sec create            4695.45 (  0.00%)      4781.39 (  1.83%)
Ops/sec delete             173.72 (  0.00%)       177.23 (  2.02%)
Ops/sec Transactions     14271.80 (  0.00%)     14764.37 (  3.45%)
Ops/sec Read                37.00 (  0.00%)        38.50 (  4.05%)
Ops/sec Write               18.20 (  0.00%)        18.50 (  1.65%)

dd of a large file
                                3.15.0-rc5            3.15.0-rc5
                                   vanilla       proportion-v1r4
WallTime DownloadTar       75.00 (  0.00%)       61.00 ( 18.67%)
WallTime DD               423.00 (  0.00%)      401.00 (  5.20%)
WallTime Delete             2.00 (  0.00%)        5.00 (-150.00%)

stutter (times mmap latency during large amounts of IO)

                            3.15.0-rc5            3.15.0-rc5
                               vanilla       proportion-v1r4
Unit >5ms Delays  80252.0000 (  0.00%)  81523.0000 ( -1.58%)
Unit Mmap min         8.2118 (  0.00%)      8.3206 ( -1.33%)
Unit Mmap mean       17.4614 (  0.00%)     17.2868 (  1.00%)
Unit Mmap stddev     24.9059 (  0.00%)     34.6771 (-39.23%)
Unit Mmap max      2811.6433 (  0.00%)   2645.1398 (  5.92%)
Unit Mmap 90%        20.5098 (  0.00%)     18.3105 ( 10.72%)
Unit Mmap 93%        22.9180 (  0.00%)     20.1751 ( 11.97%)
Unit Mmap 95%        25.2114 (  0.00%)     22.4988 ( 10.76%)
Unit Mmap 99%        46.1430 (  0.00%)     43.5952 (  5.52%)
Unit Ideal  Tput     85.2623 (  0.00%)     78.8906 (  7.47%)
Unit Tput min        44.0666 (  0.00%)     43.9609 (  0.24%)
Unit Tput mean       45.5646 (  0.00%)     45.2009 (  0.80%)
Unit Tput stddev      0.9318 (  0.00%)      1.1084 (-18.95%)
Unit Tput max        46.7375 (  0.00%)     46.7539 ( -0.04%)



This patch (of 3):

We will like to unregister the sb shrinker before ->kill_sb().  This will
allow cached objects to be counted without call to grab_super_passive() to
update ref count on sb.  We want to avoid locking during memory
reclamation especially when we are skipping the memory reclaim when we are
out of cached objects.

This is safe because grab_super_passive does a try-lock on the
sb->s_umount now, and so if we are in the unmount process, it won't ever
block.  That means what used to be a deadlock and races we were avoiding
by using grab_super_passive() is now:

        shrinker                        umount

        down_read(shrinker_rwsem)
                                        down_write(sb->s_umount)
                                        shrinker_unregister
                                          down_write(shrinker_rwsem)
                                            <blocks>
        grab_super_passive(sb)
          down_read_trylock(sb->s_umount)
            <fails>
        <shrinker aborts>
        ....
        <shrinkers finish running>
        up_read(shrinker_rwsem)
                                          <unblocks>
                                          <removes shrinker>
                                          up_write(shrinker_rwsem)
                                        ->kill_sb()
                                        ....

So it is safe to deregister the shrinker before ->kill_sb().

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/super.c~fs-superblock-unregister-sb-shrinker-before-kill_sb fs/super.c
--- a/fs/super.c~fs-superblock-unregister-sb-shrinker-before-kill_sb
+++ a/fs/super.c
@@ -276,10 +276,8 @@ void deactivate_locked_super(struct supe
 	struct file_system_type *fs = s->s_type;
 	if (atomic_dec_and_test(&s->s_active)) {
 		cleancache_invalidate_fs(s);
-		fs->kill_sb(s);
-
-		/* caches are now gone, we can safely kill the shrinker now */
 		unregister_shrinker(&s->s_shrink);
+		fs->kill_sb(s);
 
 		put_filesystem(fs);
 		put_super(s);
_

Patches currently in -mm which might be from david@fromorbit.com are

fs-bufferc-remove-block_write_full_page_endio.patch
fs-mpagec-factor-clean_buffers-out-of-__mpage_writepage.patch
fs-mpagec-factor-page_endio-out-of-mpage_end_io.patch
fs-block_devc-add-bdev_read_page-and-bdev_write_page.patch
swap-use-bdev_read_page-bdev_write_page.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
brd-add-support-for-rw_page.patch
brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch
mm-shrinker-trace-points-fix-negatives.patch
mm-shrinker-add-nid-to-tracepoint-output.patch
fs-superblock-unregister-sb-shrinker-before-kill_sb.patch
fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch
mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch
linux-next.patch

