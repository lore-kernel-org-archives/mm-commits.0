From: akpm@linux-foundation.org
Subject: + aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch added to -mm tree
Date: Wed, 17 Oct 2012 15:10:34 -0700
Message-ID: <20121017221035.2F32A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:49039 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2JQWKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 18:10:36 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so1005723yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 15:10:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: print warning regarding a common reason for dropped transmits
has been added to the -mm tree.  Its filename is
     aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: print warning regarding a common reason for dropped transmits

Dropped transmits are not common, but when they do occur, increasing
the transmit queue length often helps.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoenet.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoenet.c~aoe-print-warning-regarding-a-common-reason-for-dropped-transmits drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-print-warning-regarding-a-common-reason-for-dropped-transmits
+++ a/drivers/block/aoe/aoenet.c
@@ -50,7 +50,11 @@ __setup("aoe_iflist=", aoe_iflist_setup)
 static spinlock_t txlock;
 static struct sk_buff_head skbtxq;
 
-/* enters with txlock held */
+/* enters with txlock held
+ *
+ * Use __must_hold(&txlock) for sparse when upcoming patch adds it to
+ * compiler.h.
+ */
 static int
 tx(void)
 {
@@ -58,7 +62,10 @@ tx(void)
 
 	while ((skb = skb_dequeue(&skbtxq))) {
 		spin_unlock_irq(&txlock);
-		dev_queue_xmit(skb);
+		if (dev_queue_xmit(skb) == NET_XMIT_DROP && net_ratelimit())
+			pr_warn("aoe: packet could not be sent on %s.  %s\n",
+				skb->dev ? skb->dev->name : "netif",
+				"consider increasing tx_queue_len");
 		spin_lock_irq(&txlock);
 	}
 	return 0;
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch

