From: akpm@linux-foundation.org
Subject: + ramzswap-use-slot-free-callback-to-eliminate-stale-data.patch added to -mm tree
Date: Fri, 08 Jan 2010 16:10:06 -0800
Message-ID: <201001090010.o090A6rB022650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754196Ab0AIAKz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 19:10:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ngupta@vflare.org, andi@firstfloor.org, greg@kroah.com, hch@infradead.org, hugh.dickins@tiscali.co.uk, jens.axboe@oracle.com, penberg@cs.helsinki.fi, viro@ZenIV.linux.org.uk


The patch titled
     ramzswap: use slot free callback to eliminate stale data
has been added to the -mm tree.  Its filename is
     ramzswap-use-slot-free-callback-to-eliminate-stale-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ramzswap: use slot free callback to eliminate stale data
From: Nitin Gupta <ngupta@vflare.org>

ramzswap driver creates RAM backed block devices which are used as swap
disks.  Pages swapped to these disks are compressed and stored in memory
itself.  However, when a swap page becomes stale i.e.  it is no longer
referenced by any process (say, when owning process exits), the driver
does not get any notification about this.  So, it has to keep such pages
in memory until kernel swaps to the same swap slot again thereby
overwriting previous (stale) page.

Often, a large number of such stale pages accumulate which defeats the
whole purpose of in-memory compressed swapping and it begins to have a
negative impact on system performance.

To overcome this problem, we now register a callback function which is
called as soon as a swap slot is freed which allows us to free
corresponding memory, eliminating any stale data in (compressed) memory.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/ramzswap/ramzswap_drv.c   |   15 ++++++++++++++-
 drivers/staging/ramzswap/ramzswap_drv.h   |    1 +
 drivers/staging/ramzswap/ramzswap_ioctl.h |    1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/staging/ramzswap/ramzswap_drv.c~ramzswap-use-slot-free-callback-to-eliminate-stale-data drivers/staging/ramzswap/ramzswap_drv.c
--- a/drivers/staging/ramzswap/ramzswap_drv.c~ramzswap-use-slot-free-callback-to-eliminate-stale-data
+++ a/drivers/staging/ramzswap/ramzswap_drv.c
@@ -253,6 +253,7 @@ void ramzswap_ioctl_get_stats(struct ram
 	s->failed_reads = rs->failed_reads;
 	s->failed_writes = rs->failed_writes;
 	s->invalid_io = rs->invalid_io;
+	s->notify_free = rs->notify_free;
 	s->pages_zero = rs->pages_zero;
 
 	s->good_compress_pct = good_compress_perc;
@@ -1287,9 +1288,21 @@ out:
 	return ret;
 }
 
+void ramzswap_slot_free_notify(struct block_device *bdev, unsigned long index)
+{
+	struct ramzswap *rzs;
+
+	rzs = bdev->bd_disk->private_data;
+	ramzswap_free_page(rzs, index);
+	stat_inc(rzs->stats.notify_free);
+
+	return;
+}
+
 static struct block_device_operations ramzswap_devops = {
 	.ioctl = ramzswap_ioctl,
-	.owner = THIS_MODULE,
+	.swap_slot_free_notify = ramzswap_slot_free_notify,
+	.owner = THIS_MODULE
 };
 
 static void create_device(struct ramzswap *rzs, int device_id)
diff -puN drivers/staging/ramzswap/ramzswap_drv.h~ramzswap-use-slot-free-callback-to-eliminate-stale-data drivers/staging/ramzswap/ramzswap_drv.h
--- a/drivers/staging/ramzswap/ramzswap_drv.h~ramzswap-use-slot-free-callback-to-eliminate-stale-data
+++ a/drivers/staging/ramzswap/ramzswap_drv.h
@@ -124,6 +124,7 @@ struct ramzswap_stats {
 	u64 failed_reads;	/* can happen when memory is too low */
 	u64 failed_writes;	/* should NEVER! happen */
 	u64 invalid_io;		/* non-swap I/O requests */
+	u64 notify_free;	/* no. of swap slot free notifications */
 	u32 pages_zero;		/* no. of zero filled pages */
 	u32 pages_stored;	/* no. of pages currently stored */
 	u32 good_compress;	/* % of pages with compression ratio<=50% */
diff -puN drivers/staging/ramzswap/ramzswap_ioctl.h~ramzswap-use-slot-free-callback-to-eliminate-stale-data drivers/staging/ramzswap/ramzswap_ioctl.h
--- a/drivers/staging/ramzswap/ramzswap_ioctl.h~ramzswap-use-slot-free-callback-to-eliminate-stale-data
+++ a/drivers/staging/ramzswap/ramzswap_ioctl.h
@@ -27,6 +27,7 @@ struct ramzswap_ioctl_stats {
 	u64 failed_reads;	/* can happen when memory is too low */
 	u64 failed_writes;	/* should NEVER! happen */
 	u64 invalid_io;		/* non-swap I/O requests */
+	u64 notify_free;	/* no. of swap slot free notifications */
 	u32 pages_zero;		/* no. of zero filled pages */
 	u32 good_compress_pct;	/* no. of pages with compression ratio<=50% */
 	u32 pages_expand_pct;	/* no. of incompressible pages */
_

Patches currently in -mm which might be from ngupta@vflare.org are

mm-add-swap-slot-free-callback-to-block_device_operations.patch
ramzswap-use-slot-free-callback-to-eliminate-stale-data.patch

