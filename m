From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:41:49 -0700
Message-ID: <523218fd.5atpcq6IZPsJVk7Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: [merged] ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one.patch removed from -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:49 -0700


The patch titled
     Subject: ocfs2: avoid possible NULL pointer dereference in o2net_accept_one()
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

