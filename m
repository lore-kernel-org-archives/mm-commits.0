From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch removed
 from -mm tree
Date: Fri, 19 Sep 2014 23:26:33 -0700
Message-ID: <541d1e19.UBnhTspvs8H8bZQS%akpm__18922.6518189118$1411194409$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaITG0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 20 Sep 2014 02:26:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/balloon_compaction: isolate balloon pages without lru_lock
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: mm/balloon_compaction: isolate balloon pages without lru_lock

LRU-lock isn't required for balloon page isolation.  This check makes
migration of some ballooned pages mostly impossible because
isolate_migratepages_range() drops LRU lock periodically.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: <stable@vger.kernel.org>	[v3.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-balloon_compaction-isolate-balloon-pages-without-lru_lock mm/compaction.c
--- a/mm/compaction.c~mm-balloon_compaction-isolate-balloon-pages-without-lru_lock
+++ a/mm/compaction.c
@@ -643,7 +643,7 @@ isolate_migratepages_block(struct compac
 		 */
 		if (!PageLRU(page)) {
 			if (unlikely(balloon_page_movable(page))) {
-				if (locked && balloon_page_isolate(page)) {
+				if (balloon_page_isolate(page)) {
 					/* Successfully isolated */
 					goto isolate_success;
 				}
_

Patches currently in -mm which might be from k.khlebnikov@samsung.com are

include-linux-migrateh-remove-migratepage-define.patch
mm-introduce-common-page-state-for-ballooned-memory.patch
mm-balloon_compaction-use-common-page-ballooning.patch
mm-balloon_compaction-general-cleanup.patch
linux-next.patch

