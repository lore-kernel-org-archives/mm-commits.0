From: akpm@linux-foundation.org
Subject: - epoll-cleanups-epoll-no-module.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:26 -0700
Message-ID: <200705120535.l4C5ZQt9002293@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756355AbXELFf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     epoll cleanups: epoll no module
has been removed from the -mm tree.  Its filename was
     epoll-cleanups-epoll-no-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: epoll cleanups: epoll no module
From: Davide Libenzi <davidel@xmailserver.org>

Epoll is either compiled it, or not (if EMBEDDED). Remove the module code
and use fs_initcall().

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN fs/eventpoll.c~epoll-cleanups-epoll-no-module fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-cleanups-epoll-no-module
+++ a/fs/eventpoll.c
@@ -11,7 +11,6 @@
  *
  */
 
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -1471,16 +1470,5 @@ static int __init eventpoll_init(void)
 
 	return 0;
 }
+fs_initcall(eventpoll_init);
 
-
-static void __exit eventpoll_exit(void)
-{
-	/* Undo all operations done inside eventpoll_init() */
-	kmem_cache_destroy(pwq_cache);
-	kmem_cache_destroy(epi_cache);
-}
-
-module_init(eventpoll_init);
-module_exit(eventpoll_exit);
-
-MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch
