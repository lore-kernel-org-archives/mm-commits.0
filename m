From: akpm@linux-foundation.org
Subject: + epoll-cleanups-epoll-no-module.patch added to -mm tree
Date: Thu, 05 Apr 2007 18:03:38 -0700
Message-ID: <200704060103.l3613ciR031105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59830 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992849AbXDFBDk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 21:03:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org


The patch titled
     epoll cleanups: epoll no module
has been added to the -mm tree.  Its filename is
     epoll-cleanups-epoll-no-module.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: epoll cleanups: epoll no module
From: Davide Libenzi <davidel@xmailserver.org>

Epoll is either compiled it, or not (if EMBEDDED). Remove the module code
and use fs_initcall().

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   14 +-------------
 1 files changed, 1 insertion(+), 13 deletions(-)

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
epoll-optimizations-and-cleanups.patch
epoll-optimizations-and-cleanups-tidy.patch
signal-timer-event-fds-v9-anonymous-inode-source.patch
signal-timer-event-fds-v9-anonymous-inode-source-fix.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix-fix.patch
signal-timer-event-fds-v9-signalfd-wire-up-i386-arch.patch
signal-timer-event-fds-v9-signalfd-wire-up-x86_64-arch.patch
signal-timer-event-fds-v9-signalfd-compat-code.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-wire-up-i386-arch.patch
signal-timer-event-fds-v9-timerfd-wire-up-x86_64-arch.patch
signal-timer-event-fds-v9-timerfd-compat-code.patch
signal-timer-event-fds-v9-eventfd-core.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix-fix.patch
signal-timer-event-fds-v9-eventfd-wire-up-i386-arch.patch
signal-timer-event-fds-v9-eventfd-wire-up-x86_64-arch.patch
signal-timer-event-fds-v9-kaio-eventfd-support-example.patch
epoll-use-anonymous-inodes.patch
epoll-cleanups-epoll-no-module.patch
epoll-cleanups-epoll-remove-static-pre-declarations-and-akpm-ize-the-code.patch
