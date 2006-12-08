From: akpm@osdl.org
Subject: - isdn-avoid-a-potential-null-ptr-deref-in-ippp.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:46 -0800
Message-ID: <200612082010.kB8KAkGk002844@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58934 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946513AbWLHUKv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     ISDN: Avoid a potential NULL ptr deref in ippp
has been removed from the -mm tree.  Its filename was
     isdn-avoid-a-potential-null-ptr-deref-in-ippp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ISDN: Avoid a potential NULL ptr deref in ippp
From: Jesper Juhl <jesper.juhl@gmail.com>

There's a potential problem in isdn_ppp.c::isdn_ppp_decompress().
dev_alloc_skb() may fail and return NULL. If it does we will be passing a
NULL skb_out to ipc->decompress() and may also end up
dereferencing a NULL pointer at

    *proto = isdn_ppp_strip_proto(skb_out);

Correct this by testing 'skb_out' against NULL early and bail out.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/i4l/isdn_ppp.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/isdn/i4l/isdn_ppp.c~isdn-avoid-a-potential-null-ptr-deref-in-ippp drivers/isdn/i4l/isdn_ppp.c
--- a/drivers/isdn/i4l/isdn_ppp.c~isdn-avoid-a-potential-null-ptr-deref-in-ippp
+++ a/drivers/isdn/i4l/isdn_ppp.c
@@ -2536,6 +2536,11 @@ static struct sk_buff *isdn_ppp_decompre
   		rsparm.maxdlen = IPPP_RESET_MAXDATABYTES;
   
   		skb_out = dev_alloc_skb(is->mru + PPP_HDRLEN);
+  		if (!skb_out) {
+  			kfree_skb(skb);
+  			printk(KERN_ERR "ippp: decomp memory allocation failure\n");
+			return NULL;
+  		}
 		len = ipc->decompress(stat, skb, skb_out, &rsparm);
 		kfree_skb(skb);
 		if (len <= 0) {
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
isdn-avoid-a-potential-null-ptr-deref-in-ippp.patch
nfs2-calculate-w-a-bit-later-in-nfsaclsvc_encode_getaclres.patch
nfs3-calculate-w-a-bit-later-in-nfs3svc_encode_getaclres.patch
video-sis-remove-unnecessary-variables-in-sis_ddc2delay.patch
git-acpi.patch
nfs-kill-obsolete-nfs_paranoia.patch
be-a-bit-defensive-in-quirk_nvidia_ck804-so-we-dont-risk-dereferencing-a-null-pdev.patch
debug-shared-irqs.patch

