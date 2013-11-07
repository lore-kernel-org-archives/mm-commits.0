From: akpm@linux-foundation.org
Subject: +
 net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch added to -mm tree
Date: Thu, 07 Nov 2013 14:16:52 -0800
Message-ID: <527c1154.DxjqRiO6lnKp8nmF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab3KGWQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:16:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, pablo@netfilter.org, kadlec@blackhole.kfki.hu, kaber@trash.net, jack@suse.cz, davem@davemloft.net, cody@linux.vnet.ibm.com

Subject: + net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch added to -mm tree
To: cody@linux.vnet.ibm.com,davem@davemloft.net,jack@suse.cz,kaber@trash.net,kadlec@blackhole.kfki.hu,pablo@netfilter.org,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:16:52 -0800


The patch titled
     Subject: net/netfilter/ipset/ip_set_hash_netiface.c: use rbtree postorder iteration instead of opencoding
has been added to the -mm tree.  Its filename is
     net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: net/netfilter/ipset/ip_set_hash_netiface.c: use rbtree postorder iteration instead of opencoding

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/ipset/ip_set_hash_netiface.c |   27 ++-----------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff -puN net/netfilter/ipset/ip_set_hash_netiface.c~net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding net/netfilter/ipset/ip_set_hash_netiface.c
--- a/net/netfilter/ipset/ip_set_hash_netiface.c~net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding
+++ a/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -46,31 +46,12 @@ struct iface_node {
 static void
 rbtree_destroy(struct rb_root *root)
 {
-	struct rb_node *p, *n = root->rb_node;
-	struct iface_node *node;
-
-	/* Non-recursive destroy, like in ext3 */
-	while (n) {
-		if (n->rb_left) {
-			n = n->rb_left;
-			continue;
-		}
-		if (n->rb_right) {
-			n = n->rb_right;
-			continue;
-		}
-		p = rb_parent(n);
-		node = rb_entry(n, struct iface_node, node);
-		if (!p)
-			*root = RB_ROOT;
-		else if (p->rb_left == n)
-			p->rb_left = NULL;
-		else if (p->rb_right == n)
-			p->rb_right = NULL;
+	struct iface_node *node, *next;
 
+	rbtree_postorder_for_each_entry_safe(node, next, root, node)
 		kfree(node);
-		n = p;
-	}
+
+	*root = RB_ROOT;
 }
 
 static int
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

bitops-find-clarify-and-extend-documentation.patch
linux-next.patch
rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator.patch
rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch
rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch
fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch

