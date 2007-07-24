From: akpm@linux-foundation.org
Subject: - looph-build-fix.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:24:58 -0700
Message-ID: <200707242324.l6ONOweU006319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42432 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756992AbXGXXZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, jens.axboe@oracle.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     loop.h build fix
has been removed from the -mm tree.  Its filename was
     looph-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
whitespace-fixes-compat-syscalls.patch
