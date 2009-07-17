From: akpm@linux-foundation.org
Subject: + ramfs-move-ramfs_magic-to-include-linux-magich.patch added to -mm tree
Date: Fri, 17 Jul 2009 16:52:13 -0700
Message-ID: <200907172352.n6HNqDwK009475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbZGQXwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 19:52:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: max@stro.at, hugh.dickins@tiscali.co.uk


The patch titled
     ramfs: move RAMFS_MAGIC to include/linux/magic.h
has been added to the -mm tree.  Its filename is
     ramfs-move-ramfs_magic-to-include-linux-magich.patch

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
Subject: ramfs: move RAMFS_MAGIC to include/linux/magic.h
From: maximilian attems <max@stro.at>

initramfs userspace likes to use this magic number.

Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c      |    4 +---
 include/linux/magic.h |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ramfs/inode.c~ramfs-move-ramfs_magic-to-include-linux-magich fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~ramfs-move-ramfs_magic-to-include-linux-magich
+++ a/fs/ramfs/inode.c
@@ -34,12 +34,10 @@
 #include <linux/ramfs.h>
 #include <linux/sched.h>
 #include <linux/parser.h>
+#include <linux/magic.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
-/* some random number */
-#define RAMFS_MAGIC	0x858458f6
