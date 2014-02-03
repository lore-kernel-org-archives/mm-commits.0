From: akpm@linux-foundation.org
Subject: + fs-udf-superc-add-__init-to-init_inodecache.patch added to -mm
 tree
Date: Mon, 03 Feb 2014 14:48:19 -0800
Message-ID: <52f01cb3.bhXQ1N5NhtusJT9g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaBCWsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 17:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + fs-udf-superc-add-__init-to-init_inodecache.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 14:48:19 -0800


The patch titled
     Subject: fs/udf/super.c: add __init to init_inodecache()
has been added to the -mm tree.  Its filename is
     fs-udf-superc-add-__init-to-init_inodecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-udf-superc-add-__init-to-init_inodecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-udf-superc-add-__init-to-init_inodecache.patch

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
Subject: fs/udf/super.c: add __init to init_inodecache()

init_inodecache is only called by __init init_udf_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/udf/super.c~fs-udf-superc-add-__init-to-init_inodecache fs/udf/super.c
--- a/fs/udf/super.c~fs-udf-superc-add-__init-to-init_inodecache
+++ a/fs/udf/super.c
@@ -175,7 +175,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	udf_inode_cachep = kmem_cache_create("udf_inode_cache",
 					     sizeof(struct udf_inode_info),
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-udf-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch

