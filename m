From: akpm@linux-foundation.org
Subject: + looph-build-fix.patch added to -mm tree
Date: Mon, 23 Jul 2007 17:24:42 -0700
Message-ID: <200707240024.l6O0Ogbt019621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbXGXAZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 20:25:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, jens.axboe@oracle.com, sebastian@breakpoint.cc


The patch titled
     loop.h build fix
has been added to the -mm tree.  Its filename is
     looph-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: loop.h build fix
From: Arnd Bergmann <arnd@arndb.de>

include/linux/loop.h:66: error: expected specifier-qualifier-list before 'request_queue_t'

Cc: Sebastian Siewior <sebastian@breakpoint.cc>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/loop.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/loop.h~looph-build-fix include/linux/loop.h
--- a/include/linux/loop.h~looph-build-fix
+++ a/include/linux/loop.h
@@ -63,7 +63,7 @@ struct loop_device {
 	struct task_struct	*lo_thread;
 	wait_queue_head_t	lo_event;
 
-	request_queue_t		*lo_queue;
+	struct request_queue	*lo_queue;
 	struct gendisk		*lo_disk;
 	struct list_head	lo_list;
 };
_

Patches currently in -mm which might be from arnd@arndb.de are

looph-build-fix.patch
whitespace-fixes-compat-syscalls.patch
