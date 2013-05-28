From: akpm@linux-foundation.org
Subject: [merged] hfs-avoid-crash-in-hfs_bnode_create.patch removed from
 -mm tree
Date: Tue, 28 May 2013 12:36:49 -0700
Message-ID: <51a50751.9v9q6+Y7AI8mtEd5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab3E1Tgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, jslaby@suse.cz, jeffm@suse.com

Subject: [merged] hfs-avoid-crash-in-hfs_bnode_create.patch removed from -mm tree
To: jeffm@suse.com,jslaby@suse.cz,slava@dubeyko.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:49 -0700


The patch titled
     Subject: hfs: avoid crash in hfs_bnode_create
has been removed from the -mm tree.  Its filename was
     hfs-avoid-crash-in-hfs_bnode_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Mahoney <jeffm@suse.com>
Subject: hfs: avoid crash in hfs_bnode_create

Commit 634725a92938 ("hfs: cleanup HFS+ prints") removed the BUG_ON in
hfs_bnode_create in hfsplus.  This patch removes it from the hfs version
and avoids an fsfuzzer crash.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/bnode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/hfs/bnode.c~hfs-avoid-crash-in-hfs_bnode_create fs/hfs/bnode.c
--- a/fs/hfs/bnode.c~hfs-avoid-crash-in-hfs_bnode_create
+++ a/fs/hfs/bnode.c
@@ -415,7 +415,11 @@ struct hfs_bnode *hfs_bnode_create(struc
 	spin_lock(&tree->hash_lock);
 	node = hfs_bnode_findhash(tree, num);
 	spin_unlock(&tree->hash_lock);
-	BUG_ON(node);
+	if (node) {
+		pr_crit("new node %u already hashed?\n", num);
+		WARN_ON(1);
+		return node;
+	}
 	node = __hfs_bnode_create(tree, num);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
_

Patches currently in -mm which might be from jeffm@suse.com are

linux-next.patch
reiserfs-fix-deadlock-with-nfs-racing-on-create-lookup.patch

