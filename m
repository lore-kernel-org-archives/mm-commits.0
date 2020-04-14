From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 checkpatch-fix-a-typo-in-the-regex-for-allocfunctions.patch added to -mm
 tree
Date: Mon, 13 Apr 2020 18:39:11 -0700
Message-ID: <20200414013911.MiowsGwwC%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbgDNBjM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 21:39:12 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix a typo in the regex for $allocFunctions
has been added to the -mm tree.  Its filename is
     checkpatch-fix-a-typo-in-the-regex-for-allocfunctions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-a-typo-in-the-regex-for-allocfunctions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-a-typo-in-the-regex-for-allocfunctions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
checkpatch-fix-a-typo-in-the-regex-for-allocfunctions.patch
