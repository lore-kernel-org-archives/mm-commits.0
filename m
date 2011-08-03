From: akpm@linux-foundation.org
Subject: [merged] block-genhdc-remove-useless-cast-in-diskstats_show.patch removed from -mm tree
Date: Wed, 03 Aug 2011 12:00:02 -0700
Message-ID: <201108031857.p73IvVka006741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349Ab1HCS6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 14:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@13thfloor.at, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     block/genhd.c: remove useless cast in diskstats_show()
has been removed from the -mm tree.  Its filename was
     block-genhdc-remove-useless-cast-in-diskstats_show.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block/genhd.c: remove useless cast in diskstats_show()
From: Herbert Poetzl <herbert@13thfloor.at>

Remove the (unsigned long long) cast in diskstats_show() and adjusts the
seq_printf() format string to 'unsigned long'

diskstats_show() uses part_stat_read() to get the stats, which either
accesses the specified field in the struct disk_stats directly (non SMP)
or sums up the per CPU values in a variable of the same type as the field,
so in any case the result will have the same type and range as the
specified field which for all disk_stats entries is unsigned long

Also, for unsigned long ranges the output of %lu should be identical to
the one of %llu, so no change in the actual proc entry contents.

Signed-off-by: Herbert Poetzl <herbert@13thfloor.at>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN block/genhd.c~block-genhdc-remove-useless-cast-in-diskstats_show block/genhd.c
--- a/block/genhd.c~block-genhdc-remove-useless-cast-in-diskstats_show
+++ a/block/genhd.c
@@ -1146,17 +1146,17 @@ static int diskstats_show(struct seq_fil
 		cpu = part_stat_lock();
 		part_round_stats(cpu, hd);
 		part_stat_unlock();
-		seq_printf(seqf, "%4d %7d %s %lu %lu %llu "
-			   "%u %lu %lu %llu %u %u %u %u\n",
+		seq_printf(seqf, "%4d %7d %s %lu %lu %lu "
+			   "%u %lu %lu %lu %u %u %u %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
 			   disk_name(gp, hd->partno, buf),
 			   part_stat_read(hd, ios[READ]),
 			   part_stat_read(hd, merges[READ]),
-			   (unsigned long long)part_stat_read(hd, sectors[READ]),
+			   part_stat_read(hd, sectors[READ]),
 			   jiffies_to_msecs(part_stat_read(hd, ticks[READ])),
 			   part_stat_read(hd, ios[WRITE]),
 			   part_stat_read(hd, merges[WRITE]),
-			   (unsigned long long)part_stat_read(hd, sectors[WRITE]),
+			   part_stat_read(hd, sectors[WRITE]),
 			   jiffies_to_msecs(part_stat_read(hd, ticks[WRITE])),
 			   part_in_flight(hd),
 			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
_

Patches currently in -mm which might be from herbert@13thfloor.at are

linux-next.patch

