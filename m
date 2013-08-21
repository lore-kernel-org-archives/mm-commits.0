From: akpm@linux-foundation.org
Subject: +
 ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one.patch
 added to -mm tree
Date: Wed, 21 Aug 2013 14:29:17 -0700
Message-ID: <5215312d.0pdtutTDQ1cAgvuW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3HUV3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Aug 2013 17:29:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: + ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one.patch added to -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 21 Aug 2013 14:29:17 -0700


The patch titled
     Subject: ocfs2: avoid possible NULL pointer dereference in o2net_accept_one()
has been added to the -mm tree.  Its filename is
     ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: avoid possible NULL pointer dereference in o2net_accept_one()

Since o2nm_get_node_by_num() may return NULL, we add this check in
o2net_accept_one() to avoid possible NULL pointer dereference.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1873,12 +1873,16 @@ static int o2net_accept_one(struct socke
 
 	if (o2nm_this_node() >= node->nd_num) {
 		local_node = o2nm_get_node_by_num(o2nm_this_node());
-		printk(KERN_NOTICE "o2net: Unexpected connect attempt seen "
-		       "at node '%s' (%u, %pI4:%d) from node '%s' (%u, "
-		       "%pI4:%d)\n", local_node->nd_name, local_node->nd_num,
-		       &(local_node->nd_ipv4_address),
-		       ntohs(local_node->nd_ipv4_port), node->nd_name,
-		       node->nd_num, &sin.sin_addr.s_addr, ntohs(sin.sin_port));
+		if (local_node)
+			printk(KERN_NOTICE "o2net: Unexpected connect attempt "
+					"seen at node '%s' (%u, %pI4:%d) from "
+					"node '%s' (%u, %pI4:%d)\n",
+					local_node->nd_name, local_node->nd_num,
+					&(local_node->nd_ipv4_address),
+					ntohs(local_node->nd_ipv4_port),
+					node->nd_name,
+					node->nd_num, &sin.sin_addr.s_addr,
+					ntohs(sin.sin_port));
 		ret = -EINVAL;
 		goto out;
 	}
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences.patch
ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch
ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch
ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch
ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch
ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch
ocfs2-adjust-code-style-for-o2net_handler_tree_lookup.patch
ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one.patch

