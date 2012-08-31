From: akpm@linux-foundation.org
Subject: + aoe-disallow-unsupported-aoe-minor-addresses.patch added to -mm tree
Date: Fri, 31 Aug 2012 13:11:58 -0700
Message-ID: <20120831201158.F0B701E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:35690 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab2HaUL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 16:11:59 -0400
Received: by yenq6 with SMTP id q6so383761yen.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 13:11:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: disallow unsupported AoE minor addresses
has been added to the -mm tree.  Its filename is
     aoe-disallow-unsupported-aoe-minor-addresses.patch

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
Subject: aoe: disallow unsupported AoE minor addresses

A guard is inserted to prevent AoE minor addresses (slot addresses) higher
than 15 to be used, as they are not yet supported by the driver.

There is a change coming that will allow the aoe driver to overcome this
limit by using system device minor numbers dynamically, but until then,
this guard prevents unexpected targets from being used by the driver when
AoE targets with high minor numbers are on the AoE network.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/block/aoe/aoecmd.c~aoe-disallow-unsupported-aoe-minor-addresses drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-disallow-unsupported-aoe-minor-addresses
+++ a/drivers/block/aoe/aoecmd.c
@@ -1359,6 +1359,13 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 			"Check shelf dip switches.\n");
 		return;
 	}
+	if (h->minor >= NPERSHELF) {
+		pr_err("aoe: e%ld.%d %s, %d\n",
+			aoemajor, h->minor,
+			"slot number larger than the maximum",
+			NPERSHELF-1);
+		return;
+	}
 
 	sysminor = SYSMINOR(aoemajor, h->minor);
 	if (sysminor * AOE_PARTITIONS + AOE_PARTITIONS > MINORMASK) {
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-for-performance-support-larger-packet-payloads.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking.patch
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

