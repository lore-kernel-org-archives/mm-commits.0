From: akpm@linux-foundation.org
Subject: + drivers-net-arcnet-arcnetc-use-time_-macros.patch added to -mm tree
Date: Mon, 17 Mar 2008 21:20:05 -0700
Message-ID: <200803180420.m2I4K50s013892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbYCREUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:20:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, jeff@garzik.org


The patch titled
     drivers/net/arcnet/arcnet.c: use time_* macros
has been added to the -mm tree.  Its filename is
     drivers-net-arcnet-arcnetc-use-time_-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/arcnet/arcnet.c: use time_* macros
From: S.Caglar Onur <caglar@pardus.org.tr>

The functions time_before, time_before_eq, time_after, and time_after_eq are
more robust for comparing jiffies against other values.

So use the time_after() macro, defined in linux/jiffies.h, which deals with
wrapping correctly.

Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/arcnet/arcnet.c |    4 ++--
 include/linux/arcdevice.h   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/arcnet/arcnet.c~drivers-net-arcnet-arcnetc-use-time_-macros drivers/net/arcnet/arcnet.c
--- a/drivers/net/arcnet/arcnet.c~drivers-net-arcnet-arcnetc-use-time_-macros
+++ a/drivers/net/arcnet/arcnet.c
@@ -940,7 +940,7 @@ irqreturn_t arcnet_interrupt(int irq, vo
 
 			/* is the RECON info empty or old? */
 			if (!lp->first_recon || !lp->last_recon ||
-			    jiffies - lp->last_recon > HZ * 10) {
+			    time_after(jiffies, lp->last_recon + HZ * 10)) {
 				if (lp->network_down)
 					BUGMSG(D_NORMAL, "reconfiguration detected: cabling restored?\n");
 				lp->first_recon = lp->last_recon = jiffies;
@@ -974,7 +974,7 @@ irqreturn_t arcnet_interrupt(int irq, vo
 					lp->num_recons = 1;
 				}
 			}
-		} else if (lp->network_down && jiffies - lp->last_recon > HZ * 10) {
+		} else if (lp->network_down && time_after(jiffies, lp->last_recon + HZ * 10)) {
 			if (lp->network_down)
 				BUGMSG(D_NORMAL, "cabling restored?\n");
 			lp->first_recon = lp->last_recon = 0;
diff -puN include/linux/arcdevice.h~drivers-net-arcnet-arcnetc-use-time_-macros include/linux/arcdevice.h
--- a/include/linux/arcdevice.h~drivers-net-arcnet-arcnetc-use-time_-macros
+++ a/include/linux/arcdevice.h
@@ -283,7 +283,7 @@ struct arcnet_local {
 	int next_buf, first_free_buf;
 
 	/* network "reconfiguration" handling */
-	time_t first_recon,	/* time of "first" RECON message to count */
+	unsigned long first_recon,	/* time of "first" RECON message to count */
 		last_recon;	/* time of most recent RECON */
 	int num_recons;		/* number of RECONs between first and last. */
 	bool network_down;	/* do we think the network is down? */
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
arch-powerpc-platforms-iseries-pcic-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros.patch
drivers-net-tokenring-3c359c-use-time_-macros.patch
drivers-net-wireless-atmelc-use-time_-macros.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch
fix-indentation.patch

