From: akpm@linux-foundation.org
Subject: + minix-no-need-to-cast-alloction-return-value-in-minix.patch
 added to -mm tree
Date: Thu, 23 Apr 2015 14:50:37 -0700
Message-ID: <5539692d.mddF+HK8sog+U1ql%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbbDWVuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 17:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: firogm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/minix: remove unneeded cast
has been added to the -mm tree.  Its filename is
     minix-no-need-to-cast-alloction-return-value-in-minix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/minix-no-need-to-cast-alloction-return-value-in-minix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/minix-no-need-to-cast-alloction-return-value-in-minix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Firo Yang <firogm@gmail.com>
Subject: fs/minix: remove unneeded cast

kmem_cache_alloc() returns void*.

Signed-off-by: Firo Yang <firogm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/minix/inode.c~minix-no-need-to-cast-alloction-return-value-in-minix fs/minix/inode.c
--- a/fs/minix/inode.c~minix-no-need-to-cast-alloction-return-value-in-minix
+++ a/fs/minix/inode.c
@@ -62,7 +62,7 @@ static struct kmem_cache * minix_inode_c
 static struct inode *minix_alloc_inode(struct super_block *sb)
 {
 	struct minix_inode_info *ei;
-	ei = (struct minix_inode_info *)kmem_cache_alloc(minix_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(minix_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
_

Patches currently in -mm which might be from firogm@gmail.com are

minix-no-need-to-cast-alloction-return-value-in-minix.patch
efs-remove-unneeded-cast.patch
adfs-remove-unneeded-cast.patch

