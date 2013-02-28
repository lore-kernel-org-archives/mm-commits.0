From: akpm@linux-foundation.org
Subject: [merged] mtd-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:48 -0800
Message-ID: <20130228201448.B0C6D31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48699 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3B1UOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:49 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so245013ggi.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, dwmw2@infradead.org, ezequiel.garcia@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mtd: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     mtd-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mtd: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/mtd/mtdcore.c~mtd-convert-to-idr_alloc drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~mtd-convert-to-idr_alloc
+++ a/drivers/mtd/mtdcore.c
@@ -349,13 +349,8 @@ int add_mtd_device(struct mtd_info *mtd)
 	BUG_ON(mtd->writesize == 0);
 	mutex_lock(&mtd_table_mutex);
 
-	do {
-		if (!idr_pre_get(&mtd_idr, GFP_KERNEL))
-			goto fail_locked;
-		error = idr_get_new(&mtd_idr, mtd, &i);
-	} while (error == -EAGAIN);
