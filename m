From: akpm@linux-foundation.org
Subject: + remove-bogus-qeth-type-check.patch added to -mm tree
Date: Thu, 11 Oct 2007 13:39:35 -0700
Message-ID: <200710112039.l9BKdZdL014553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511AbXJKUjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Oct 2007 16:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, davem@davemloft.net


The patch titled
     remove bogus qeth type check
has been added to the -mm tree.  Its filename is
     remove-bogus-qeth-type-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove bogus qeth type check
From: Stephen Hemminger <shemminger@linux-foundation.org>

Not sure why this crept in with hard-header-ops change.
Just kill it. Need to start doing cross-compiles for s390...

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/s390/net/qeth_main.c~remove-bogus-qeth-type-check drivers/s390/net/qeth_main.c
--- a/drivers/s390/net/qeth_main.c~remove-bogus-qeth-type-check
+++ a/drivers/s390/net/qeth_main.c
@@ -6581,9 +6581,6 @@ qeth_hard_header_parse(const struct sk_b
 	const struct qeth_card *card;
 	const struct ethhdr *eth;
 
-	if (dev->type != ARPHRD_IEEE802_TR)
-		return 0;
-
 	card = qeth_get_card_from_dev(skb->dev);
 	if (card->options.layer2)
 		goto haveheader;
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

git-infiniband.patch
git-input.patch
git-net.patch
remove-bogus-qeth-type-check.patch
git-wireless.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
