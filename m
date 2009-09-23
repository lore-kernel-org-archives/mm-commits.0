From: akpm@linux-foundation.org
Subject: [merged] ramfs-move-ramfs_magic-to-include-linux-magich.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:21 -0700
Message-ID: <200909231957.n8NJvLfC006723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743AbZIWT55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: max@stro.at, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     ramfs: move RAMFS_MAGIC to include/linux/magic.h
has been removed from the -mm tree.  Its filename was
     ramfs-move-ramfs_magic-to-include-linux-magich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
