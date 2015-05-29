From: akpm@linux-foundation.org
Subject: + zpool-change-pr_info-to-pr_debug.patch added to -mm tree
Date: Fri, 29 May 2015 14:35:34 -0700
Message-ID: <5568dba6.JxUdRlxbA89f2luj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbbE2Vff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 May 2015 17:35:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, keescook@chromium.org, minchan@kernel.org, opensource.ganesh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zpool: change pr_info to pr_debug
has been added to the -mm tree.  Its filename is
     zpool-change-pr_info-to-pr_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zpool-change-pr_info-to-pr_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zpool-change-pr_info-to-pr_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
zpool-change-pr_info-to-pr_debug.patch
linux-next.patch

