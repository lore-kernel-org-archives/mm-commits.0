From: akpm@linux-foundation.org
Subject: + ncpfs-fix-wrong-check-in-__ncp_ioctl.patch added to -mm tree
Date: Wed, 02 Sep 2009 13:55:25 -0700
Message-ID: <200909022055.n82KtQph011788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414AbZIBU4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 16:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, error27@gmail.com, julia@diku.dk, vandrove@vc.cvut.cz


The patch titled
     ncpfs: fix wrong check in __ncp_ioctl()
has been added to the -mm tree.  Its filename is
     ncpfs-fix-wrong-check-in-__ncp_ioctl.patch

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
Subject: ncpfs: fix wrong check in __ncp_ioctl()
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

We want to check for s_inode's existence, not inode's one (inode is always
valid in this function).

This takes care of the following entry from Dan's list:

fs/ncpfs/ioctl.c +445 __ncp_ioctl(180) warning: variable derefenced before check 'inode'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ncpfs/ioctl.c~ncpfs-fix-wrong-check-in-__ncp_ioctl fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~ncpfs-fix-wrong-check-in-__ncp_ioctl
+++ a/fs/ncpfs/ioctl.c
@@ -442,7 +442,7 @@ static int __ncp_ioctl(struct inode *ino
 			if (dentry) {
 				struct inode* s_inode = dentry->d_inode;
 				
-				if (inode) {
+				if (s_inode) {
 					NCP_FINFO(s_inode)->volNumber = vnum;
 					NCP_FINFO(s_inode)->dirEntNum = de;
 					NCP_FINFO(s_inode)->DosDirNum = dosde;
_

Patches currently in -mm which might be from bzolnier@gmail.com are

origin.patch
linux-next.patch
ide-use-printk_once.patch
maintainers-remove-dead-ncpfs-list.patch
ncpfs-remove-dead-url-from-documentation.patch
ncpfs-fix-wrong-check-in-__ncp_ioctl.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch

