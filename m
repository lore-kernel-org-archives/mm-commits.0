From: akpm@linux-foundation.org
Subject: + fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:38:32 -0800
Message-ID: <200802122338.m1CNcWqR028924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39932 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300AbYBLXi6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:38:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergio@uece.br, akpm@linux-foundation.org, sfrench@us.ibm.com


The patch titled
     fs/smbfs/inode.c: fix warning message deprecating smbfs
has been added to the -mm tree.  Its filename is
     fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch

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
Subject: fs/smbfs/inode.c: fix warning message deprecating smbfs
From: Sergio Luis <sergio@uece.br>

Fix the warning message regarding smbfs to

"smbfs is deprecated and will be removed from the 2.6.27 kernel. Please migrate to cifs"

instead of

"smbfs is deprecated and will be removedfrom the 2.6.27 kernel.  Please migrate to cifs"

Signed-off-by: Sergio Luis <sergio@uece.br>
Screwed-up-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/smbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/smbfs/inode.c~fs-smbfs-inodec-fix-warning-message-deprecating-smbfs fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~fs-smbfs-inodec-fix-warning-message-deprecating-smbfs
+++ a/fs/smbfs/inode.c
@@ -505,7 +505,7 @@ static int smb_fill_super(struct super_b
 	if (warn_count < 5) {
 		warn_count++;
 		printk(KERN_EMERG "smbfs is deprecated and will be removed"
-			"from the 2.6.27 kernel.  Please migrate to cifs\n");
+			" from the 2.6.27 kernel. Please migrate to cifs\n");
 	}
 
 	if (!raw_data)
_

Patches currently in -mm which might be from sergio@uece.br are

fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch
