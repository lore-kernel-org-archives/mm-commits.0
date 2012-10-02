From: akpm@linux-foundation.org
Subject: + aoe-update-and-specify-aoe-address-guards-and-error-messages.patch added to -mm tree
Date: Tue, 02 Oct 2012 14:18:11 -0700
Message-ID: <20121002211811.EBE351E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:42214 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab2JBVSN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2012 17:18:13 -0400
Received: by qcqs25 with SMTP id s25so852301qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 02 Oct 2012 14:18:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: update and specify AoE address guards and error messages
has been added to the -mm tree.  Its filename is
     aoe-update-and-specify-aoe-address-guards-and-error-messages.patch

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
Subject: aoe: update and specify AoE address guards and error messages

In general, specific is better when it comes to messages about AoE usage
problems.  Also, explicit checks for the AoE broadcast addresses are
added.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    2 --
 drivers/block/aoe/aoecmd.c |   17 +++++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-and-specify-aoe-address-guards-and-error-messages drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-and-specify-aoe-address-guards-and-error-messages
+++ a/drivers/block/aoe/aoe.h
@@ -49,8 +49,6 @@ struct aoe_hdr {
 	__be32 tag;
 };
 
-#define AOE_MAXSHELF (0xffff-1)	/* one less than the broadcast shelf address */
-
 struct aoe_atahdr {
 	unsigned char aflags;
 	unsigned char errfeat;
diff -puN drivers/block/aoe/aoecmd.c~aoe-update-and-specify-aoe-address-guards-and-error-messages drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-update-and-specify-aoe-address-guards-and-error-messages
+++ a/drivers/block/aoe/aoecmd.c
@@ -1349,15 +1349,14 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 			"Check shelf dip switches.\n");
 		return;
 	}
-	if (aoemajor > AOE_MAXSHELF) {
-		pr_info("aoe: e%ld.%d: shelf number too large\n",
+	if (aoemajor == 0xffff) {
+		pr_info("aoe: e%ld.%d: broadcast shelf number invalid\n",
 			aoemajor, (int) h->minor);
 		return;
 	}
-
-	d = aoedev_by_aoeaddr(aoemajor, h->minor, 1);
-	if (d == NULL) {
-		pr_info("aoe: device allocation failure\n");
+	if (h->minor == 0xff) {
+		pr_info("aoe: e%ld.%d: broadcast slot number invalid\n",
+			aoemajor, (int) h->minor);
 		return;
 	}
 
@@ -1365,6 +1364,12 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	if (n > aoe_maxout)	/* keep it reasonable */
 		n = aoe_maxout;
 
+	d = aoedev_by_aoeaddr(aoemajor, h->minor, 1);
+	if (d == NULL) {
+		pr_info("aoe: device allocation failure\n");
+		return;
+	}
+
 	spin_lock_irqsave(&d->lock, flags);
 
 	t = gettgt(d, h->src);
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-for-performance-support-larger-packet-payloads.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch
aoe-become-i-o-request-queue-handler-for-increased-user-control.patch
aoe-use-a-kernel-thread-for-transmissions.patch
aoe-use-packets-that-work-with-the-smallest-mtu-local-interface.patch
aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter.patch
aoe-do-revalidation-steps-in-order.patch
aoe-disallow-unsupported-aoe-minor-addresses.patch
aoe-associate-frames-with-the-aoe-storage-target.patch
aoe-increase-net_device-reference-count-while-using-it.patch
aoe-remove-unused-code-and-add-cosmetic-improvements.patch
aoe-update-internal-version-number-to-49.patch
aoe-update-copyright-year-in-touched-files.patch
aoe-update-documentation-with-new-url-and-vm-settings-reference.patch
aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers.patch
aoe-retain-static-block-device-numbers-for-backwards-compatibility.patch
aoe-update-and-specify-aoe-address-guards-and-error-messages.patch
aoe-make-dynamic-block-minor-numbers-the-default.patch
aoe-remove-unused-code.patch
aoe-update-documentation-to-better-reflect-aoe-plus-udev-usage.patch
aoe-update-aoe-internal-version-number-to-50.patch

