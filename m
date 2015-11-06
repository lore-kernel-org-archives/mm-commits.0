From: akpm@linux-foundation.org
Subject: [merged] mm-correct-a-couple-of-page-migration-comments.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:16:37 -0800
Message-ID: <563d0aa5.7uzp0ZoXyBz/ecBY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032241AbbKFUQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aquini@redhat.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: correct a couple of page migration comments
has been removed from the -mm tree.  Its filename was
     mm-correct-a-couple-of-page-migration-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: correct a couple of page migration comments

It's migrate.c not migration,c, and nowadays putback_movable_pages() not
putback_lru_pages().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-correct-a-couple-of-page-migration-comments mm/migrate.c
--- a/mm/migrate.c~mm-correct-a-couple-of-page-migration-comments
+++ a/mm/migrate.c
@@ -1,5 +1,5 @@
 /*
- * Memory Migration functionality - linux/mm/migration.c
+ * Memory Migration functionality - linux/mm/migrate.c
  *
  * Copyright (C) 2006 Silicon Graphics, Inc., Christoph Lameter
  *
@@ -1113,7 +1113,7 @@ out:
  *
  * The function returns after 10 attempts or if no pages are movable any more
  * because the list has become empty or no retryable pages exist any more.
- * The caller should call putback_lru_pages() to return pages to the LRU
+ * The caller should call putback_movable_pages() to return pages to the LRU
  * or free list only if ret != 0.
  *
  * Returns the number of pages that were not migrated, or an error code.
_

Patches currently in -mm which might be from hughd@google.com are

osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch
mm-use-unsigned-int-for-page-order-fix-2.patch

