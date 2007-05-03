From: akpm@linux-foundation.org
Subject: + hide-spinlock-in-linux-quotah-behind-__kernel__.patch added to -mm tree
Date: Thu, 03 May 2007 01:26:47 -0700
Message-ID: <200705030826.l438Qlei008050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbXECI07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 04:26:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dwmw2@infradead.org, jack@ucw.cz


The patch titled
     hide spinlock in linux/quota.h behind __KERNEL__
has been added to the -mm tree.  Its filename is
     hide-spinlock-in-linux-quotah-behind-__kernel__.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hide spinlock in linux/quota.h behind __KERNEL__
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Jan Kara <jack@ucw.cz>
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

git-cpufreq.patch
git-kbuild.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
hide-spinlock-in-linux-quotah-behind-__kernel__.patch
