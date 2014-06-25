From: akpm@linux-foundation.org
Subject: + lib-list_sort_test-add-extra-corruption-check.patch added to
 -mm tree
Date: Wed, 25 Jun 2014 14:44:07 -0700
Message-ID: <53ab42a7.EI+OmZFL/KKgYABG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaFYVoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 17:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: list_sort_test(): add extra corruption check
has been added to the -mm tree.  Its filename is
     lib-list_sort_test-add-extra-corruption-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-list_sort_test-add-extra-corruption-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-list_sort_test-add-extra-corruption-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
lib-list_sort_test-return-enomem-when-allocation-fails.patch
lib-list_sort_test-add-extra-corruption-check.patch
lib-list_sort_test-simplify-and-harden-cleanup.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
linux-next.patch
lib-list_sortc-limit-number-of-unused-cmp-callbacks.patch

