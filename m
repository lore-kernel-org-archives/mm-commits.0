From: akpm@linux-foundation.org
Subject: + aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-fix.patch added to -mm tree
Date: Wed, 24 Oct 2012 15:19:26 -0700
Message-ID: <20121024221926.F397E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:64380 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161238Ab2JXWT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 18:19:29 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so63551bkw.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 15:19:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, dan.carpenter@oracle.com


The patch titled
     Subject: aoe: avoid using skb member after dev_queue_xmit
has been added to the -mm tree.  Its filename is
     aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-fix.patch

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
Subject: aoe: avoid using skb member after dev_queue_xmit

After calling dev_queue_xmit it is no longer safe to access the
members of the skb.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoenet.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoenet.c~aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-fix drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-fix
+++ a/drivers/block/aoe/aoenet.c
@@ -55,12 +55,14 @@ static int
 tx(void) __must_hold(&txlock)
 {
 	struct sk_buff *skb;
+	struct net_device *ifp;
 
 	while ((skb = skb_dequeue(&skbtxq))) {
 		spin_unlock_irq(&txlock);
+		ifp = skb->dev;
 		if (dev_queue_xmit(skb) == NET_XMIT_DROP && net_ratelimit())
 			pr_warn("aoe: packet could not be sent on %s.  %s\n",
-				skb->dev ? skb->dev->name : "netif",
+				ifp ? ifp->name : "netif",
 				"consider increasing tx_queue_len");
 		spin_lock_irq(&txlock);
 	}
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
documentation-sparsetxt-document-context-annotations-for-lock-checking.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-fix.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch

