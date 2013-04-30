From: akpm@linux-foundation.org
Subject: [merged] mm-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:31 -0700
Message-ID: <20130430190231.6FBEF5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:39764 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3D3TCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:33 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so78091veb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     mm-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm/: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-rename-random32-to-prandom_u32 mm/swapfile.c
--- a/mm/swapfile.c~mm-rename-random32-to-prandom_u32
+++ a/mm/swapfile.c
@@ -2121,7 +2121,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (p->bdev) {
 		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 			p->flags |= SWP_SOLIDSTATE;
-			p->cluster_next = 1 + (random32() % p->highest_bit);
+			p->cluster_next = 1 + (prandom_u32() % p->highest_bit);
 		}
 		if ((swap_flags & SWAP_FLAG_DISCARD) && discard_swap(p) == 0)
 			p->flags |= SWP_DISCARDABLE;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch

