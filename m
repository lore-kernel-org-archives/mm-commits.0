From: akpm@linux-foundation.org
Subject: + readahead-add-blk_run_backing_dev.patch added to -mm tree
Date: Mon, 01 Jun 2009 16:11:17 -0700
Message-ID: <200906012311.n51NBI9V001178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753181AbZFAXLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 19:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hifumi.hisashi@oss.ntt.co.jp, fengguang.wu@intel.com, jens.axboe@oracle.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     readahead: add blk_run_backing_dev
has been added to the -mm tree.  Its filename is
     readahead-add-blk_run_backing_dev.patch

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
Subject: readahead: add blk_run_backing_dev
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

I added blk_run_backing_dev on page_cache_async_readahead so readahead I/O
is unpluged to improve throughput on especially RAID environment.

The normal case is, if page N become uptodate at time T(N), then T(N) <=
T(N+1) holds.  With RAID (and NFS to some degree), there is no strict
ordering, the data arrival time depends on runtime status of individual
disks, which breaks that formula.  So in do_generic_file_read(), just
after submitting the async readahead IO request, the current page may well
be uptodate, so the page won't be locked, and the block device won't be
implicitly unplugged:

               if (PageReadahead(page))
                        page_cache_async_readahead()
                if (!PageUptodate(page))
                                goto page_not_up_to_date;
                //...
page_not_up_to_date:
                lock_page_killable(page);

Therefore explicit unplugging can help.

Following is the test result with dd.

#dd if=testdir/testfile of=/dev/null bs=16384

-2.6.30-rc6
1048576+0 records in
1048576+0 records out
17179869184 bytes (17 GB) copied, 224.182 seconds, 76.6 MB/s

-2.6.30-rc6-patched
1048576+0 records in
1048576+0 records out
17179869184 bytes (17 GB) copied, 206.465 seconds, 83.2 MB/s

(7Disks RAID-0 Array)

-2.6.30-rc6
1054976+0 records in
1054976+0 records out
17284726784 bytes (17 GB) copied, 212.233 seconds, 81.4 MB/s

-2.6.30-rc6-patched
1054976+0 records out
17284726784 bytes (17 GB) copied, 198.878 seconds, 86.9 MB/s

(7Disks RAID-5 Array)

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/readahead.c~readahead-add-blk_run_backing_dev mm/readahead.c
--- a/mm/readahead.c~readahead-add-blk_run_backing_dev
+++ a/mm/readahead.c
@@ -547,5 +547,15 @@ page_cache_async_readahead(struct addres
 
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
+
+	/*
+	* Normally the current page is !uptodate and lock_page() will be
+	* immediately called to implicitly unplug the device. However this
+	* is not always true for RAID conifgurations, where data arrives
+	* not strictly in their submission order. In this case we need to
+	* explicitly kick off the IO.
+	*/
+	if (PageUptodate(page))
+		blk_run_backing_dev(mapping->backing_dev_info, NULL);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are

linux-next.patch
readahead-add-blk_run_backing_dev.patch

