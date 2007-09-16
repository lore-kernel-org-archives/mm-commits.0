From: akpm@linux-foundation.org
Subject: - fix-build-with-config_compat=y-and-config_block=n.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:43 -0700
Message-ID: <200709160926.l8G9QhEi009202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58974 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056AbXIPJi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aherrman@arcor.de, agk@redhat.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Fix build with CONFIG_COMPAT=y and CONFIG_BLOCK=n
has been removed from the -mm tree.  Its filename was
     fix-build-with-config_compat=y-and-config_block=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix build with CONFIG_COMPAT=y and CONFIG_BLOCK=n
From: Andreas Herrmann <aherrman@arcor.de>

Due to commit 02a5e0acb3cb85d80d0fe834e366d38a92bbaa22
kernel build is broken if (CONFIG_COMPAT && ! CONFIG_BLOCK):

  CC      fs/compat_ioctl.o
In file included from include/linux/raid/md_k.h:19,
                 from include/linux/raid/md.h:54,
                 from fs/compat_ioctl.c:25:
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:40: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:48: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h:51: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:64: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_merge_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:78: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:90: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h:94: error: dereferencing pointer to incomplete type
make[1]: *** [fs/compat_ioctl.o] Error 1
make: *** [fs] Error 2

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Acked-By: David Howells <dhowells@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-bio-list.h |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/md/dm-bio-list.h~fix-build-with-config_compat=y-and-config_block=n drivers/md/dm-bio-list.h
--- a/drivers/md/dm-bio-list.h~fix-build-with-config_compat=y-and-config_block=n
+++ a/drivers/md/dm-bio-list.h
@@ -9,6 +9,8 @@
 
 #include <linux/bio.h>
 
+#ifdef CONFIG_BLOCK
+
 struct bio_list {
 	struct bio *head;
 	struct bio *tail;
@@ -106,4 +108,5 @@ static inline struct bio *bio_list_get(s
 	return bio;
 }
 
+#endif /* CONFIG_BLOCK */
 #endif
_

Patches currently in -mm which might be from aherrman@arcor.de are

origin.patch
