From: akpm@linux-foundation.org
Subject: + vm-add-kzalloc_node-inline.patch added to -mm tree
Date: Thu, 05 Jun 2008 22:32:07 -0700
Message-ID: <200806060532.m565W7Gn015298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYFFFc3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 01:32:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com


The patch titled
     VM: add kzalloc_node inline
has been added to the -mm tree.  Its filename is
     vm-add-kzalloc_node-inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: VM: add kzalloc_node inline
From: Jeff Layton <jlayton@redhat.com>

To get zeroed out memory from a particular NUMA node.  To be used by
sunrpc.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
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

vm-add-kzalloc_node-inline.patch

