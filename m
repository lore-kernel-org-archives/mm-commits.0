From: akpm@linux-foundation.org
Subject: - drivers-isdn-i4l-isdn_commonc-fix-small-resource-leak.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:34:46 -0700
Message-ID: <200807141934.m6EJYkUG023836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535AbYGNTe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:34:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrenrjenkins@gmail.com, darrenrjenkins@gmailcom, kkeil@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn/i4l/isdn_common.c fix small resource leak
has been removed from the -mm tree.  Its filename was
     drivers-isdn-i4l-isdn_commonc-fix-small-resource-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/isdn/i4l/isdn_common.c fix small resource leak
From: Darren Jenkins\ <darrenrjenkins@gmail.com>

Coverity CID: 1356 RESOURCE_LEAK

I found a very old patch for this that was Acked but did not get applied
https://lists.linux-foundation.org/pipermail/kernel-janitors/2006-September/016362.html

There looks to be a small leak in isdn_writebuf_stub() in isdn_common.c, when
copy_from_user() returns an un-copied data length (length != 0).  The below
patch should be a minimally invasive fix.

Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>
Acked-by: Karsten Keil <kkeil@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/isdn/i4l/isdn_common.c~drivers-isdn-i4l-isdn_commonc-fix-small-resource-leak drivers/isdn/i4l/isdn_common.c
--- a/drivers/isdn/i4l/isdn_common.c~drivers-isdn-i4l-isdn_commonc-fix-small-resource-leak
+++ a/drivers/isdn/i4l/isdn_common.c
@@ -1977,8 +1977,10 @@ isdn_writebuf_stub(int drvidx, int chan,
 	if (!skb)
 		return -ENOMEM;
 	skb_reserve(skb, hl);
-	if (copy_from_user(skb_put(skb, len), buf, len))
+	if (copy_from_user(skb_put(skb, len), buf, len)) {
+		dev_kfree_skb(skb);
 		return -EFAULT;
+	}
 	ret = dev->drv[drvidx]->interface->writebuf_skb(drvidx, chan, 1, skb);
 	if (ret <= 0)
 		dev_kfree_skb(skb);
_

Patches currently in -mm which might be from darrenrjenkins@gmail.com are

linux-next.patch

