From: akpm@linux-foundation.org
Subject: + aoe-make-dynamic-block-minor-numbers-the-default.patch added to -mm tree
Date: Tue, 02 Oct 2012 14:18:14 -0700
Message-ID: <20121002211815.5DB6A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:63569 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab2JBVSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2012 17:18:16 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so413606wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 02 Oct 2012 14:18:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: make dynamic block minor numbers the default
has been added to the -mm tree.  Its filename is
     aoe-make-dynamic-block-minor-numbers-the-default.patch

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
Subject: aoe: make dynamic block minor numbers the default

Because udev use is so widespread, making the old static mapping the
default is too conservative, given the severe limitations it places on
usable AoE addresses.  Storage virtualization and larger shelves have made
the old limitations too confining.

These changes make the dynamic block device minor numbers the default,
removing the limitations on usable AoE addresses.

The static arrangement is still available with aoe_dyndevs=0, and the
aoe-stat tool from the userland aoetools package, the user space
counterpart to the aoe driver, recognizes the case where there is a
mismatch between the minor number in sysfs and the minor number in a
special device file.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-make-dynamic-block-minor-numbers-the-default drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-make-dynamic-block-minor-numbers-the-default
+++ a/drivers/block/aoe/aoedev.c
@@ -19,7 +19,7 @@ static void aoedev_freedev(struct aoedev
 static void freetgt(struct aoedev *d, struct aoetgt *t);
 static void skbpoolfree(struct aoedev *d);
 
-static int aoe_dyndevs;
+static int aoe_dyndevs = 1;
 module_param(aoe_dyndevs, int, 0644);
 MODULE_PARM_DESC(aoe_dyndevs, "Use dynamic minor numbers for devices.");
 
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

