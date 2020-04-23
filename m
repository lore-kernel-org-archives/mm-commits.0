From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-fix-a-typo-in-the-regex-for-allocfunctions.patch removed from
 -mm tree
Date: Thu, 23 Apr 2020 12:51:41 -0700
Message-ID: <20200423195141.Lo5ML2TC9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDWTvm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 15:51:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix a typo in the regex for $allocFunctions
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-a-typo-in-the-regex-for-allocfunctions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: checkpatch: fix a typo in the regex for $allocFunctions

Here, we look for function such as 'netdev_alloc_skb_ip_align', so a '_'
is missing in the regex.

To make sure:
   grep -r --include=*.c skbip_a * | wc   ==>   0 results
   grep -r --include=*.c skb_ip_a * | wc  ==> 112 results

Link: http://lkml.kernel.org/r/20200407190029.892-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-a-typo-in-the-regex-for-allocfunctions
+++ a/scripts/checkpatch.pl
@@ -479,7 +479,7 @@ our $allocFunctions = qr{(?x:
 		(?:kv|k|v)[czm]alloc(?:_node|_array)? |
 		kstrdup(?:_const)? |
 		kmemdup(?:_nul)?) |
-	(?:\w+)?alloc_skb(?:ip_align)? |
+	(?:\w+)?alloc_skb(?:_ip_align)? |
 				# dev_alloc_skb/netdev_alloc_skb, et al
 	dma_alloc_coherent
 )};
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

lib-math-avoid-trailing-n-hidden-in-pr_fmt.patch
