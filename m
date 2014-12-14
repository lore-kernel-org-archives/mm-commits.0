From: akpm@linux-foundation.org
Subject: [merged] mm-zbud-init-user-ops-only-when-it-is-needed.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:09:09 -0800
Message-ID: <548d0d65.xkVcagpuSYolfslD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaLNEJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heesub.shin@samsung.com, ddstreet@ieee.org, sjennings@variantweb.net, sunae.seo@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: init user ops only when it is needed
has been removed from the -mm tree.  Its filename was
     mm-zbud-init-user-ops-only-when-it-is-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heesub Shin <heesub.shin@samsung.com>
Subject: mm/zbud: init user ops only when it is needed

When zbud is initialized through the zpool wrapper, pool->ops which
points to user-defined operations is always set regardless of whether it
is specified from the upper layer. This causes zbud_reclaim_page() to
iterate its loop for evicting pool pages out without any gain.

This patch sets the user-defined ops only when it is needed, so that
zbud_reclaim_page() can bail out the reclamation loop earlier if there
is no user-defined operations specified.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
Acked-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Sunae Seo <sunae.seo@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zbud.c~mm-zbud-init-user-ops-only-when-it-is-needed mm/zbud.c
--- a/mm/zbud.c~mm-zbud-init-user-ops-only-when-it-is-needed
+++ a/mm/zbud.c
@@ -132,7 +132,7 @@ static struct zbud_ops zbud_zpool_ops =
 
 static void *zbud_zpool_create(gfp_t gfp, struct zpool_ops *zpool_ops)
 {
-	return zbud_create_pool(gfp, &zbud_zpool_ops);
+	return zbud_create_pool(gfp, zpool_ops ? &zbud_zpool_ops : NULL);
 }
 
 static void zbud_zpool_destroy(void *pool)
_

Patches currently in -mm which might be from heesub.shin@samsung.com are

origin.patch

