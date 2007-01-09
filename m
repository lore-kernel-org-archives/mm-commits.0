From: akpm@osdl.org
Subject: - netfilter-nf_conntrack_netbios_ns-fix-uninitialized-member-in-expectation.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:29:20 -0800
Message-ID: <200701092029.l09KTK5d014363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41112 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416AbXAIU33 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:29:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     netfilter: nf_conntrack_netbios_ns: fix uninitialized member in expectation
has been removed from the -mm tree.  Its filename was
     netfilter-nf_conntrack_netbios_ns-fix-uninitialized-member-in-expectation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
