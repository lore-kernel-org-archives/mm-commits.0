From: akpm@linux-foundation.org
Subject: - hide-spinlock-in-linux-quotah-behind-__kernel__.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:34 -0700
Message-ID: <200705090252.l492qYXr009584@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969967AbXEICwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dwmw2@infradead.org, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     hide spinlock in linux/quota.h behind __KERNEL__
has been removed from the -mm tree.  Its filename was
     hide-spinlock-in-linux-quotah-behind-__kernel__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hide spinlock in linux/quota.h behind __KERNEL__
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Jan Kara <jack@ucw.cz>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quota.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/quota.h~hide-spinlock-in-linux-quotah-behind-__kernel__ include/linux/quota.h
--- a/include/linux/quota.h~hide-spinlock-in-linux-quotah-behind-__kernel__
+++ a/include/linux/quota.h
@@ -44,8 +44,6 @@
 typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
 typedef __u64 qsize_t;          /* Type in which we store sizes */
 
-extern spinlock_t dq_data_lock;
-
 /* Size of blocks in which are counted size limits */
 #define QUOTABLOCK_BITS 10
 #define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
@@ -139,6 +137,8 @@ struct if_dqinfo {
 #include <linux/dqblk_v1.h>
 #include <linux/dqblk_v2.h>
 
+extern spinlock_t dq_data_lock;
+
 /* Maximal numbers of writes for quota operation (insert/delete/update)
  * (over VFS all formats) */
 #define DQUOT_INIT_ALLOC max(V1_INIT_ALLOC, V2_INIT_ALLOC)
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
