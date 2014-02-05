From: akpm@linux-foundation.org
Subject: + fs-adfs-superc-add-__init-to-init_inodecache.patch added to -mm tree
Date: Wed, 05 Feb 2014 14:10:07 -0800
Message-ID: <52f2b6bf.W6CcW6H3D86SLxZS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaBEWKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 17:10:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + fs-adfs-superc-add-__init-to-init_inodecache.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 14:10:07 -0800


The patch titled
     Subject: fs/adfs/super.c: add __init to init_inodecache()
has been added to the -mm tree.  Its filename is
     fs-adfs-superc-add-__init-to-init_inodecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-adfs-superc-add-__init-to-init_inodecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-adfs-superc-add-__init-to-init_inodecache.patch

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
Subject: fs/adfs/super.c: add __init to init_inodecache()

init_inodecache is only called by __init init_adfs_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/adfs/super.c~fs-adfs-superc-add-__init-to-init_inodecache fs/adfs/super.c
--- a/fs/adfs/super.c~fs-adfs-superc-add-__init-to-init_inodecache
+++ a/fs/adfs/super.c
@@ -265,7 +265,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	adfs_inode_cachep = kmem_cache_create("adfs_inode_cache",
 					     sizeof(struct adfs_inode_info),
_

Patches currently in -mm which might be from fabf@skynet.be are

ufs-sb-mutex-merge-mutex_destroy.patch
fs-udf-superc-add-__init-to-init_inodecache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch

