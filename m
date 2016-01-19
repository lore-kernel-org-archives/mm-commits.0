From: akpm@linux-foundation.org
Subject: [merged] include-linux-kdev_th-remove-new_valid_dev.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:37 -0800
Message-ID: <569e992d.Sp+U0mpIRD46hPea%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/kdev_t.h: remove new_valid_dev()
has been removed from the -mm tree.  Its filename was
     include-linux-kdev_th-remove-new_valid_dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: include/linux/kdev_t.h: remove new_valid_dev()

As all new_valid_dev() checks have been removed it's time to drop
new_valid_dev() itself.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kdev_t.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/kdev_t.h~include-linux-kdev_th-remove-new_valid_dev include/linux/kdev_t.h
--- a/include/linux/kdev_t.h~include-linux-kdev_th-remove-new_valid_dev
+++ a/include/linux/kdev_t.h
@@ -35,11 +35,6 @@ static inline dev_t old_decode_dev(u16 v
 	return MKDEV((val >> 8) & 255, val & 255);
 }
 
-static inline bool new_valid_dev(dev_t dev)
-{
-	return 1;
-}
