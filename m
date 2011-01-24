From: akpm@linux-foundation.org
Subject: + mm-migration-clarify-migrate_pages-comment.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:13:09 -0800
Message-ID: <201101242213.p0OMD9R3013799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107Ab1AXWNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:13:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aarcange@redhat.com, cl@linux.com


The patch titled
     mm: migration: clarify migrate_pages() comment
has been added to the -mm tree.  Its filename is
     mm-migration-clarify-migrate_pages-comment.patch

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

thp-fix-paravirt-x86-32bit-nopae.patch
linux-next.patch
mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator.patch
mm-migration-clarify-migrate_pages-comment.patch
mm-vmap-area-cache.patch

