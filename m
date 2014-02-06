From: akpm@linux-foundation.org
Subject: + fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch added
 to -mm tree
Date: Thu, 06 Feb 2014 12:54:16 -0800
Message-ID: <52f3f678.XOuzuoEGitq9XE98%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaBFUyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Feb 2014 15:54:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Thu, 06 Feb 2014 12:54:16 -0800


The patch titled
     Subject: fs/cifs/cifsfs.c: add __init to cifs_init_inodecache()
has been added to the -mm tree.  Its filename is
     fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch

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
Subject: fs/cifs/cifsfs.c: add __init to cifs_init_inodecache()

cifs_init_inodecache is only called by __init init_cifs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/cifs/cifsfs.c~fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache
+++ a/fs/cifs/cifsfs.c
@@ -1005,7 +1005,7 @@ cifs_init_once(void *inode)
 	init_rwsem(&cifsi->lock_sem);
 }
 
-static int
+static int __init
 cifs_init_inodecache(void)
 {
 	cifs_inode_cachep = kmem_cache_create("cifs_inode_cache",
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
linux-next.patch
fs-udf-superc-add-__init-to-init_inodecache.patch

