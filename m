From: akpm@linux-foundation.org
Subject: + mm-migrate-support-non-lru-movable-page-migration-fix.patch
 added to -mm tree
Date: Mon, 20 Jun 2016 15:14:29 -0700
Message-ID: <57686ac5.Z8vPSrgpJMDZfFwp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbcFTWPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jun 2016 18:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, hillf.zj@alibaba-inc.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: remove local variable is_lru
has been added to the -mm tree.  Its filename is
     mm-migrate-support-non-lru-movable-page-migration-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-support-non-lru-movable-page-migration-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-support-non-lru-movable-page-migration-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/compaction: remove local variable is_lru

local varialbe is_lru was used for tracking non-lru pages(such as
balloon pages).

But Minchan Kim's patch [1] introduced a common framework
for non-lru page migration and moved the compound pages
check before non-lru movable pages check.

So there is no need to use local variable is_lru.

[1] https://lkml.org/lkml/2016/5/31/932

Link: http://lkml.kernel.org/r/20160618014841.GA7422@leo-test
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-migrate-support-non-lru-movable-page-migration-fix mm/compaction.c
--- a/mm/compaction.c~mm-migrate-support-non-lru-movable-page-migration-fix
+++ a/mm/compaction.c
@@ -710,7 +710,6 @@ isolate_migratepages_block(struct compac
 
 	/* Time to isolate some pages for migration */
 	for (; low_pfn < end_pfn; low_pfn++) {
-		bool is_lru;
 
 		if (skip_on_failure && low_pfn >= next_skip_pfn) {
 			/*
@@ -793,8 +792,7 @@ isolate_migratepages_block(struct compac
 		 * It's possible to migrate LRU and non-lru movable pages.
 		 * Skip any other type of page
 		 */
-		is_lru = PageLRU(page);
-		if (!is_lru) {
+		if (!PageLRU(page)) {
 			if (unlikely(balloon_page_movable(page))) {
 				if (balloon_page_isolate(page)) {
 					/* Successfully isolated */
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

mm-migrate-support-non-lru-movable-page-migration-fix.patch
mm-zsmalloc-add-trace-events-for-zs_compact.patch

