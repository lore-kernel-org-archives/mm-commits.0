From: akpm@linux-foundation.org
Subject: + coda-correctly-invalidate-cached-access-rights.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:29 -0700
Message-ID: <200707130529.l6D5TTb2030787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39543 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbXGMFaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: correctly invalidate cached access rights
has been added to the -mm tree.  Its filename is
     coda-correctly-invalidate-cached-access-rights.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda: correctly invalidate cached access rights
From: Jan Harkes <jaharkes@cs.cmu.edu>

Change the epoch value to forces a refresh instead of clearing the cached
rights mask and block all further accesses to the object.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/coda/cache.c~coda-correctly-invalidate-cached-access-rights fs/coda/cache.c
--- a/fs/coda/cache.c~coda-correctly-invalidate-cached-access-rights
+++ a/fs/coda/cache.c
@@ -43,7 +43,7 @@ void coda_cache_enter(struct inode *inod
 void coda_cache_clear_inode(struct inode *inode)
 {
 	struct coda_inode_info *cii = ITOC(inode);
-        cii->c_cached_perm = 0;
+	cii->c_cached_epoch = atomic_read(&permission_epoch) - 1;
 }
 
 /* remove all acl caches */
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch
coda-correctly-invalidate-cached-access-rights.patch
coda-fix-nlink-updates-for-directories.patch
coda-allow-removal-of-busy-directories.patch
coda-coda-doesnt-track-atime.patch
coda-use-ilookup5.patch
coda-cleanup-dev-cfs-open-and-close-handling.patch
coda-cleanup-for-upcall-handling-path.patch
coda-block-signals-during-upcall-processing.patch
coda-avoid-lockdep-warning-in-coda_readdir.patch
coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch
coda-ignore-returned-values-when-upcalls-return-errors.patch
coda-cleanup-coda_lookup-use-dsplice_alias.patch
coda-cleanup-downcall-handler.patch
coda-remove-struct-coda_sb_info.patch
coda-remove-statistics-counters-from-proc-fs-coda.patch
coda-update-module-information.patch
