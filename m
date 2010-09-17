From: akpm@linux-foundation.org
Subject: + zram-work-around-oops-due-to-startup-ordering-snafu.patch added to -mm tree
Date: Fri, 17 Sep 2010 13:59:54 -0700
Message-ID: <201009172059.o8HKxsPW009766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364Ab0IQU74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 16:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, greg@kroah.com, ngupta@vflare.org


The patch titled
     zram: work around oops due to startup ordering snafu
has been added to the -mm tree.  Its filename is
     zram-work-around-oops-due-to-startup-ordering-snafu.patch

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
Subject: zram: work around oops due to startup ordering snafu
From: Anton Blanchard <anton@samba.org>

I'm getting an oops when running mkfs on zram:

NIP [d0000000030e0340] .zram_inc_stat+0x58/0x84 [zram]
[c00000006d58f720] [d0000000030e091c] .zram_make_request+0xa8/0x6a0 [zram]
[c00000006d58f840] [c00000000035795c] .generic_make_request+0x390/0x434
[c00000006d58f950] [c000000000357b14] .submit_bio+0x114/0x140
[c00000006d58fa20] [c000000000361778] .blkdev_issue_discard+0x1ac/0x250
[c00000006d58fb10] [c000000000361f68] .blkdev_ioctl+0x358/0x7fc
[c00000006d58fbd0] [c0000000001c1c1c] .block_ioctl+0x6c/0x90
[c00000006d58fc70] [c0000000001984c4] .do_vfs_ioctl+0x660/0x6d4
[c00000006d58fd70] [c0000000001985a0] .SyS_ioctl+0x68/0xb0

Since disksize no longer starts as 0 it looks like we can call
zram_make_request before the device has been initialised. The patch below
fixes the immediate problem but this would go away if we move the
initialisation function elsewhere (as suggested in another thread).

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zram/zram_drv.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/staging/zram/zram_drv.c~zram-work-around-oops-due-to-startup-ordering-snafu drivers/staging/zram/zram_drv.c
--- a/drivers/staging/zram/zram_drv.c~zram-work-around-oops-due-to-startup-ordering-snafu
+++ a/drivers/staging/zram/zram_drv.c
@@ -435,6 +435,12 @@ static int zram_make_request(struct requ
 	int ret = 0;
 	struct zram *zram = queue->queuedata;
 
+	if (unlikely(!zram->init_done)) {
+		set_bit(BIO_UPTODATE, &bio->bi_flags);
+		bio_endio(bio, 0);
+		return 0;
+	}
+
 	if (!valid_io_request(zram, bio)) {
 		zram_stat64_inc(zram, &zram->stats.invalid_io);
 		bio_io_error(bio);
_

Patches currently in -mm which might be from anton@samba.org are

linux-next.patch
zram-free-percpu-data-on-module-exit.patch
zram-work-around-oops-due-to-startup-ordering-snafu.patch

