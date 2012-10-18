From: akpm@linux-foundation.org
Subject: + lib-dma-debugc-fix-__hash_bucket_find.patch added to -mm tree
Date: Thu, 18 Oct 2012 12:03:56 -0700
Message-ID: <20121018190356.BED6F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43764 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2JRTD7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 15:03:59 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so253987qae.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 12:03:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ming.lei@canonical.com, fengguang.wu@intel.com, joerg.roedel@amd.com, kubakici@wp.pl, paul.gortmaker@windriver.com, shuah.khan@hp.com


The patch titled
     Subject: lib/dma-debug.c: fix __hash_bucket_find()
has been added to the -mm tree.  Its filename is
     lib-dma-debugc-fix-__hash_bucket_find.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ming Lei <ming.lei@canonical.com>
Subject: lib/dma-debug.c: fix __hash_bucket_find()

If there is only one match, the unique matched entry should be returned.

Without the fix, the f62566214fe ("dma-debug: new interfaces to debug dma
mapping errors") can't work reliably because only device and dma_addr are
passed to dma_mapping_error().

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Tested-by: Shuah Khan <shuah.khan@hp.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/dma-debug.c~lib-dma-debugc-fix-__hash_bucket_find lib/dma-debug.c
--- a/lib/dma-debug.c~lib-dma-debugc-fix-__hash_bucket_find
+++ a/lib/dma-debug.c
@@ -264,7 +264,7 @@ static struct dma_debug_entry *__hash_bu
 						  match_fn match)
 {
 	struct dma_debug_entry *entry, *ret = NULL;
-	int matches = 0, match_lvl, last_lvl = 0;
+	int matches = 0, match_lvl, last_lvl = -1;
 
 	list_for_each_entry(entry, &bucket->list, list) {
 		if (!match(ref, entry))
@@ -293,7 +293,7 @@ static struct dma_debug_entry *__hash_bu
 		} else if (match_lvl > last_lvl) {
 			/*
 			 * We found an entry that fits better then the
-			 * previous one
+			 * previous one or it is the 1st match.
 			 */
 			last_lvl = match_lvl;
 			ret      = entry;
_

Patches currently in -mm which might be from ming.lei@canonical.com are

lib-dma-debugc-fix-__hash_bucket_find.patch
linux-next.patch

