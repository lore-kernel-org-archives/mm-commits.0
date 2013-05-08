From: akpm@linux-foundation.org
Subject: + hfs-avoid-crash-in-hfs_bnode_create.patch added to -mm tree
Date: Wed, 08 May 2013 13:34:41 -0700
Message-ID: <20130508203441.7736F5A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:45076 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3EHUem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 16:34:42 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so221438vcb.5
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 13:34:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, jslaby@suse.cz, slava@dubeyko.com


The patch titled
     Subject: hfs: avoid crash in hfs_bnode_create
has been added to the -mm tree.  Its filename is
     hfs-avoid-crash-in-hfs_bnode_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hfs-avoid-crash-in-hfs_bnode_create.patch

