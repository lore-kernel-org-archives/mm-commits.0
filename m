From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-adjust-code-style-for-o2net_handler_tree_lookup.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:41:47 -0700
Message-ID: <523218fb.RsywsvhPvf7mV764%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: [merged] ocfs2-adjust-code-style-for-o2net_handler_tree_lookup.patch removed from -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:47 -0700


The patch titled
     Subject: ocfs2: adjust code style for o2net_handler_tree_lookup()
has been removed from the -mm tree.  Its filename was
     ocfs2-adjust-code-style-for-o2net_handler_tree_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: adjust code style for o2net_handler_tree_lookup()

Code in o2net_handler_tree_lookup() may be corrupted by mistake.  So
adjust it to promote readability.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-adjust-code-style-for-o2net_handler_tree_lookup fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-adjust-code-style-for-o2net_handler_tree_lookup
+++ a/fs/ocfs2/cluster/tcp.c
@@ -766,32 +766,32 @@ static struct o2net_msg_handler *
 o2net_handler_tree_lookup(u32 msg_type, u32 key, struct rb_node ***ret_p,
 			  struct rb_node **ret_parent)
 {
-        struct rb_node **p = &o2net_handler_tree.rb_node;
-        struct rb_node *parent = NULL;
+	struct rb_node **p = &o2net_handler_tree.rb_node;
+	struct rb_node *parent = NULL;
 	struct o2net_msg_handler *nmh, *ret = NULL;
 	int cmp;
 
-        while (*p) {
-                parent = *p;
-                nmh = rb_entry(parent, struct o2net_msg_handler, nh_node);
+	while (*p) {
+		parent = *p;
+		nmh = rb_entry(parent, struct o2net_msg_handler, nh_node);
 		cmp = o2net_handler_cmp(nmh, msg_type, key);
 
-                if (cmp < 0)
-                        p = &(*p)->rb_left;
-                else if (cmp > 0)
-                        p = &(*p)->rb_right;
-                else {
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else if (cmp > 0)
+			p = &(*p)->rb_right;
+		else {
 			ret = nmh;
-                        break;
+			break;
 		}
-        }
+	}
 
-        if (ret_p != NULL)
-                *ret_p = p;
-        if (ret_parent != NULL)
-                *ret_parent = parent;
+	if (ret_p != NULL)
+		*ret_p = p;
+	if (ret_parent != NULL)
+		*ret_parent = parent;
 
-        return ret;
+	return ret;
 }
 
 static void o2net_handler_kref_release(struct kref *kref)
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch

