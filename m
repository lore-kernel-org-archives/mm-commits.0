From: akpm@linux-foundation.org
Subject: + spidernet-remove-txram-full-logging.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:01:09 -0800
Message-ID: <200702251301.l1PD1Ba9029810@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964914AbXBYNBc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:01:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kou.ishizaki@toshiba.co.jp, linas@austin.ibm.com


The patch titled
     spidernet: remove txram full logging
has been added to the -mm tree.  Its filename is
     spidernet-remove-txram-full-logging.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spidernet: remove txram full logging
From: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>

This patch removes logging for SPIDER_NET_GTMFLLINT interrupts.  Since the
interrupts are not irregular, and they happen frequently when using 100Mbps
network switches.

Signed-off-by: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/spider_net.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-remove-txram-full-logging drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-remove-txram-full-logging
+++ a/drivers/net/spider_net.c
@@ -1422,8 +1422,8 @@ spider_net_handle_error_irq(struct spide
 				switch (i)
 	{
 	case SPIDER_NET_GTMFLLINT:
-		if (netif_msg_intr(card) && net_ratelimit())
-			pr_err("Spider TX RAM full\n");
+		/* TX RAM full may happen on a usual case.
+		 * Logging is not needed. */
 		show_error = 0;
 		break;
 	case SPIDER_NET_GRFDFLLINT: /* fallthrough */
_

Patches currently in -mm which might be from kou.ishizaki@toshiba.co.jp are

git-libata-all.patch
spidernet-autoneg-support-for-celleb.patch
spidernet-load-firmware-when-open.patch
spidernet-spidernet-add-support-for-celleb.patch
spidernet-remove-txram-full-logging.patch
spidernet-fix-racy-double-free-of-skb.patch
spidernet-maintainership.patch
