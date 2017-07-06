From: akpm@linux-foundation.org
Subject: [patch 099/108] mm/zswap.c: improve a size determination
 in zswap_frontswap_init()
Date: Thu, 06 Jul 2017 15:40:37 -0700
Message-ID: <20170706224037.yt41WnkLn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37066 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753025AbdGFWko (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:40:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ddstreet@ieee.org, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, sjenning@redhat.com, torvalds@linux-foundation.org

From: Markus Elfring <elfring@users.sourceforge.net>
Subject: mm/zswap.c: improve a size determination in zswap_frontswap_init()

Replace the specification of a data structure by a pointer dereference as
the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Link: http://lkml.kernel.org/r/19f9da22-092b-f867-bdf6-f4dbad7ccf1f@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zswap.c~zswap-improve-a-size-determination-in-zswap_frontswap_init mm/zswap.c
--- a/mm/zswap.c~zswap-improve-a-size-determination-in-zswap_frontswap_init
+++ a/mm/zswap.c
@@ -1156,7 +1156,7 @@ static void zswap_frontswap_init(unsigne
 {
 	struct zswap_tree *tree;
 
-	tree = kzalloc(sizeof(struct zswap_tree), GFP_KERNEL);
+	tree = kzalloc(sizeof(*tree), GFP_KERNEL);
 	if (!tree) {
 		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
 		return;
_
