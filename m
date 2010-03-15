From: akpm@linux-foundation.org
Subject: [merged] sysctl-extern-cleanup-poll.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:05:19 -0400
Message-ID: <201003150705.o2F75qOj017122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933035Ab0COHFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: poll
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-poll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: poll
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

Move epoll_table extern declaration to linux/poll.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poll.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/poll.h~sysctl-extern-cleanup-poll include/linux/poll.h
--- a/include/linux/poll.h~sysctl-extern-cleanup-poll
+++ a/include/linux/poll.h
@@ -10,8 +10,10 @@
 #include <linux/wait.h>
 #include <linux/string.h>
 #include <linux/fs.h>
+#include <linux/sysctl.h>
 #include <asm/uaccess.h>
 
+extern struct ctl_table epoll_table[]; /* for sysctl */
 /* ~832 bytes of stack space used max in sys_select/sys_poll before allocating
    additional memory. */
 #define MAX_STACK_ALLOC 832
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
linux-next.patch

