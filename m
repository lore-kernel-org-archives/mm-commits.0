From: akpm@linux-foundation.org
Subject: + aoe-err-device-include-mac-addresses-for-unexpected-responses.patch added to -mm tree
Date: Thu, 08 Nov 2012 11:26:49 -0800
Message-ID: <20121108192650.A5C5220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:36632 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab2KHT0x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 14:26:53 -0500
Received: by mail-la0-f74.google.com with SMTP id j13so204056lah.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 11:26:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: err device: include MAC addresses for unexpected responses
has been added to the -mm tree.  Its filename is
     aoe-err-device-include-mac-addresses-for-unexpected-responses.patch

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
Subject: aoe: err device: include MAC addresses for unexpected responses

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-err-device-include-mac-addresses-for-unexpected-responses drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-err-device-include-mac-addresses-for-unexpected-responses
+++ a/drivers/block/aoe/aoecmd.c
@@ -1204,12 +1204,14 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			spin_unlock_irqrestore(&d->lock, flags);
 			aoedev_put(d);
 			snprintf(ebuf, sizeof(ebuf),
-				 "%15s e%d.%d    tag=%08x@%08lx\n",
+				 "%15s e%d.%d    tag=%08x@%08lx s=%pm d=%pm\n",
 				 "unexpected rsp",
 				 get_unaligned_be16(&h->major),
 				 h->minor,
 				 get_unaligned_be32(&h->tag),
-				 jiffies);
+				 jiffies,
+				 h->src,
+				 h->dst);
 			aoechr_error(ebuf);
 			return skb;
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
aoe-avoid-running-request-handler-on-plugged-queue.patch
aoe-provide-ata-identify-device-content-to-user-on-request.patch
aoe-improve-network-congestion-handling.patch
aoe-err-device-include-mac-addresses-for-unexpected-responses.patch
aoe-manipulate-aoedev-network-stats-under-lock.patch
aoe-use-high-resolution-rtts-with-fallback-to-low-res.patch
aoe-commands-in-retransmit-queue-use-new-destination-on-failure.patch
aoe-update-driver-internal-version-to-64.patch

