From: akpm@linux-foundation.org
Subject: + cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:34:16 -0700
Message-ID: <200709210634.l8L6YG2T022716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48011 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910AbXIUGe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:34:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hch@lst.de, sfrench@us.ibm.com


The patch titled
     CIFS: ignore mode change if it's just for clearing setuid/setgid bits
has been added to the -mm tree.  Its filename is
     cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CIFS: ignore mode change if it's just for clearing setuid/setgid bits
From: Jeff Layton <jlayton@redhat.com>

If the ATTR_KILL_S*ID bits are set then any mode change is only for clearing
the setuid/setgid bits.  For CIFS, skip the mode change and let the server
handle it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/cifs/inode.c~cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits fs/cifs/inode.c
--- a/fs/cifs/inode.c~cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits
+++ a/fs/cifs/inode.c
@@ -1555,6 +1555,11 @@ int cifs_setattr(struct dentry *direntry
 	}
 
 	time_buf.Attributes = 0;
+
+	/* skip mode change if it's just for clearing setuid/setgid */
+	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
+		attrs->ia_valid &= ~ATTR_MODE;
+
 	if (attrs->ia_valid & ATTR_MODE) {
 		cFYI(1, ("Mode changed to 0x%x", attrs->ia_mode));
 		mode = attrs->ia_mode;
_

Patches currently in -mm which might be from jlayton@redhat.com are

git-cifs.patch
git-nfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch
cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits.patch
