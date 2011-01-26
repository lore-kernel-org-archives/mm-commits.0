From: akpm@linux-foundation.org
Subject: [merged] mm-migration-clarify-migrate_pages-comment.patch removed from -mm tree
Date: Wed, 26 Jan 2011 12:32:44 -0800
Message-ID: <201101262032.p0QKWib4003215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109Ab1AZUcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 15:32:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, aarcange@redhat.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     mm: migration: clarify migrate_pages() comment
has been removed from the -mm tree.  Its filename was
     mm-migration-clarify-migrate_pages-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: migration: clarify migrate_pages() comment
From: Minchan Kim <minchan.kim@gmail.com>

Callers of migrate_pages should putback_lru_pages to return pages isolated
to LRU or free list.  Now comment is rather confusing.  It says caller
always have to call it.

It is more clear to point out that the caller has to call it if
migrate_pages's return value isn't zero.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migration-clarify-migrate_pages-comment mm/migrate.c
--- a/mm/migrate.c~mm-migration-clarify-migrate_pages-comment
+++ a/mm/migrate.c
@@ -888,7 +888,7 @@ out:
  * are movable anymore because to has become empty
  * or no retryable pages exist anymore.
  * Caller should call putback_lru_pages to return pages to the LRU
- * or free list.
+ * or free list only if ret != 0.
  *
  * Return: Number of pages not migrated or error code.
  */
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-vmap-area-cache.patch

