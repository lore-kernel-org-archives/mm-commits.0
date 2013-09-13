From: akpm@linux-foundation.org
Subject: + ksm-remove-redundant-__gfp_zero-from-kcalloc.patch added to -mm tree
Date: Fri, 13 Sep 2013 14:48:03 -0700
Message-ID: <52338813.GbxjD3yrEYsjKsu2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3IMVsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:48:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com, joe@perches.com

Subject: + ksm-remove-redundant-__gfp_zero-from-kcalloc.patch added to -mm tree
To: joe@perches.com,liwanp@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:48:03 -0700


The patch titled
     Subject: ksm: Remove redundant __GFP_ZERO from kcalloc
has been added to the -mm tree.  Its filename is
     ksm-remove-redundant-__gfp_zero-from-kcalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-remove-redundant-__gfp_zero-from-kcalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ksm: Remove redundant __GFP_ZERO from kcalloc

kcalloc returns zeroed memory.  There's no need to use this flag.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/ksm.c~ksm-remove-redundant-__gfp_zero-from-kcalloc mm/ksm.c
--- a/mm/ksm.c~ksm-remove-redundant-__gfp_zero-from-kcalloc
+++ a/mm/ksm.c
@@ -2309,8 +2309,8 @@ static ssize_t merge_across_nodes_store(
 			 * Allocate stable and unstable together:
 			 * MAXSMP NODES_SHIFT 10 will use 16kB.
 			 */
-			buf = kcalloc(nr_node_ids + nr_node_ids,
-				sizeof(*buf), GFP_KERNEL | __GFP_ZERO);
+			buf = kcalloc(nr_node_ids + nr_node_ids, sizeof(*buf),
+				      GFP_KERNEL);
 			/* Let us assume that RB_ROOT is NULL is zero */
 			if (!buf)
 				err = -ENOMEM;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
linux-next.patch

