From: akpm@linux-foundation.org
Subject: - coda-correctly-invalidate-cached-access-rights.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:57 -0700
Message-ID: <200707192002.l6JK2vOw019801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758077AbXGSUQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: correctly invalidate cached access rights
has been removed from the -mm tree.  Its filename was
     coda-correctly-invalidate-cached-access-rights.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
