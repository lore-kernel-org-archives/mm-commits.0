From: akpm@linux-foundation.org
Subject: [merged] lib-list_sort_test-add-extra-corruption-check.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:07:55 -0700
Message-ID: <53e3dc9b.SJpMwsxHttAd6vVI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:41812 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaHGUH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:56 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1177016pab.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: list_sort_test(): add extra corruption check
has been removed from the -mm tree.  Its filename was
     lib-list_sort_test-add-extra-corruption-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: list_sort_test(): add extra corruption check

Add a check to make sure that the prev pointer of the list head points
to the last element on the list.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Don Mullis <don.mullis@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN lib/list_sort.c~lib-list_sort_test-add-extra-corruption-check lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sort_test-add-extra-corruption-check
+++ a/lib/list_sort.c
@@ -272,6 +272,11 @@ static int __init list_sort_test(void)
 		}
 		count++;
 	}
+	if (head.prev != cur) {
+		printk(KERN_ERR "list_sort_test: error: list is corrupted\n");
+		goto exit;
+	}
+
 
 	if (count != TEST_LIST_LEN) {
 		printk(KERN_ERR "list_sort_test: error: bad list length %d",
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

