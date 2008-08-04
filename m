From: akpm@linux-foundation.org
Subject: + omfs-fix-warning.patch added to -mm tree
Date: Mon, 04 Aug 2008 16:32:52 -0700
Message-ID: <200808042332.m74NWq0o005521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbYHDXdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 19:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, me@bobcopeland.com


The patch titled
     omfs: fix warning
has been added to the -mm tree.  Its filename is
     omfs-fix-warning.patch

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
Subject: omfs: fix warning
From: Alexander Beregalov <a.beregalov@gmail.com>

fs/omfs/inode.c:495: warning: format '%llx' expects type 'long long
	unsigned int', but argument 2 has type 'u64'
fs/omfs/inode.c:495: warning: format '%llx' expects type 'long
	long unsigned int', but argument 3 has type '__be64'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Acked-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/omfs/inode.c~omfs-fix-warning fs/omfs/inode.c
--- a/fs/omfs/inode.c~omfs-fix-warning
+++ a/fs/omfs/inode.c
@@ -492,7 +492,8 @@ static int omfs_fill_super(struct super_
 	if (sbi->s_num_blocks != be64_to_cpu(omfs_rb->r_num_blocks)) {
 		printk(KERN_ERR "omfs: block count discrepancy between "
 			"super and root blocks (%llx, %llx)\n",
-			sbi->s_num_blocks, be64_to_cpu(omfs_rb->r_num_blocks));
+			(unsigned long long)sbi->s_num_blocks,
+			(unsigned long long)be64_to_cpu(omfs_rb->r_num_blocks));
 		goto out_brelse_bh2;
 	}
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
atyfb_basec-fix-warning.patch
omfs-fix-warning.patch
linux-next.patch

