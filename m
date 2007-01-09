From: akpm@osdl.org
Subject: + netfilter-nf_conntrack_netbios_ns-fix-uninitialized-member-in-expectation.patch added to -mm tree
Date: Mon, 08 Jan 2007 20:06:28 -0800
Message-ID: <200701090406.l0946St2027965@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39168 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbXAIEGd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 23:06:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaber@trash.net


The patch titled
     netfilter: nf_conntrack_netbios_ns: fix uninitialized member in expectation
has been added to the -mm tree.  Its filename is
     netfilter-nf_conntrack_netbios_ns-fix-uninitialized-member-in-expectation.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: netfilter: nf_conntrack_netbios_ns: fix uninitialized member in expectation
From: Patrick McHardy <kaber@trash.net>

->helper is uninitialized in the expectation registered by the netbios_ns
helper and it later copied to the expected connection, which causes invalid
memory dereferences when trying to call the helper.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/netfilter/nf_conntrack_netbios_ns.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/netfilter/nf_conntrack_netbios_ns.c~netfilter-nf_conntrack_netbios_ns-fix-uninitialized-member-in-expectation net/netfilter/nf_conntrack_netbios_ns.c
--- a/net/netfilter/nf_conntrack_netbios_ns.c~netfilter-nf_conntrack_netbios_ns-fix-uninitialized-member-in-expectation
+++ a/net/netfilter/nf_conntrack_netbios_ns.c
@@ -89,6 +89,7 @@ static int help(struct sk_buff **pskb, u
 
 	exp->expectfn             = NULL;
 	exp->flags                = NF_CT_EXPECT_PERMANENT;
+	exp->helper               = NULL;
 
 	nf_conntrack_expect_related(exp);
 	nf_conntrack_expect_put(exp);
_

Patches currently in -mm which might be from kaber@trash.net are

netfilter-nf_conntrack_netbios_ns-fix-uninitialized-member-in-expectation.patch
