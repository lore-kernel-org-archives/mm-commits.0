From: akpm@linux-foundation.org
Subject: + fs-ufs-superc-add-__init-to-init_inodecache.patch added to -mm
 tree
Date: Wed, 05 Feb 2014 14:10:06 -0800
Message-ID: <52f2b6be.B7xx4PR1y2AaHRKa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaBEWKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 17:10:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, fabf@skynet.be

Subject: + fs-ufs-superc-add-__init-to-init_inodecache.patch added to -mm tree
To: fabf@skynet.be,dushistov@mail.ru
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 14:10:06 -0800


The patch titled
     Subject: fs/ufs/super.c: add __init to init_inodecache()
has been added to the -mm tree.  Its filename is
     fs-ufs-superc-add-__init-to-init_inodecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ufs-superc-add-__init-to-init_inodecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ufs-superc-add-__init-to-init_inodecache.patch

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
Subject: fs/ufs/super.c: add __init to init_inodecache()

init_inodecache is only called by __init init_ufs_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ufs/super.c~fs-ufs-superc-add-__init-to-init_inodecache fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-superc-add-__init-to-init_inodecache
+++ a/fs/ufs/super.c
@@ -1444,7 +1444,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	ufs_inode_cachep = kmem_cache_create("ufs_inode_cache",
 					     sizeof(struct ufs_inode_info),
_

Patches currently in -mm which might be from fabf@skynet.be are

ufs-sb-mutex-merge-mutex_destroy.patch
fs-udf-superc-add-__init-to-init_inodecache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch

