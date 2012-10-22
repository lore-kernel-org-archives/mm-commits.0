From: akpm@linux-foundation.org
Subject: [merged] lib-dma-debugc-fix-__hash_bucket_find.patch removed from -mm tree
Date: Mon, 22 Oct 2012 12:13:40 -0700
Message-ID: <20121022191340.C22BC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:53524 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2JVTNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 15:13:41 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so376696ggm.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 12:13:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ming.lei@canonical.com, fengguang.wu@intel.com, joerg.roedel@amd.com, kubakici@wp.pl, paul.gortmaker@windriver.com, shuah.khan@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dma-debug.c: fix __hash_bucket_find()
has been removed from the -mm tree.  Its filename was
     lib-dma-debugc-fix-__hash_bucket_find.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


