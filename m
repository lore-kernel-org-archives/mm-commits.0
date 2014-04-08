From: akpm@linux-foundation.org
Subject: [merged] zram-report-failed-read-and-write-stats.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:03:25 -0700
Message-ID: <5344641d.hPLStgIlyhYaiAKE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbaDHVD0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:03:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-report-failed-read-and-write-stats.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:03:25 -0700


The patch titled
     Subject: zram: report failed read and write stats
has been removed from the -mm tree.  Its filename was
     zram-report-failed-read-and-write-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: report failed read and write stats

zram accounted but did not report numbers of failed read and write
queries.  make these stats available as failed_reads and failed_writes
attrs.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-report-failed-read-and-write-stats drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-report-failed-read-and-write-stats
+++ a/drivers/block/zram/zram_drv.c
@@ -730,6 +730,8 @@ static DEVICE_ATTR(mem_used_total, S_IRU
 
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
+ZRAM_ATTR_RO(failed_reads);
+ZRAM_ATTR_RO(failed_writes);
 ZRAM_ATTR_RO(invalid_io);
 ZRAM_ATTR_RO(notify_free);
 ZRAM_ATTR_RO(zero_pages);
@@ -741,6 +743,8 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_reset.attr,
 	&dev_attr_num_reads.attr,
 	&dev_attr_num_writes.attr,
+	&dev_attr_failed_reads.attr,
+	&dev_attr_failed_writes.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
 	&dev_attr_zero_pages.attr,
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

