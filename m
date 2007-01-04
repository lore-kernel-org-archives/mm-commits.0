From: akpm@osdl.org
Subject: + netfilter-ipt_masquerade-null-check-in-device_cmp.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:06:16 -0800
Message-ID: <200701041906.l04J6G3C028129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:44374 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281AbXADTGc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:06:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, kaber@trash.net


The patch titled
     netfilter: ipt_MASQUERADE: NULL check in device_cmp
has been added to the -mm tree.  Its filename is
     netfilter-ipt_masquerade-null-check-in-device_cmp.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: netfilter: ipt_MASQUERADE: NULL check in device_cmp
From: Jarek Poplawski <jarkao2@o2.pl>

nfct_nat can return NULL so check is needed in device_cmp.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/ipv4/netfilter/ipt_MASQUERADE.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN net/ipv4/netfilter/ipt_MASQUERADE.c~netfilter-ipt_masquerade-null-check-in-device_cmp net/ipv4/netfilter/ipt_MASQUERADE.c
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c~netfilter-ipt_masquerade-null-check-in-device_cmp
+++ a/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -127,10 +127,12 @@ masquerade_target(struct sk_buff **pskb,
 static inline int
 device_cmp(struct ip_conntrack *i, void *ifindex)
 {
+	int ret;
 #ifdef CONFIG_NF_NAT_NEEDED
 	struct nf_conn_nat *nat = nfct_nat(i);
+	if (!nat)
+		return 0;
 #endif
-	int ret;
 
 	read_lock_bh(&masq_lock);
 #ifdef CONFIG_NF_NAT_NEEDED
_

Patches currently in -mm which might be from jarkao2@o2.pl are

netfilter-ipt_masquerade-null-check-in-device_cmp.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
