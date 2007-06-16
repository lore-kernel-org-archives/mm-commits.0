From: akpm@linux-foundation.org
Subject: - ppp_mppe-account-for-osize-too-small-errors-in.patch removed from -mm tree
Date: Sat, 16 Jun 2007 08:31:22 -0700
Message-ID: <200706161531.l5GFVMum014741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757642AbXFPPge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Jun 2007 11:36:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konstantin.sharlaimov@gmail.com, Matt_Domsch@dell.com, davem@davemloft.net, james.cameron@hp.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ppp_mppe: account for osize too small errors in mppe_decompress()
has been removed from the -mm tree.  Its filename was
     ppp_mppe-account-for-osize-too-small-errors-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ppp_mppe: account for osize too small errors in mppe_decompress()
From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>

Prevent mppe_decompress() from generating "osize too small" errors when
checking for output buffer size.  When receiving a packet of mru size the
output buffer for decrypted data is 1 byte too small since
mppe_decompress() tries to account for possible PFC, however later in code
it is assumed no PFC.

Adjusting the check prevented these errors from occurring.

Signed-off-by: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: James Cameron <james.cameron@hp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ppp_mppe.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/ppp_mppe.c~ppp_mppe-account-for-osize-too-small-errors-in drivers/net/ppp_mppe.c
--- a/drivers/net/ppp_mppe.c~ppp_mppe-account-for-osize-too-small-errors-in
+++ a/drivers/net/ppp_mppe.c
@@ -493,14 +493,14 @@ mppe_decompress(void *arg, unsigned char
 
 	/*
 	 * Make sure we have enough room to decrypt the packet.
-	 * Note that for our test we only subtract 1 byte whereas in
-	 * mppe_compress() we added 2 bytes (+MPPE_OVHD);
-	 * this is to account for possible PFC.
+	 * To account for possible PFC we should only subtract 1
+	 * byte whereas in mppe_compress() we added 2 bytes (+MPPE_OVHD);
+	 * However, we assume no PFC, thus subtracting 2 bytes.
 	 */
-	if (osize < isize - MPPE_OVHD - 1) {
+	if (osize < isize - MPPE_OVHD - 2) {
 		printk(KERN_DEBUG "mppe_decompress[%d]: osize too small! "
 		       "(have: %d need: %d)\n", state->unit,
-		       osize, isize - MPPE_OVHD - 1);
+		       osize, isize - MPPE_OVHD - 2);
 		return DECOMP_ERROR;
 	}
 	osize = isize - MPPE_OVHD - 2;	/* assume no PFC */
_

Patches currently in -mm which might be from konstantin.sharlaimov@gmail.com are

origin.patch
