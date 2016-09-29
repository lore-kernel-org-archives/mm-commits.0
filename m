From: akpm@linux-foundation.org
Subject: [merged] fs-bufferc-make-__getblk_slow-static.patch removed from
 -mm tree
Date: Thu, 29 Sep 2016 12:59:47 -0700
Message-ID: <57ed72b3.Wx78Wuc5+DuXamE0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44083 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755753AbcI2T7s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2016 15:59:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer.c: make __getblk_slow() static
has been removed from the -mm tree.  Its filename was
     fs-bufferc-make-__getblk_slow-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


