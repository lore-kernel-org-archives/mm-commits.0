From: akpm@linux-foundation.org
Subject: + aoe-copy-fallback-timing-information-on-destination-failover.patch added to -mm tree
Date: Wed, 28 Nov 2012 15:42:15 -0800
Message-ID: <20121128234216.3D668820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:61592 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab2K1XmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 18:42:17 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so582143ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 15:42:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: copy fallback timing information on destination failover
has been added to the -mm tree.  Its filename is
     aoe-copy-fallback-timing-information-on-destination-failover.patch

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
Subject: aoe: copy fallback timing information on destination failover

commit f3b8e07af7744cbb ("aoe: commands in retransmit queue use new
destination on failure") omits the copying of the coarse-grained time when
an AoE command was sent during the failover from one destination MAC
address on the AoE target to another.

The coarse-grained timing is only used when the system time changes or an
unlikely length of time has passed since the sending of the AoE command. 
Users will not be impacted unless their system clock is very inaccurate or
something unusual (e.g., 10 GbE link reset) happens during the period when
the aoe driver is handling the failure of a port on the AoE target.  Being
effected will mean that an AoE target could be considered "down" too
eagerly.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/aoe/aoecmd.c~aoe-copy-fallback-timing-information-on-destination-failover drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-copy-fallback-timing-information-on-destination-failover
+++ a/drivers/block/aoe/aoecmd.c
@@ -581,6 +581,7 @@ reassign_frame(struct list_head *pos)
 	nf->waited = 0;
 	nf->waited_total = f->waited_total;
 	nf->sent = f->sent;
+	nf->sent_jiffs = f->sent_jiffs;
 	f->skb = skb;
 	aoe_freetframe(f);
 	f->t->nout--;
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

