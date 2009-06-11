From: akpm@linux-foundation.org
Subject: [merged] ramdisk-remove-long-deprecated-ramdisk=-boot-time-param.patch removed from -mm tree
Date: Thu, 11 Jun 2009 14:25:00 -0700
Message-ID: <200906112125.n5BLP04Z017998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbZFKVZG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 17:25:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, jens.axboe@oracle.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     ramdisk: remove long-deprecated "ramdisk=" boot-time parameter
has been removed from the -mm tree.  Its filename was
     ramdisk-remove-long-deprecated-ramdisk=-boot-time-param.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ramdisk: remove long-deprecated "ramdisk=" boot-time parameter
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

The "ramdisk" parameter was removed from the defunct rd.c file quite some
time ago, in favour of the more specific "ramdisk_size" parameter so, for
consistency, the same should be done here.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/block/brd.c~ramdisk-remove-long-deprecated-ramdisk=-boot-time-param drivers/block/brd.c
--- a/drivers/block/brd.c~ramdisk-remove-long-deprecated-ramdisk=-boot-time-param
+++ a/drivers/block/brd.c
@@ -407,12 +407,7 @@ static int __init ramdisk_size(char *str
 	rd_size = simple_strtol(str, NULL, 0);
 	return 1;
 }
-static int __init ramdisk_size2(char *str)
-{
-	return ramdisk_size(str);
-}
-__setup("ramdisk=", ramdisk_size);
-__setup("ramdisk_size=", ramdisk_size2);
+__setup("ramdisk_size=", ramdisk_size);
 #endif
 
 /*
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
drm-simplify-kcalloc-call-to-kzalloc.patch
kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch
ntfs-use-is_power_of_2-function-for-clarity.patch

