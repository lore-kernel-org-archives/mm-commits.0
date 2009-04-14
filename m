From: akpm@linux-foundation.org
Subject: [merged] aio-remove-init_kioctx.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:54 -0700
Message-ID: <200904141948.n3EJms83019269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754340AbZDNTuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     aio: remove INIT_KIOCTX
has been removed from the -mm tree.  Its filename was
     aio-remove-init_kioctx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: remove INIT_KIOCTX
From: Alexey Dobriyan <adobriyan@gmail.com>

Unused after 20dcae32439384b6863c626bb3b2a09bed65b33e aka
"[PATCH] aio: remove kioctx from mm_struct".

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN include/linux/init_task.h~aio-remove-init_kioctx include/linux/init_task.h
--- a/include/linux/init_task.h~aio-remove-init_kioctx
+++ a/include/linux/init_task.h
@@ -15,19 +15,6 @@
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
-#define INIT_KIOCTX(name, which_mm) \
-{							\
-	.users		= ATOMIC_INIT(1),		\
-	.dead		= 0,				\
-	.mm		= &which_mm,			\
-	.user_id	= 0,				\
-	.next		= NULL,				\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER(name.wait), \
-	.ctx_lock	= __SPIN_LOCK_UNLOCKED(name.ctx_lock), \
-	.reqs_active	= 0U,				\
-	.max_reqs	= ~0U,				\
-}
