From: akpm@linux-foundation.org
Subject: + remove-useless-tolower-in-isofs.patch added to -mm tree
Date: Tue, 29 May 2007 16:16:39 -0700
Message-ID: <200705292316.l4TNGdPx014114@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbXE2XQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 19:16:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, penberg@cs.helsinki.fi


The patch titled
     remove useless tolower in isofs
has been added to the -mm tree.  Its filename is
     remove-useless-tolower-in-isofs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove useless tolower in isofs
From: "young dave" <hidave.darkstar@gmail.com>

Remove useless tolower in isofs

Signed-off-by: dave young <hidave.darkstar@gmail.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/isofs/inode.c~remove-useless-tolower-in-isofs fs/isofs/inode.c
--- a/fs/isofs/inode.c~remove-useless-tolower-in-isofs
+++ a/fs/isofs/inode.c
@@ -197,7 +197,7 @@ isofs_hashi_common(struct dentry *dentry
 	hash = init_name_hash();
 	while (len--) {
 		c = tolower(*name++);
-		hash = partial_name_hash(tolower(c), hash);
+		hash = partial_name_hash(c, hash);
 	}
 	qstr->hash = end_name_hash(hash);
 
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

ntfs_init_locked_inode-fix-array-indexing.patch
git-cifs.patch
remove-useless-tolower-in-isofs.patch
