From: akpm@linux-foundation.org
Subject: + romfs-prevent-romfs_lookup-from-always-failing.patch added to -mm tree
Date: Tue, 04 Mar 2008 01:25:22 -0800
Message-ID: <200803040925.m249PMQk001189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754974AbYCDJ0E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 04:26:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adam@yggdrasil.com, dhowells@redhat.com


The patch titled
     romfs: prevent romfs_lookup() from always failing
has been added to the -mm tree.  Its filename is
     romfs-prevent-romfs_lookup-from-always-failing.patch

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
Subject: romfs: prevent romfs_lookup() from always failing
From: "Adam J. Richter" <adam@yggdrasil.com>

romfs_lookup worked in 2.6.24.2, but always fails in linux-2.6.25-rc3-git3. 
fs/romfs/inode.c is the same in at least 2.6.25-rc3 through 2.6.25-rc3-git4
and the latest sources from git, so these versions almost certainly have the
same problem.

The bug appears to be from a well meaning but botched attempt to eliminate a
goto from romfs_lookup.  Previously, a goto statement was used to skip over
"inode = NULL;" when the lookup succeeded.  In the 2.6.25-rc3 version, inode
is set to NULL even when an inode was found, so the result is the the lookup
always appears to fail.

The attached patch fixes the problem while still eliminating the goto.

P.S.  romfs_lookup casts a valid pointer to an int and then back again with
res = PTR_ERR(inode);...return ERR_PTR(res).  This may break on arhictectures
where sizeof(int) < sizeof(pointer).

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/romfs/inode.c~romfs-prevent-romfs_lookup-from-always-failing fs/romfs/inode.c
--- a/fs/romfs/inode.c~romfs-prevent-romfs_lookup-from-always-failing
+++ a/fs/romfs/inode.c
@@ -347,6 +347,7 @@ romfs_lookup(struct inode *dir, struct d
 	const char *name;		/* got from dentry */
 	int len;
 
+	inode = NULL;
 	res = -EACCES;			/* placeholder for "no data here" */
 	offset = dir->i_ino & ROMFH_MASK;
 	lock_kernel();
@@ -409,7 +410,7 @@ romfs_lookup(struct inode *dir, struct d
 	 * systems).
 	 */
 
-out0:	inode = NULL;
+out0:
 	res = 0;
 	d_add (dentry, inode);
 
_

Patches currently in -mm which might be from adam@yggdrasil.com are

romfs-prevent-romfs_lookup-from-always-failing.patch

