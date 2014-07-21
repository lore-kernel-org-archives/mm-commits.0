From: akpm@linux-foundation.org
Subject: + autofs4-remove-some-unused-inline-functions.patch added to -mm
 tree
Date: Mon, 21 Jul 2014 16:00:08 -0700
Message-ID: <53cd9b78.U9igKwpl8mC3FnS/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:63583 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaGUXAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 19:00:09 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so905012oig.5
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 16:00:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: remove some unused inline functions
has been added to the -mm tree.  Its filename is
     autofs4-remove-some-unused-inline-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-remove-some-unused-inline-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-remove-some-unused-inline-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
