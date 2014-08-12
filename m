From: akpm@linux-foundation.org
Subject: [merged] autofs4-remove-unused-autofs4_ispending.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:38:22 -0700
Message-ID: <53ea6d2e.fLQ0qD9M8PpCcLNX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:64490 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbaHLTiX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:23 -0400
Received: by mail-qc0-f202.google.com with SMTP id r5so471747qcx.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: remove unused autofs4_ispending()
has been removed from the -mm tree.  Its filename was
     autofs4-remove-unused-autofs4_ispending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
