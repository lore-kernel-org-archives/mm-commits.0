From: akpm@linux-foundation.org
Subject: + blockloop-ratelimit-error-messages.patch added to -mm tree
Date: Tue, 01 Apr 2014 14:56:47 -0700
Message-ID: <533b361f.MAQgZZYvubLflGuc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaDAV4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2014 17:56:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, bitbucket@online.de

Subject: + blockloop-ratelimit-error-messages.patch added to -mm tree
To: bitbucket@online.de,axboe@kernel.dk
From: akpm@linux-foundation.org
Date: Tue, 01 Apr 2014 14:56:47 -0700


The patch titled
     Subject: drivers/block/loop.c: ratelimit error messages
has been added to the -mm tree.  Its filename is
     blockloop-ratelimit-error-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/blockloop-ratelimit-error-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/blockloop-ratelimit-error-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Galbraith <bitbucket@online.de>
Subject: drivers/block/loop.c: ratelimit error messages

Metric tons of high speed spew is not helpful when things go pear shaped. 
systemd lost its mind, forgot how to stop services it insists on being
sole manager of, massive printk() flood ensued, box eventually died.

[16206.684000] loop: Write error at byte offset 11412291584, length 4096.
[16206.684000] systemd-journald[1758]: /dev/kmsg buffer overrun, some messages lost.
[16206.684000] loop: Write error at byte offset 13155434496, length 4096.
[16206.684000] loop: Write error at byte offset 13155438592, length 4096.
[16206.684000] loop: Write error at byte offset 13155442688, length 4096.
[16206.684000] loop: Write error at byte offset 13960736768, length 4096.
[16206.684000] loop: Write error at byte offset 14229172224, length 4096.
[16206.684000] systemd-journald[1758]: /dev/kmsg buffer overrun, some messages lost.
[16206.684000] loop: Write error at byte offset 14766043136, length 4096.
[16206.684000] loop: Write error at byte offset 15034478592, length 4096.
[16206.684000] systemd-journald[1758]: /dev/kmsg buffer overrun, some messages lost.

Signed-off-by: Mike Galbraith <bitbucket@online.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/loop.c~blockloop-ratelimit-error-messages drivers/block/loop.c
--- a/drivers/block/loop.c~blockloop-ratelimit-error-messages
+++ a/drivers/block/loop.c
@@ -237,7 +237,7 @@ static int __do_lo_send_write(struct fil
 	file_end_write(file);
 	if (likely(bw == len))
 		return 0;
-	printk(KERN_ERR "loop: Write error at byte offset %llu, length %i.\n",
+	printk_ratelimited(KERN_ERR "loop: Write error at byte offset %llu, length %i.\n",
 			(unsigned long long)pos, len);
 	if (bw >= 0)
 		bw = -EIO;
@@ -277,7 +277,7 @@ static int do_lo_send_write(struct loop_
 		return __do_lo_send_write(lo->lo_backing_file,
 				page_address(page), bvec->bv_len,
 				pos);
-	printk(KERN_ERR "loop: Transfer error at byte offset %llu, "
+	printk_ratelimited(KERN_ERR "loop: Transfer error at byte offset %llu, "
 			"length %i.\n", (unsigned long long)pos, bvec->bv_len);
 	if (ret > 0)
 		ret = -EIO;
@@ -316,7 +316,7 @@ static int lo_send(struct loop_device *l
 out:
 	return ret;
 fail:
-	printk(KERN_ERR "loop: Failed to allocate temporary page for write.\n");
+	printk_ratelimited(KERN_ERR "loop: Failed to allocate temporary page for write.\n");
 	ret = -ENOMEM;
 	goto out;
 }
@@ -345,7 +345,7 @@ lo_splice_actor(struct pipe_inode_info *
 		size = p->bsize;
 
 	if (lo_do_transfer(lo, READ, page, buf->offset, p->page, p->offset, size, IV)) {
-		printk(KERN_ERR "loop: transfer error block %ld\n",
+		printk_ratelimited(KERN_ERR "loop: transfer error block %ld\n",
 		       page->index);
 		size = -EINVAL;
 	}
_

Patches currently in -mm which might be from bitbucket@online.de are

origin.patch
blockloop-ratelimit-error-messages.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
linux-next.patch

