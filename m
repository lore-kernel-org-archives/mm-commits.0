From: akpm@linux-foundation.org
Subject: + reiserfs-fix-corruption-during-shrinking-of-xattrs.patch added to -mm tree
Date: Tue, 13 Apr 2010 12:46:46 -0700
Message-ID: <201004131946.o3DJkk8k023876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672Ab0DMTrV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Apr 2010 15:47:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, edward.shishkin@gmail.com, gregsurbey@hotmail.com, kernel@jbeekman.nl, lists@nerdbynature.de, marco.gatti@gmail.com, stable@kernel.org


The patch titled
     From: Jeff Mahoney <jeffm@suse.com>
has been added to the -mm tree.  Its filename is
     reiserfs-fix-corruption-during-shrinking-of-xattrs.patch

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
Subject: From: Jeff Mahoney <jeffm@suse.com>


Commit 48b32a3553a54740d236b79a90f20147a25875e3 ("reiserfs: use generic
xattr handlers") introduced a problem that causes corruption when extended
attributes are replaced with a smaller value.

The issue is that the reiserfs_setattr to shrink the xattr file was moved
from before the write to after the write.

The root issue has always been in the reiserfs xattr code, but was papered
over by the fact that in the shrink case, the file would just be expanded
again while the xattr was written.

The end result is that the last 8 bytes of xattr data are lost.

This patch fixes it to use new_size.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=14826

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reported-by: Christian Kujau <lists@nerdbynature.de>
Cc: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Jethro Beekman <kernel@jbeekman.nl>
Cc: Greg Surbey <gregsurbey@hotmail.com>
Cc: Marco Gatti <marco.gatti@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/xattr.c~reiserfs-fix-corruption-during-shrinking-of-xattrs fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~reiserfs-fix-corruption-during-shrinking-of-xattrs
+++ a/fs/reiserfs/xattr.c
@@ -554,7 +554,7 @@ reiserfs_xattr_set_handle(struct reiserf
 	if (!err && new_size < i_size_read(dentry->d_inode)) {
 		struct iattr newattrs = {
 			.ia_ctime = current_fs_time(inode->i_sb),
-			.ia_size = buffer_size,
+			.ia_size = new_size,
 			.ia_valid = ATTR_SIZE | ATTR_CTIME,
 		};
 
_

Patches currently in -mm which might be from jeffm@suse.com are

reiserfs-fix-permissions-on-reiserfs_priv.patch
reiserfs-fix-corruption-during-shrinking-of-xattrs.patch
linux-next.patch
delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch

