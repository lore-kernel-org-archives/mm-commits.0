From: akpm@linux-foundation.org
Subject: + cifs-fix-inode-leak-in-cifs_get_inode_info_unix.patch added to -mm tree
Date: Fri, 11 Jul 2008 17:51:40 -0700
Message-ID: <200807120051.m6C0per0013188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbYGLAwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 20:52:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, sfrench@us.ibm.com, stable@kernel.org


The patch titled
     cifs: fix inode leak in cifs_get_inode_info_unix
has been added to the -mm tree.  Its filename is
     cifs-fix-inode-leak-in-cifs_get_inode_info_unix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: fix inode leak in cifs_get_inode_info_unix
From: Jeff Layton <jlayton@redhat.com>

Try this:

    mount a share with unix extensions
    create a file on it
    umount the share

You'll get the following message in the ring buffer:

VFS: Busy inodes after unmount of cifs. Self-destruct in 5 seconds.  Have a
nice day...

...the problem is that cifs_get_inode_info_unix is creating and hashing
a new inode even when it's going to return error anyway. The first
lookup when creating a file returns an error so we end up leaking this
inode before we do the actual create. This appears to be a regression
caused by commit 0e4bbde94fdc33f5b3d793166b21bf768ca3e098.

The following patch seems to fix it for me, and fixes a minor
formatting nit as well.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Steven French <sfrench@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/inode.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/cifs/inode.c~cifs-fix-inode-leak-in-cifs_get_inode_info_unix fs/cifs/inode.c
--- a/fs/cifs/inode.c~cifs-fix-inode-leak-in-cifs_get_inode_info_unix
+++ a/fs/cifs/inode.c
@@ -219,15 +219,15 @@ int cifs_get_inode_info_unix(struct inod
 	rc = CIFSSMBUnixQPathInfo(xid, pTcon, full_path, &find_data,
 				  cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
-	if (rc) {
-		if (rc == -EREMOTE && !is_dfs_referral) {
-			is_dfs_referral = true;
-			cFYI(DBG2, ("DFS ref"));
-			/* for DFS, server does not give us real inode data */
-			fill_fake_finddataunix(&find_data, sb);
-			rc = 0;
-		}
-	}
+	if (rc == -EREMOTE && !is_dfs_referral) {
+		is_dfs_referral = true;
+		cFYI(DBG2, ("DFS ref"));
+		/* for DFS, server does not give us real inode data */
+		fill_fake_finddataunix(&find_data, sb);
+		rc = 0;
+	} else if (rc)
+		goto cgiiu_exit;
+
 	num_of_bytes = le64_to_cpu(find_data.NumOfBytes);
 	end_of_file = le64_to_cpu(find_data.EndOfFile);
 
@@ -236,7 +236,7 @@ int cifs_get_inode_info_unix(struct inod
 		*pinode = new_inode(sb);
 		if (*pinode == NULL) {
 			rc = -ENOMEM;
-		goto cgiiu_exit;
+			goto cgiiu_exit;
 		}
 		/* Is an i_ino of zero legal? */
 		/* note ino incremented to unique num in new_inode */
_

Patches currently in -mm which might be from jlayton@redhat.com are

linux-next.patch
cifs-fix-inode-leak-in-cifs_get_inode_info_unix.patch
cifs-fix-wksidarr-declaration-to-be-big-endian-friendly.patch
git-unionfs.patch

