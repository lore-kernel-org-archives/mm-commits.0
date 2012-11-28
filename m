From: akpm@linux-foundation.org
Subject: + aoe-make-error-messages-more-specific-in-static-minor-allocation.patch added to -mm tree
Date: Wed, 28 Nov 2012 15:42:31 -0800
Message-ID: <20121128234232.014DC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:50207 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2K1Xme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 18:42:34 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so979245lbo.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 15:42:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: make error messages more specific in static minor allocation
has been added to the -mm tree.  Its filename is
     aoe-make-error-messages-more-specific-in-static-minor-allocation.patch

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
Subject: aoe: make error messages more specific in static minor allocation

For some special-purpose systems where udev isn't present, static
allocation of minor numbers is desirable.  This update distinguishes
different failure scenarios, to help the user understand what went wrong.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-make-error-messages-more-specific-in-static-minor-allocation drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-make-error-messages-more-specific-in-static-minor-allocation
+++ a/drivers/block/aoe/aoedev.c
@@ -69,25 +69,34 @@ minor_get_static(ulong *sysminor, ulong 
 		NPERSHELF = 16,
 	};
 
+	if (aoemin >= NPERSHELF) {
+		pr_err("aoe: %s %d slots per shelf\n",
+			"static minor device numbers support only",
+			NPERSHELF);
+		error = -1;
+		goto out;
+	}
+
 	n = aoemaj * NPERSHELF + aoemin;
-	if (aoemin >= NPERSHELF || n >= N_DEVS) {
+	if (n >= N_DEVS) {
 		pr_err("aoe: %s with e%ld.%d\n",
 			"cannot use static minor device numbers",
 			aoemaj, aoemin);
 		error = -1;
-	} else {
-		spin_lock_irqsave(&used_minors_lock, flags);
-		if (test_bit(n, used_minors)) {
-			pr_err("aoe: %s %lu\n",
-				"existing device already has static minor number",
-				n);
-			error = -1;
-		} else
-			set_bit(n, used_minors);
-		spin_unlock_irqrestore(&used_minors_lock, flags);
+		goto out;
 	}
 
+	spin_lock_irqsave(&used_minors_lock, flags);
+	if (test_bit(n, used_minors)) {
+		pr_err("aoe: %s %lu\n",
+			"existing device already has static minor number",
+			n);
+		error = -1;
+	} else
+		set_bit(n, used_minors);
+	spin_unlock_irqrestore(&used_minors_lock, flags);
 	*sysminor = n;
+out:
 	return error;
 }
 
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

