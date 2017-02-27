From: akpm@linux-foundation.org
Subject: [patch 48/78] scripts/spelling.txt: add "algined" pattern and fix typo instances
Date: Mon, 27 Feb 2017 14:29:01 -0800
Message-ID: <58b4a82d.SAmu+dgkt/FbSuFC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45686 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbdB0Wp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "algined" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  algined||aligned

While we are here, fix the "appplication" in the touched line in
drivers/block/loop.c.  Also, fix the "may not naturally ..." to
"may not be naturally ..." in the touched line in mm/page_alloc.

Link: http://lkml.kernel.org/r/1481573103-11329-9-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    2 +-
 mm/page_alloc.c      |    2 +-
 scripts/spelling.txt |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/block/loop.c~scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances drivers/block/loop.c
--- a/drivers/block/loop.c~scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances
+++ a/drivers/block/loop.c
@@ -186,7 +186,7 @@ static void __loop_update_dio(struct loo
 	 *
 	 * TODO: the above condition may be loosed in the future, and
 	 * direct I/O may be switched runtime at that time because most
-	 * of requests in sane appplications should be PAGE_SIZE algined
+	 * of requests in sane applications should be PAGE_SIZE aligned
 	 */
 	if (dio) {
 		if (queue_logical_block_size(lo->lo_queue) >= sb_bsize &&
diff -puN mm/page_alloc.c~scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances mm/page_alloc.c
--- a/mm/page_alloc.c~scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances
+++ a/mm/page_alloc.c
@@ -5925,7 +5925,7 @@ static unsigned long __paginginit calc_m
 	 * the zone and SPARSEMEM is in use. If there are holes within the
 	 * zone, each populated memory region may cost us one or two extra
 	 * memmap pages due to alignment because memmap pages for each
-	 * populated regions may not naturally algined on page boundary.
+	 * populated regions may not be naturally aligned on page boundary.
 	 * So the (present_pages >> 4) heuristic is a tradeoff for that.
 	 */
 	if (spanned_pages > present_pages + (present_pages >> 4) &&
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -65,6 +65,7 @@ afecting||affecting
 agaist||against
 albumns||albums
 alegorical||allegorical
+algined||aligned
 algorith||algorithm
 algorithmical||algorithmically
 algoritm||algorithm
_
