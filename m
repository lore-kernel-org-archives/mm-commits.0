From: akpm@linux-foundation.org
Subject: [merged] autofs4-remove-some-unused-inline-functions.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:38:28 -0700
Message-ID: <53ea6d34.DDAnVjc+sgpNBf4Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:33022 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbaHLTi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:29 -0400
Received: by mail-qc0-f202.google.com with SMTP id r5so472063qcx.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: remove some unused inline functions
has been removed from the -mm tree.  Its filename was
     autofs4-remove-some-unused-inline-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: autofs4: remove some unused inline functions

{__,}manage_dentry_{set,clear}_{automount,transit}

are 4 unused inline functions.  Discard them.

Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |   49 ----------------------------------------
 1 file changed, 49 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-remove-some-unused-inline-functions fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-remove-some-unused-inline-functions
+++ a/fs/autofs4/autofs_i.h
@@ -177,55 +177,6 @@ extern const struct file_operations auto
 extern const struct dentry_operations autofs4_dentry_operations;
 
 /* VFS automount flags management functions */
-
-static inline void __managed_dentry_set_automount(struct dentry *dentry)
-{
-	dentry->d_flags |= DCACHE_NEED_AUTOMOUNT;
-}
-
-static inline void managed_dentry_set_automount(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_set_automount(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_clear_automount(struct dentry *dentry)
-{
-	dentry->d_flags &= ~DCACHE_NEED_AUTOMOUNT;
-}
-
-static inline void managed_dentry_clear_automount(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_clear_automount(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_set_transit(struct dentry *dentry)
-{
-	dentry->d_flags |= DCACHE_MANAGE_TRANSIT;
-}
-
-static inline void managed_dentry_set_transit(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_set_transit(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_clear_transit(struct dentry *dentry)
-{
-	dentry->d_flags &= ~DCACHE_MANAGE_TRANSIT;
-}
-
-static inline void managed_dentry_clear_transit(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_clear_transit(dentry);
-	spin_unlock(&dentry->d_lock);
-}
