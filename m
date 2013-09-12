From: akpm@linux-foundation.org
Subject: [merged]
 block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:01 -0700
Message-ID: <52321909.RrMrSCD8765orMnx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:01 -0700


The patch titled
     Subject: block/blk-sysfs.c: replace strict_strtoul() with kstrtoul()
has been removed from the -mm tree.  Its filename was
     block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: block/blk-sysfs.c: replace strict_strtoul() with kstrtoul()

The usage of strict_strtoul() is not preferred, because strict_strtoul()
is obsolete.  Thus, kstrtoul() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-sysfs.c~block-blk-sysfs-replace-strict_strtoul-with-kstrtoul block/blk-sysfs.c
--- a/block/blk-sysfs.c~block-blk-sysfs-replace-strict_strtoul-with-kstrtoul
+++ a/block/blk-sysfs.c
@@ -29,7 +29,7 @@ queue_var_store(unsigned long *var, cons
 	int err;
 	unsigned long v;
 
-	err = strict_strtoul(page, 10, &v);
+	err = kstrtoul(page, 10, &v);
 	if (err || v > UINT_MAX)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
kernel-replace-strict_strto-with-kstrto.patch

