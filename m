From: akpm@linux-foundation.org
Subject: - ppp-fix-osize-too-small-errors-when-decoding.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:42 -0700
Message-ID: <200706250921.l5P9Lge8031139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbXFYJYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:24:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konstantin.sharlaimov@gmail.com, Matt_Domsch@dell.com, davem@davemloft.net, james.cameron@hp.com, paulus@samba.org, vsu@altlinux.ru, mm-commits@vger.kernel.org


The patch titled
     ppp: fix osize too small errors when decoding mppe
has been removed from the -mm tree.  Its filename was
     ppp-fix-osize-too-small-errors-when-decoding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ppp: fix osize too small errors when decoding mppe
From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>

The mppe_decompress() function required a buffer that is 1 byte too small
when receiving a message of mru size.  This fixes buffer allocation to
prevent this from occurring.

As Sergey Vlasov pointed out,
ppp_mppe-account-for-osize-too-small-errors-in.patch may cause buffer
overflows on certain data.  Here is another patch that should eliminate the
"osize too small" errors.  Instead of patching mppe_decompress itself, I
have patched ppp_decompress_frame so it would allocate the required extra
byte when using mppe compression.

Signed-off-by: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: James Cameron <james.cameron@hp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Sergey Vlasov <vsu@altlinux.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ppp_generic.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/net/ppp_generic.c~ppp-fix-osize-too-small-errors-when-decoding drivers/net/ppp_generic.c
--- a/drivers/net/ppp_generic.c~ppp-fix-osize-too-small-errors-when-decoding
+++ a/drivers/net/ppp_generic.c
@@ -1708,7 +1708,18 @@ ppp_decompress_frame(struct ppp *ppp, st
 		goto err;
 
 	if (proto == PPP_COMP) {
-		ns = dev_alloc_skb(ppp->mru + PPP_HDRLEN);
+		int obuff_size;
+
+		switch(ppp->rcomp->compress_proto) {
+		case CI_MPPE:
+			obuff_size = ppp->mru + PPP_HDRLEN + 1;
+			break;
+		default:
+			obuff_size = ppp->mru + PPP_HDRLEN;
+			break;
+		}
+
+		ns = dev_alloc_skb(obuff_size);
 		if (ns == 0) {
 			printk(KERN_ERR "ppp_decompress_frame: no memory\n");
 			goto err;
_

Patches currently in -mm which might be from konstantin.sharlaimov@gmail.com are
