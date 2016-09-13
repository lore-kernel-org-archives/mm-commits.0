From: akpm@linux-foundation.org
Subject: + fs-bufferc-make-__getblk_slow-static.patch added to -mm tree
Date: Tue, 13 Sep 2016 15:01:40 -0700
Message-ID: <57d87744.BpYmcks3kvtZu3X+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754940AbcIMWBl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2016 18:01:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer.c: make __getblk_slow() static
has been added to the -mm tree.  Its filename is
     fs-bufferc-make-__getblk_slow-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-bufferc-make-__getblk_slow-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-bufferc-make-__getblk_slow-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: fs/buffer.c: make __getblk_slow() static

__getblk_slow() was exported to modules in commit 3b5e6454aaf6
("fs/buffer.c: support buffer cache allocations with gfp modifiers"). 
This seems to have been a mistake, as no users were introduced nor was the
function declared in a header.  Change it back to 'static'.

Link: http://lkml.kernel.org/r/1473712241-85003-1-git-send-email-ebiggers@google.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/buffer.c~fs-bufferc-make-__getblk_slow-static fs/buffer.c
--- a/fs/buffer.c~fs-bufferc-make-__getblk_slow-static
+++ a/fs/buffer.c
@@ -1078,7 +1078,7 @@ grow_buffers(struct block_device *bdev,
 	return grow_dev_page(bdev, block, index, size, sizebits, gfp);
 }
 
-struct buffer_head *
+static struct buffer_head *
 __getblk_slow(struct block_device *bdev, sector_t block,
 	     unsigned size, gfp_t gfp)
 {
@@ -1109,7 +1109,6 @@ __getblk_slow(struct block_device *bdev,
 			free_more_memory();
 	}
 }
-EXPORT_SYMBOL(__getblk_slow);
 
 /*
  * The relationship between dirty buffers and dirty pages:
_

Patches currently in -mm which might be from ebiggers@google.com are

fs-bufferc-make-__getblk_slow-static.patch

