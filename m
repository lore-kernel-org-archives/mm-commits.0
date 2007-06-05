From: akpm@linux-foundation.org
Subject: + ramfs-nommu-missed-posix-uid-gid-inode-attribute-checking.patch added to -mm tree
Date: Mon, 04 Jun 2007 21:45:16 -0700
Message-ID: <200706050445.l554jESB029469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39792 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbXFEEpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 00:45:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, dhowells@redhat.com


The patch titled
     RAMFS NOMMU: missed POSIX UID/GID inode attribute checking
has been added to the -mm tree.  Its filename is
     ramfs-nommu-missed-posix-uid-gid-inode-attribute-checking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RAMFS NOMMU: missed POSIX UID/GID inode attribute checking
From: Bryan Wu <bryan.wu@analog.com>

This bug was caught by LTP testcase fchmod06 on Blackfin platform.

In the manpage of fchmod, "EPERM: The effective UID does not match the
owner of the file, and the process is not privileged (Linux: it does not
have the CAP_FOWNER capability)."

But the ramfs nommu code missed the inode_change_ok POSIX UID/GID
verification.  This patch fixed this.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ramfs/file-nommu.c~ramfs-nommu-missed-posix-uid-gid-inode-attribute-checking fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~ramfs-nommu-missed-posix-uid-gid-inode-attribute-checking
+++ a/fs/ramfs/file-nommu.c
@@ -195,6 +195,11 @@ static int ramfs_nommu_setattr(struct de
 	unsigned int old_ia_valid = ia->ia_valid;
 	int ret = 0;
 
+	/* POSIX UID/GID verification for setting inode attributes */
+	ret = inode_change_ok(inode, ia);
+	if (ret)
+		return ret;
+
 	/* by providing our own setattr() method, we skip this quotaism */
 	if ((old_ia_valid & ATTR_UID && ia->ia_uid != inode->i_uid) ||
 	    (old_ia_valid & ATTR_GID && ia->ia_gid != inode->i_gid))
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
ramfs-nommu-missed-posix-uid-gid-inode-attribute-checking.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-enable-arbitary-speed-serial-setting.patch
