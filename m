From: akpm@linux-foundation.org
Subject: + mm-zswap-bugfix-memory-leak-when-re-swapon.patch added to -mm
 tree
Date: Thu, 10 Oct 2013 12:52:43 -0700
Message-ID: <5257058b.S43WhGGaccC6KRes%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab3JJTwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 15:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, minchan@kernel.org, bob.liu@oracle.com, weijie.yang@samsung.com

Subject: + mm-zswap-bugfix-memory-leak-when-re-swapon.patch added to -mm tree
To: weijie.yang@samsung.com,bob.liu@oracle.com,minchan@kernel.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 12:52:43 -0700


The patch titled
     Subject: mm/zswap: bugfix: memory leak when re-swapon
has been added to the -mm tree.  Its filename is
     mm-zswap-bugfix-memory-leak-when-re-swapon.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-bugfix-memory-leak-when-re-swapon.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-bugfix-memory-leak-when-re-swapon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/zswap: bugfix: memory leak when re-swapon

zswap_tree is not freed when swapoff, and it got re-kmalloced in swapon,
so a memory leak occurs.

Free the memory of zswap_tree in zswap_frontswap_invalidate_area().

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/zswap.c~mm-zswap-bugfix-memory-leak-when-re-swapon mm/zswap.c
--- a/mm/zswap.c~mm-zswap-bugfix-memory-leak-when-re-swapon
+++ a/mm/zswap.c
@@ -804,6 +804,10 @@ static void zswap_frontswap_invalidate_a
 	}
 	tree->rbroot = RB_ROOT;
 	spin_unlock(&tree->lock);
+
+	zbud_destroy_pool(tree->pool);
+	kfree(tree);
+	zswap_trees[type] = NULL;
 }
 
 static struct zbud_ops zswap_zbud_ops = {
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

mm-zswap-bugfix-memory-leak-when-re-swapon.patch
mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently.patch
mm-zswap-avoid-unnecessary-page-scanning.patch

