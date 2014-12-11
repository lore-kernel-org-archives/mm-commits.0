From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-deletion-of-an-unnecessary-check-before-the-function-call-iput.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:07:58 -0800
Message-ID: <5489eb8e.SiyqNTN4axpX0Err%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbaLKTH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: deletion of an unnecessary check before the function call "iput"
has been removed from the -mm tree.  Its filename was
     nilfs2-deletion-of-an-unnecessary-check-before-the-function-call-iput.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: nilfs2: deletion of an unnecessary check before the function call "iput"

The iput() function tests whether its argument is NULL and then returns
immediately.  Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/nilfs2/the_nilfs.c~nilfs2-deletion-of-an-unnecessary-check-before-the-function-call-iput fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-deletion-of-an-unnecessary-check-before-the-function-call-iput
+++ a/fs/nilfs2/the_nilfs.c
@@ -808,8 +808,7 @@ void nilfs_put_root(struct nilfs_root *r
 		spin_lock(&nilfs->ns_cptree_lock);
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
 		spin_unlock(&nilfs->ns_cptree_lock);
-		if (root->ifile)
-			iput(root->ifile);
+		iput(root->ifile);
 
 		kfree(root);
 	}
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

origin.patch
mm-zswap-deletion-of-an-unnecessary-check-before-the-function-call-free_percpu.patch
linux-next.patch

