From: akpm@linux-foundation.org
Subject: + fs-minix-inodec-add-__init-to-init_inodecache.patch added to
 -mm tree
Date: Thu, 06 Feb 2014 12:47:50 -0800
Message-ID: <52f3f4f6.kQAWPLzMRcehK+S7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaBFUrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Feb 2014 15:47:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + fs-minix-inodec-add-__init-to-init_inodecache.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Thu, 06 Feb 2014 12:47:50 -0800


The patch titled
     Subject: fs/minix/inode.c: add __init to init_inodecache()
has been added to the -mm tree.  Its filename is
     fs-minix-inodec-add-__init-to-init_inodecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-minix-inodec-add-__init-to-init_inodecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-minix-inodec-add-__init-to-init_inodecache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/minix/inode.c: add __init to init_inodecache()

init_inodecache is only called by __init init_minix_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/minix/inode.c~fs-minix-inodec-add-__init-to-init_inodecache fs/minix/inode.c
--- a/fs/minix/inode.c~fs-minix-inodec-add-__init-to-init_inodecache
+++ a/fs/minix/inode.c
@@ -86,7 +86,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	minix_inode_cachep = kmem_cache_create("minix_inode_cache",
 					     sizeof(struct minix_inode_info),
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-minix-inodec-add-__init-to-init_inodecache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
linux-next.patch
fs-udf-superc-add-__init-to-init_inodecache.patch

