From: akpm@linux-foundation.org
Subject: [merged] fs-kdev_t-old-new_valid_dev-can-be-boolean.patch removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:20 -0800
Message-ID: <56425490.jmdCGnXMgh2JVADA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbKJUdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/kdev_t.h: old/new_valid_dev() can return bool
has been removed from the -mm tree.  Its filename was
     fs-kdev_t-old-new_valid_dev-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: include/linux/kdev_t.h: old/new_valid_dev() can return bool

Make old/new_valid_dev return bool due to these two particular functions
only using either one or zero as their return value.

No functional change.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kdev_t.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/kdev_t.h~fs-kdev_t-old-new_valid_dev-can-be-boolean include/linux/kdev_t.h
--- a/include/linux/kdev_t.h~fs-kdev_t-old-new_valid_dev-can-be-boolean
+++ a/include/linux/kdev_t.h
@@ -20,7 +20,7 @@
 	})
 
 /* acceptable for old filesystems */
-static inline int old_valid_dev(dev_t dev)
+static inline bool old_valid_dev(dev_t dev)
 {
 	return MAJOR(dev) < 256 && MINOR(dev) < 256;
 }
@@ -35,7 +35,7 @@ static inline dev_t old_decode_dev(u16 v
 	return MKDEV((val >> 8) & 255, val & 255);
 }
 
-static inline int new_valid_dev(dev_t dev)
+static inline bool new_valid_dev(dev_t dev)
 {
 	return 1;
 }
_

Patches currently in -mm which might be from bywxiaobai@163.com are


