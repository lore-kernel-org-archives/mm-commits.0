From: akpm@linux-foundation.org
Subject: [merged] debugobjects-fill_pool-returns-void-now.patch removed from -mm tree
Date: Fri, 27 Apr 2012 12:35:36 -0700
Message-ID: <20120427193536.73E03A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61838 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761337Ab2D0Tfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 15:35:37 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so121090qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 12:35:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: debugobjects: fill_pool() returns void now
has been removed from the -mm tree.  Its filename was
     debugobjects-fill_pool-returns-void-now.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: debugobjects: fill_pool() returns void now

There was a return missed in 1fda107d44 "debugobjects: Remove unused
return value from fill_pool()".  It makes gcc complain:

	lib/debugobjects.c: In function `fill_pool':
	lib/debugobjects.c:98:4: warning: `return' with a value, in
		function returning void [enabled by default]

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/debugobjects.c~debugobjects-fill_pool-returns-void-now lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-fill_pool-returns-void-now
+++ a/lib/debugobjects.c
@@ -95,7 +95,7 @@ static void fill_pool(void)
 
 		new = kmem_cache_zalloc(obj_cache, gfp);
 		if (!new)
-			return obj_pool_free;
+			return;
 
 		raw_spin_lock_irqsave(&pool_lock, flags);
 		hlist_add_head(&new->node, &obj_pool);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
fsnotify-remove-unused-parameter-from-send_to_group.patch
drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch
hpfs-remove-printk-macro.patch

