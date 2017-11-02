From: akpm@linux-foundation.org
Subject: + mm-list_lru-mark-expected-switch-fall-through.patch added to
 -mm tree
Date: Thu, 02 Nov 2017 14:52:09 -0700
Message-ID: <59fb9389.ZkYRv+po9LDuKmaJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932201AbdKBVwK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 17:52:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: garsilva@embeddedor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: mark expected switch fall-through
has been added to the -mm tree.  Its filename is
     mm-list_lru-mark-expected-switch-fall-through.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-list_lru-mark-expected-switch-fall-through.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lru-mark-expected-switch-fall-through.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: mm/list_lru.c: mark expected switch fall-through

In preparation for enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Link: http://lkml.kernel.org/r/20171020190754.GA24332@embeddedor.com
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/list_lru.c~mm-list_lru-mark-expected-switch-fall-through mm/list_lru.c
--- a/mm/list_lru.c~mm-list_lru-mark-expected-switch-fall-through
+++ a/mm/list_lru.c
@@ -222,6 +222,7 @@ restart:
 		switch (ret) {
 		case LRU_REMOVED_RETRY:
 			assert_spin_locked(&nlru->lock);
+			/* fall through */
 		case LRU_REMOVED:
 			isolated++;
 			nlru->nr_items--;
_

Patches currently in -mm which might be from garsilva@embeddedor.com are

mm-shmem-mark-expected-switch-fall-through.patch
mm-list_lru-mark-expected-switch-fall-through.patch

