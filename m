From: akpm@linux-foundation.org
Subject: + debugobjects-fill_pool-returns-void-now.patch added to -mm tree
Date: Wed, 18 Apr 2012 16:01:53 -0700
Message-ID: <20120418230153.AAA63A0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65185 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2DRXBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Apr 2012 19:01:54 -0400
Received: by yenq2 with SMTP id q2so915577yen.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Apr 2012 16:01:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, tglx@linutronix.de


The patch titled
     Subject: debugobjects: fill_pool() returns void now
has been added to the -mm tree.  Its filename is
     debugobjects-fill_pool-returns-void-now.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: debugobjects: fill_pool() returns void now

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
debugobjects-fill_pool-returns-void-now.patch
fsnotify-remove-unused-parameter-from-send_to_group.patch
drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch
hpfs-remove-printk-macro.patch

