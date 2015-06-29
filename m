From: akpm@linux-foundation.org
Subject: [merged] zpool-change-pr_info-to-pr_debug.patch removed from -mm
 tree
Date: Mon, 29 Jun 2015 13:46:39 -0700
Message-ID: <5591aeaf.ODKCZOMTnEIZoynW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbbF2Uqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, keescook@chromium.org, minchan@kernel.org, opensource.ganesh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zpool: change pr_info to pr_debug
has been removed from the -mm tree.  Its filename was
     zpool-change-pr_info-to-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zpool: change pr_info to pr_debug

Change the pr_info() calls to pr_debug().  There's no need for the extra
verbosity in the log.  Also change the msg formats to be consistent.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/zpool.c~zpool-change-pr_info-to-pr_debug mm/zpool.c
--- a/mm/zpool.c~zpool-change-pr_info-to-pr_debug
+++ a/mm/zpool.c
@@ -147,7 +147,7 @@ struct zpool *zpool_create_pool(char *ty
 	struct zpool_driver *driver;
 	struct zpool *zpool;
 
-	pr_info("creating pool type %s\n", type);
+	pr_debug("creating pool type %s\n", type);
 
 	driver = zpool_get_driver(type);
 
@@ -180,7 +180,7 @@ struct zpool *zpool_create_pool(char *ty
 		return NULL;
 	}
 
-	pr_info("created %s pool\n", type);
+	pr_debug("created pool type %s\n", type);
 
 	spin_lock(&pools_lock);
 	list_add(&zpool->list, &pools_head);
@@ -202,7 +202,7 @@ struct zpool *zpool_create_pool(char *ty
  */
 void zpool_destroy_pool(struct zpool *zpool)
 {
-	pr_info("destroying pool type %s\n", zpool->type);
+	pr_debug("destroying pool type %s\n", zpool->type);
 
 	spin_lock(&pools_lock);
 	list_del(&zpool->list);
_

Patches currently in -mm which might be from ddstreet@ieee.org are

origin.patch
linux-next.patch
maintainers-add-zpool.patch

