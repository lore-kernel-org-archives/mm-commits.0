From: akpm@linux-foundation.org
Subject: + ext3-remove-redundant-unlikely.patch added to -mm tree
Date: Thu, 09 Dec 2010 12:48:19 -0800
Message-ID: <201012092048.oB9KmJAm006151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756664Ab0LIUs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 15:48:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, jack@suse.cz


The patch titled
     ext3: remove redundant unlikely()
has been added to the -mm tree.  Its filename is
     ext3-remove-redundant-unlikely.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
vmalloc-remove-redundant-unlikely.patch
ext3-remove-redundant-unlikely.patch

