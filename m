From: akpm@linux-foundation.org
Subject: + zram-report-failed-read-and-write-stats.patch added to -mm tree
Date: Tue, 04 Feb 2014 14:19:15 -0800
Message-ID: <52f16763.DVR/CYmEnq3htQJl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950AbaBDWTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:19:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-report-failed-read-and-write-stats.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:19:15 -0800


The patch titled
     Subject: zram: report failed read and write stats
has been added to the -mm tree.  Its filename is
     zram-report-failed-read-and-write-stats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-report-failed-read-and-write-stats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-report-failed-read-and-write-stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -728,6 +728,8 @@ static DEVICE_ATTR(mem_used_total, S_IRU
 
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
+ZRAM_ATTR_RO(failed_reads);
+ZRAM_ATTR_RO(failed_writes);
 ZRAM_ATTR_RO(invalid_io);
 ZRAM_ATTR_RO(notify_free);
 ZRAM_ATTR_RO(zero_pages);
@@ -739,6 +741,8 @@ static struct attribute *zram_disk_attrs
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

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch

