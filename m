From: akpm@linux-foundation.org
Subject: + autofs4-remove-unused-autofs4_ispending.patch added to -mm tree
Date: Mon, 21 Jul 2014 16:00:05 -0700
Message-ID: <53cd9b75.zWx2wwCkQgQKaDgI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:47352 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaGUXAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 19:00:06 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2023150pab.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 16:00:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: remove unused autofs4_ispending()
has been added to the -mm tree.  Its filename is
     autofs4-remove-unused-autofs4_ispending.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-remove-unused-autofs4_ispending.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-remove-unused-autofs4_ispending.patch

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
Subject: autofs4: remove unused autofs4_ispending()

Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-remove-unused-autofs4_ispending fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-remove-unused-autofs4_ispending
+++ a/fs/autofs4/autofs_i.h
@@ -143,20 +143,6 @@ static inline int autofs4_oz_mode(struct
 	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
 }
 
-/* Does a dentry have some pending activity? */
-static inline int autofs4_ispending(struct dentry *dentry)
-{
-	struct autofs_info *inf = autofs4_dentry_ino(dentry);
-
-	if (inf->flags & AUTOFS_INF_PENDING)
-		return 1;
-
-	if (inf->flags & AUTOFS_INF_EXPIRING)
-		return 1;
-
-	return 0;
-}
