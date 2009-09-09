From: akpm@linux-foundation.org
Subject: + fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode.patch added to -mm tree
Date: Wed, 09 Sep 2009 14:57:44 -0700
Message-ID: <200909092157.n89LviZA001574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398AbZIIV7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 17:59:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, hch@infradead.org, stable@kernel.org


The patch titled
     fs: make sure data stored into inode is properly seen before unlocking new inode
has been added to the -mm tree.  Its filename is
     fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode.patch

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
Subject: fs: make sure data stored into inode is properly seen before unlocking new inode
From: Jan Kara <jack@suse.cz>

In theory it could happen that on one CPU we initialize a new inode but
clearing of I_NEW | I_LOCK gets reordered before some of the
initialization.  Thus on another CPU we return not fully uptodate inode
from iget_locked().

This seems to fix a corruption issue on ext3 mounted over NFS.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/inode.c~fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode fs/inode.c
--- a/fs/inode.c~fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode
+++ a/fs/inode.c
@@ -704,6 +704,7 @@ void unlock_new_inode(struct inode *inod
 	 * just created it (so there can be no old holders
 	 * that haven't tested I_LOCK).
 	 */
+	smp_mb();
 	WARN_ON((inode->i_state & (I_LOCK|I_NEW)) != (I_LOCK|I_NEW));
 	inode->i_state &= ~(I_LOCK|I_NEW);
 	wake_up_inode(inode);
_

Patches currently in -mm which might be from jack@suse.cz are

fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode.patch
linux-next.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention-fix.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea.patch
reiser4-update-names-of-quota-methods.patch

