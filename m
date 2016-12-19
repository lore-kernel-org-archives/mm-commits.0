From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch added
 to -mm tree
Date: Mon, 19 Dec 2016 14:26:23 -0800
Message-ID: <58585e8f.eGp1xAyZ8yhgNUhf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43872 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcLSWZY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:25:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "algined" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -5764,7 +5764,7 @@ static unsigned long __paginginit calc_m
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

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

