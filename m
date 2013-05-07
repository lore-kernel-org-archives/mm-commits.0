From: akpm@linux-foundation.org
Subject: [merged] hfsplus-remove-duplicated-message-prefix-in-hfsplus_block_free.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:57 -0700
Message-ID: <20130507174857.7B06431C2DA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:60403 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3EGRs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:58 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so85275vcb.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, hch@lst.de, htl10@users.sourceforge.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: remove duplicated message prefix in hfsplus_block_free()
has been removed from the -mm tree.  Its filename was
     hfsplus-remove-duplicated-message-prefix-in-hfsplus_block_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: remove duplicated message prefix in hfsplus_block_free()

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bitmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/hfsplus/bitmap.c~hfsplus-remove-duplicated-message-prefix-in-hfsplus_block_free fs/hfsplus/bitmap.c
--- a/fs/hfsplus/bitmap.c~hfsplus-remove-duplicated-message-prefix-in-hfsplus_block_free
+++ a/fs/hfsplus/bitmap.c
@@ -238,8 +238,7 @@ out:
 	return 0;
 
 kaboom:
-	pr_crit("hfsplus: unable to mark blocks free: error %ld\n",
-			PTR_ERR(page));
+	pr_crit("unable to mark blocks free: error %ld\n", PTR_ERR(page));
 	mutex_unlock(&sbi->alloc_mutex);
 
 	return -EIO;
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch

