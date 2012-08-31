From: akpm@linux-foundation.org
Subject: + aoe-increase-net_device-reference-count-while-using-it.patch added to -mm tree
Date: Fri, 31 Aug 2012 13:12:04 -0700
Message-ID: <20120831201205.395C6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45458 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab2HaUMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 16:12:06 -0400
Received: by qafl39 with SMTP id l39so204555qaf.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 13:12:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: increase net_device reference count while using it
has been added to the -mm tree.  Its filename is
     aoe-increase-net_device-reference-count-while-using-it.patch

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
Subject: aoe: increase net_device reference count while using it

This change eliminates the danger that the user could rmmod the driver for
a network interface that is being used for AoE by the aoe driver.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    4 ++++
 drivers/block/aoe/aoedev.c |    7 +++++++
 2 files changed, 11 insertions(+)

diff -puN drivers/block/aoe/aoecmd.c~aoe-increase-net_device-reference-count-while-using-it drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-increase-net_device-reference-count-while-using-it
+++ a/drivers/block/aoe/aoecmd.c
@@ -493,12 +493,15 @@ static void
 ejectif(struct aoetgt *t, struct aoeif *ifp)
 {
 	struct aoeif *e;
+	struct net_device *nd;
 	ulong n;
 
+	nd = ifp->nd;
 	e = t->ifs + NAOEIFS - 1;
 	n = (e - ifp) * sizeof *ifp;
 	memmove(ifp, ifp+1, n);
 	e->nd = NULL;
+	dev_put(nd);
 }
 
 static int
@@ -1317,6 +1320,7 @@ setifbcnt(struct aoetgt *t, struct net_d
 			pr_err("aoe: device setifbcnt failure; too many interfaces.\n");
 			return;
 		}
+		dev_hold(nd);
 		p->nd = nd;
 		p->bcnt = bcnt;
 	}
diff -puN drivers/block/aoe/aoedev.c~aoe-increase-net_device-reference-count-while-using-it drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-increase-net_device-reference-count-while-using-it
+++ a/drivers/block/aoe/aoedev.c
@@ -295,6 +295,13 @@ freetgt(struct aoedev *d, struct aoetgt 
 {
 	struct frame *f;
 	struct list_head *pos, *nx, *head;
+	struct aoeif *ifp;
+
+	for (ifp = t->ifs; ifp < &t->ifs[NAOEIFS]; ++ifp) {
+		if (!ifp->nd)
+			break;
+		dev_put(ifp->nd);
+	}
 
 	head = &t->ffree;
 	list_for_each_safe(pos, nx, head) {
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

