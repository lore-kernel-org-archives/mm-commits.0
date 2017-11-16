From: akpm@linux-foundation.org
Subject: [patch 122/131] mm/list_lru.c: mark expected switch
 fall-through
Date: Wed, 15 Nov 2017 17:38:49 -0800
Message-ID: <20171116013849.fFWj7vOOG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933297AbdKPBiu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:38:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, garsilva@embeddedor.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -221,6 +221,7 @@ restart:
 		switch (ret) {
 		case LRU_REMOVED_RETRY:
 			assert_spin_locked(&nlru->lock);
+			/* fall through */
 		case LRU_REMOVED:
 			isolated++;
 			nlru->nr_items--;
_
