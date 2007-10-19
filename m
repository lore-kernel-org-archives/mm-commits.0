From: akpm@linux-foundation.org
Subject: - cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:26 -0700
Message-ID: <200710190342.l9J3gQda012897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966220AbXJSD4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hch@lst.de, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     CIFS: ignore mode change if it's just for clearing setuid/setgid bits
has been removed from the -mm tree.  Its filename was
     cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1538,6 +1538,11 @@ int cifs_setattr(struct dentry *direntry
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

origin.patch
git-cifs.patch
unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
