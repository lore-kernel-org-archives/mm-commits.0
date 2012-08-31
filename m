From: akpm@linux-foundation.org
Subject: + aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter.patch added to -mm tree
Date: Fri, 31 Aug 2012 13:11:52 -0700
Message-ID: <20120831201153.A2C0D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:33376 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755Ab2HaUL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2012 16:11:56 -0400
Received: by lagw12 with SMTP id w12so172246lag.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 13:11:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: failover remote interface based on aoe_deadsecs parameter
has been added to the -mm tree.  Its filename is
     aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter.patch

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
Subject: aoe: failover remote interface based on aoe_deadsecs parameter

The aoe_deadsecs module parameter allows the user to specify a hard limit
on the number of seconds an AoE command can be retransmitted before the
AoE block device is considered to have failed.

Using aoe_deadsecs to determine the time we try using a different remote
interface helps to ensure that the hard limit is not reached before we've
tried to recover by sending to a different remote port.

As a data storage target, the AoE target is unambiguously identified by
its {major, minor} AoE address tuple, and an AoE target can have multiple
MAC addresses.  However, note that "target" in the driver code and
comments means a {major, minor, MAC address} tuple, as in "somewhere to
send packets".

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    1 -
 drivers/block/aoe/aoecmd.c |    8 +++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter
+++ a/drivers/block/aoe/aoe.h
@@ -96,7 +96,6 @@ enum {
 	TIMERTICK = HZ / 10,
 	MINTIMER = HZ >> 2,
 	MAXTIMER = HZ << 1,
-	HELPWAIT = 20,
 };
 
 struct buf {
diff -puN drivers/block/aoe/aoecmd.c~aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter
+++ a/drivers/block/aoe/aoecmd.c
@@ -632,11 +632,9 @@ rexmit_timer(ulong vp)
 		list_del(pos);
 
 		t = f->t;
-		if (n > HELPWAIT) {
-			/* see if another target can help */
-			if (d->ntargets > 1)
-				d->htgt = t;
-		}
+		if (n > aoe_deadsecs/2)
+			d->htgt = t; /* see if another target can help */
+
 		if (t->nout == t->maxout) {
 			if (t->maxout > 1)
 				t->maxout--;
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

