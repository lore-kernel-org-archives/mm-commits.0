From: akpm@linux-foundation.org
Subject: [merged] net-ipv4-correct-the-size-argument-to-kzalloc.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:45:59 -0800
Message-ID: <201002182045.o1IKjx5u002776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab0BRUsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:48:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, davem@davemloft.net, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     net/ipv4/netfilter/nf_nat_snmp_basic.c: correct the size argument to kzalloc
has been removed from the -mm tree.  Its filename was
     net-ipv4-correct-the-size-argument-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/ipv4/netfilter/nf_nat_snmp_basic.c: correct the size argument to kzalloc
From: Julia Lawall <julia@diku.dk>

obj has type struct snmp_object **, not struct snmp_object *.  But indeed
it is not even clear why kmalloc is needed.  The memory is freed by the
end of the function, so the local variable of pointer type should be
sufficient.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@disable sizeof_type_expr@
type T;
T **x;
@@

  x =
  <+...sizeof(
- T
+ *x
  )...+>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/netfilter/nf_nat_snmp_basic.c |   31 ++++++++---------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff -puN net/ipv4/netfilter/nf_nat_snmp_basic.c~net-ipv4-correct-the-size-argument-to-kzalloc net/ipv4/netfilter/nf_nat_snmp_basic.c
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c~net-ipv4-correct-the-size-argument-to-kzalloc
+++ a/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -1038,7 +1038,7 @@ static int snmp_parse_mangle(unsigned ch
 	unsigned int cls, con, tag, vers, pdutype;
 	struct asn1_ctx ctx;
 	struct asn1_octstr comm;
-	struct snmp_object **obj;
+	struct snmp_object *obj;
 
 	if (debug > 1)
 		hex_dump(msg, len);
@@ -1148,43 +1148,34 @@ static int snmp_parse_mangle(unsigned ch
 	if (cls != ASN1_UNI || con != ASN1_CON || tag != ASN1_SEQ)
 		return 0;
 
-	obj = kmalloc(sizeof(struct snmp_object), GFP_ATOMIC);
-	if (obj == NULL) {
-		if (net_ratelimit())
-			printk(KERN_WARNING "OOM in bsalg(%d)\n", __LINE__);
-		return 0;
-	}
-
 	while (!asn1_eoc_decode(&ctx, eoc)) {
 		unsigned int i;
 
-		if (!snmp_object_decode(&ctx, obj)) {
-			if (*obj) {
-				kfree((*obj)->id);
-				kfree(*obj);
+		if (!snmp_object_decode(&ctx, &obj)) {
+			if (obj) {
+				kfree(obj->id);
+				kfree(obj);
 			}
-			kfree(obj);
 			return 0;
 		}
 
 		if (debug > 1) {
 			printk(KERN_DEBUG "bsalg: object: ");
-			for (i = 0; i < (*obj)->id_len; i++) {
+			for (i = 0; i < obj->id_len; i++) {
 				if (i > 0)
 					printk(".");
-				printk("%lu", (*obj)->id[i]);
+				printk("%lu", obj->id[i]);
 			}
-			printk(": type=%u\n", (*obj)->type);
+			printk(": type=%u\n", obj->type);
 
 		}
 
-		if ((*obj)->type == SNMP_IPADDR)
+		if (obj->type == SNMP_IPADDR)
 			mangle_address(ctx.begin, ctx.pointer - 4 , map, check);
 
-		kfree((*obj)->id);
-		kfree(*obj);
+		kfree(obj->id);
+		kfree(obj);
 	}
-	kfree(obj);
 
 	if (!asn1_eoc_decode(&ctx, eoc))
 		return 0;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch
rtc-at91sam9-correct-size-given-to-memset.patch
drivers-edac-introduce-missing-kfree.patch
drivers-char-mmtimerc-eliminate-useless-code.patch

