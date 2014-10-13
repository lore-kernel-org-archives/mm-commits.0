From: akpm@linux-foundation.org
Subject: [merged]
 use-find_get_page_flags-to-mark-page-accessed-as-it-is-no-longer-marked-later-on.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:17:23 -0700
Message-ID: <543c1733.uZnrQWrEy6iFj4Yo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbaJMSRX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@tuxera.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: use find_get_page_flags() to mark page accessed as it is no longer marked later on
has been removed from the -mm tree.  Its filename was
     use-find_get_page_flags-to-mark-page-accessed-as-it-is-no-longer-marked-later-on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anton Altaparmakov <anton@tuxera.com>
Subject: ntfs: use find_get_page_flags() to mark page accessed as it is no longer marked later on

Mel Gorman's commit 2457aec63745 ("mm: non-atomically mark page accessed
during page cache allocation where possible") removed mark_page_accessed()
calls from NTFS without updating the matching find_lock_page() to
find_get_page_flags(GFP_LOCK | FGP_ACCESSED) thus causing the page to
never be marked accessed.

This patch fixes that.

Signed-off-by: Anton Altaparmakov <anton@tuxera.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c  |    5 +++--
 fs/ntfs/super.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/ntfs/file.c~use-find_get_page_flags-to-mark-page-accessed-as-it-is-no-longer-marked-later-on fs/ntfs/file.c
--- a/fs/ntfs/file.c~use-find_get_page_flags-to-mark-page-accessed-as-it-is-no-longer-marked-later-on
+++ a/fs/ntfs/file.c
@@ -1,7 +1,7 @@
 /*
  * file.c - NTFS kernel file operations.  Part of the Linux-NTFS project.
  *
- * Copyright (c) 2001-2011 Anton Altaparmakov and Tuxera Inc.
+ * Copyright (c) 2001-2014 Anton Altaparmakov and Tuxera Inc.
  *
  * This program/include file is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as published
@@ -410,7 +410,8 @@ static inline int __ntfs_grab_cache_page
 	BUG_ON(!nr_pages);
 	err = nr = 0;
 	do {
-		pages[nr] = find_lock_page(mapping, index);
+		pages[nr] = find_get_page_flags(mapping, index, FGP_LOCK |
+				FGP_ACCESSED);
 		if (!pages[nr]) {
 			if (!*cached_page) {
 				*cached_page = page_cache_alloc(mapping);
diff -puN fs/ntfs/super.c~use-find_get_page_flags-to-mark-page-accessed-as-it-is-no-longer-marked-later-on fs/ntfs/super.c
--- a/fs/ntfs/super.c~use-find_get_page_flags-to-mark-page-accessed-as-it-is-no-longer-marked-later-on
+++ a/fs/ntfs/super.c
@@ -3208,7 +3208,7 @@ static void __exit exit_ntfs_fs(void)
 }
 
 MODULE_AUTHOR("Anton Altaparmakov <anton@tuxera.com>");
-MODULE_DESCRIPTION("NTFS 1.2/3.x driver - Copyright (c) 2001-2011 Anton Altaparmakov and Tuxera Inc.");
+MODULE_DESCRIPTION("NTFS 1.2/3.x driver - Copyright (c) 2001-2014 Anton Altaparmakov and Tuxera Inc.");
 MODULE_VERSION(NTFS_VERSION);
 MODULE_LICENSE("GPL");
 #ifdef DEBUG
_

Patches currently in -mm which might be from anton@tuxera.com are

origin.patch

