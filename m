From: akpm@linux-foundation.org
Subject: - aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:07 -0800
Message-ID: <200802082015.m18KFmis010647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705AbYBHUuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:50:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     aoe: add module parameter for users who need more outstanding I/O
has been removed from the -mm tree.  Its filename was
     aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: add module parameter for users who need more outstanding I/O
From: "Ed L. Cashin" <ecashin@coraid.com>

An AoE target provides an estimate of the number of outstanding commands that
the AoE initiator can send before getting a response.  The aoe_maxout
parameter provides a way to set an even lower limit.  It will not allow a user
to use more outstanding commands than the target permits.  If a user discovers
a problem with a large setting, this parameter provides a way for us to work
with them to debug the problem.  We expect to improve the dynamic window
sizing algorithm and drop this parameter.  For the time being, it is a
debugging aid.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o
+++ a/drivers/block/aoe/aoecmd.c
@@ -18,6 +18,11 @@ static int aoe_deadsecs = 60 * 3;
 module_param(aoe_deadsecs, int, 0644);
 MODULE_PARM_DESC(aoe_deadsecs, "After aoe_deadsecs seconds, give up and fail dev.");
 
+static int aoe_maxout = 16;
+module_param(aoe_maxout, int, 0644);
+MODULE_PARM_DESC(aoe_maxout,
+	"Only aoe_maxout outstanding packets for every MAC on eX.Y.");
+
 static struct sk_buff *
 new_skb(ulong len)
 {
@@ -984,7 +989,6 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	struct aoeif *ifp;
 	ulong flags, sysminor, aoemajor;
 	struct sk_buff *sl;
-	enum { MAXFRAMES = 16 };
 	u16 n;
 
 	h = (struct aoe_hdr *) skb_mac_header(skb);
@@ -1009,8 +1013,8 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	}
 
 	n = be16_to_cpu(ch->bufcnt);
-	if (n > MAXFRAMES)	/* keep it reasonable */
-		n = MAXFRAMES;
+	if (n > aoe_maxout)	/* keep it reasonable */
+		n = aoe_maxout;
 
 	d = aoedev_by_sysminor_m(sysminor);
 	if (d == NULL) {
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
