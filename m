From: akpm@linux-foundation.org
Subject: + swap-fix-set_blocksize-race-during-swapon-swapoff.patch added
 to -mm tree
Date: Fri, 11 Oct 2013 11:56:05 -0700
Message-ID: <525849c5.5RHOV5b5ui9qDn40%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab3JKS4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Oct 2013 14:56:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijie.yang.kh@gmail.com, shli@fusionio.com, minchan@kernel.org, konrad.wilk@oracle.com, bob.liu@oracle.com, k.kozlowski@samsung.com

Subject: + swap-fix-set_blocksize-race-during-swapon-swapoff.patch added to -mm tree
To: k.kozlowski@samsung.com,bob.liu@oracle.com,konrad.wilk@oracle.com,minchan@kernel.org,shli@fusionio.com,weijie.yang.kh@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 11 Oct 2013 11:56:05 -0700


The patch titled
     Subject: swap: fix set_blocksize race during swapon/swapoff
has been added to the -mm tree.  Its filename is
     swap-fix-set_blocksize-race-during-swapon-swapoff.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-fix-set_blocksize-race-during-swapon-swapoff.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-fix-set_blocksize-race-during-swapon-swapoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: swap: fix set_blocksize race during swapon/swapoff

Swapoff used old_block_size from swap_info which could be overwritten by
concurrent swapon.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reported-by: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~swap-fix-set_blocksize-race-during-swapon-swapoff mm/swapfile.c
--- a/mm/swapfile.c~swap-fix-set_blocksize-race-during-swapon-swapoff
+++ a/mm/swapfile.c
@@ -1824,6 +1824,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	struct filename *pathname;
 	int i, type, prev;
 	int err;
+	unsigned int old_block_size;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1914,6 +1915,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	}
 
 	swap_file = p->swap_file;
+	old_block_size = p->old_block_size;
 	p->swap_file = NULL;
 	p->max = 0;
 	swap_map = p->swap_map;
@@ -1938,7 +1940,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	inode = mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
 		struct block_device *bdev = I_BDEV(inode);
-		set_blocksize(bdev, p->old_block_size);
+		set_blocksize(bdev, old_block_size);
 		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	} else {
 		mutex_lock(&inode->i_mutex);
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

frontswap-enable-call-to-invalidate-area-on-swapoff.patch
swap-fix-set_blocksize-race-during-swapon-swapoff.patch

