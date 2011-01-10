From: akpm@linux-foundation.org
Subject: [merged] ext3-remove-redundant-unlikely.patch removed from -mm tree
Date: Mon, 10 Jan 2011 13:30:29 -0800
Message-ID: <201101102132.p0ALWjML012821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab1AJVcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Jan 2011 16:32:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext3: remove redundant unlikely()
has been removed from the -mm tree.  Its filename was
     ext3-remove-redundant-unlikely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: remove redundant unlikely()
From: Tobias Klauser <tklauser@distanz.ch>

IS_ERR() already implies unlikely(), so it can be omitted here.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/namei.c~ext3-remove-redundant-unlikely fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-remove-redundant-unlikely
+++ a/fs/ext3/namei.c
@@ -1047,7 +1047,7 @@ static struct dentry *ext3_lookup(struct
 			return ERR_PTR(-EIO);
 		}
 		inode = ext3_iget(dir->i_sb, ino);
-		if (unlikely(IS_ERR(inode))) {
+		if (IS_ERR(inode)) {
 			if (PTR_ERR(inode) == -ESTALE) {
 				ext3_error(dir->i_sb, __func__,
 						"deleted inode referenced: %lu",
_

Patches currently in -mm which might be from tklauser@distanz.ch are

origin.patch
linux-next.patch
vmalloc-remove-redundant-unlikely.patch

