From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-eventfd-core-fix-fix-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:33:17 -0700
Message-ID: <200704302033.l3UKXIWr014363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946779AbXD3UdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:33:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     new fds fixes for 2.6.21-rc5.mm4 - eventfd include files diet
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-eventfd-core-fix-fix-fix.patch

This patch was dropped because it was folded into signal-timer-event-fds-v9-eventfd-core.patch

------------------------------------------------------
Subject: new fds fixes for 2.6.21-rc5.mm4 - eventfd include files diet
From: Davide Libenzi <davidel@xmailserver.org>

Removes a few unneeded include files from the eventfd code.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/eventfd.c~signal-timer-event-fds-v9-eventfd-core-fix-fix-fix fs/eventfd.c
--- a/fs/eventfd.c~signal-timer-event-fds-v9-eventfd-core-fix-fix-fix
+++ a/fs/eventfd.c
@@ -7,20 +7,15 @@
 
 #include <linux/file.h>
 #include <linux/poll.h>
-#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
-#include <linux/jiffies.h>
 #include <linux/anon_inodes.h>
 #include <linux/eventfd.h>
 
-#include <asm/uaccess.h>
-
 struct eventfd_ctx {
 	spinlock_t lock;
 	wait_queue_head_t wqh;
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-optimizations-and-cleanups.patch
introduce-a-handy-list_first_entry-macro-v2.patch
signal-timer-event-fds-v9-anonymous-inode-source.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-signalfd-wire-up-x86-arches.patch
signal-timer-event-fds-v9-signalfd-compat-code.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-timerfd-wire-up-x86-arches.patch
signal-timer-event-fds-v9-timerfd-compat-code.patch
signal-timer-event-fds-v9-eventfd-core.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix-fix.patch
signal-timer-event-eventfd-wire-up-x86-arches.patch
signal-timer-event-fds-v9-kaio-eventfd-support-example.patch
epoll-use-anonymous-inodes.patch
epoll-cleanups-epoll-no-module.patch
epoll-cleanups-epoll-remove-static-pre-declarations-and-akpm-ize-the-code.patch
