From: akpm@linux-foundation.org
Subject: + aio-remove-init_kioctx.patch added to -mm tree
Date: Tue, 07 Apr 2009 14:04:18 -0700
Message-ID: <200904072104.n37L4INF028080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbZDGVFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 17:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     aio: remove INIT_KIOCTX
has been added to the -mm tree.  Its filename is
     aio-remove-init_kioctx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -14,19 +14,6 @@
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
