From: akpm@linux-foundation.org
Subject: + aoe-remove-call-to-request-handler-from-i-o-completion.patch added to -mm tree
Date: Wed, 28 Nov 2012 15:42:26 -0800
Message-ID: <20121128234227.BA0D0200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:58684 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab2K1Xma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 18:42:30 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so841451bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 15:42:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: remove call to request handler from I/O completion
has been added to the -mm tree.  Its filename is
     aoe-remove-call-to-request-handler-from-i-o-completion.patch

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
Subject: aoe: remove call to request handler from I/O completion

There is no need to call the request handler function in the I/O
completion routine.  The user impact of not doing it is a more "nice" aoe
driver that is less susceptible to causing soft lockups.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-remove-call-to-request-handler-from-i-o-completion drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-remove-call-to-request-handler-from-i-o-completion
+++ a/drivers/block/aoe/aoecmd.c
@@ -1139,8 +1139,6 @@ badrsp:
 	if (buf && --buf->nframesout == 0 && buf->resid == 0)
 		aoe_end_buf(d, buf);
 
-	aoecmd_work(d);
-
 	spin_unlock_irq(&d->lock);
 	aoedev_put(d);
 	dev_kfree_skb(skb);
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-next.patch
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
aoe-provide-ata-identify-device-content-to-user-on-request.patch
aoe-improve-network-congestion-handling.patch
aoe-err-device-include-mac-addresses-for-unexpected-responses.patch
aoe-manipulate-aoedev-network-stats-under-lock.patch
aoe-use-high-resolution-rtts-with-fallback-to-low-res.patch
aoe-commands-in-retransmit-queue-use-new-destination-on-failure.patch
aoe-update-driver-internal-version-to-64.patch
aoe-copy-fallback-timing-information-on-destination-failover.patch
aoe-remove-vestigial-request-queue-allocation.patch
aoe-increase-default-cap-on-outstanding-aoe-commands-in-the-network.patch
aoe-cleanup-correct-comment-for-aoetgt-nout.patch
aoe-remove-call-to-request-handler-from-i-o-completion.patch
aoe-make-error-messages-more-specific-in-static-minor-allocation.patch
aoe-initialize-sysminor-to-avoid-compiler-warning.patch
aoe-return-real-minor-number-for-static-minors.patch

