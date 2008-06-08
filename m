From: akpm@linux-foundation.org
Subject: - vm-add-kzalloc_node-inline.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:25 -0700
Message-ID: <200806081949.m58JnPEu017680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667AbYFHTuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:50:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     vm: add kzalloc_node() inline
has been removed from the -mm tree.  Its filename was
     vm-add-kzalloc_node-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vm: add kzalloc_node() inline
From: Jeff Layton <jlayton@redhat.com>

To get zeroed out memory from a particular NUMA node.  To be used by
sunrpc.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/slab.h~vm-add-kzalloc_node-inline include/linux/slab.h
--- a/include/linux/slab.h~vm-add-kzalloc_node-inline
+++ a/include/linux/slab.h
@@ -276,6 +276,17 @@ static inline void *kzalloc(size_t size,
 	return kmalloc(size, flags | __GFP_ZERO);
 }
 
+/**
+ * kzalloc_node - allocate zeroed memory from a particular memory node.
+ * @size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate (see kmalloc).
+ * @node: memory node from which to allocate
+ */
+static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
+{
+	return kmalloc_node(size, flags | __GFP_ZERO, node);
+}
+
 #ifdef CONFIG_SLABINFO
 extern const struct seq_operations slabinfo_op;
 ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
linux-next.patch
git-unionfs.patch

