From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-add-missing-annotation-for-migrate_read_lock.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 18:59:46 -0700
Message-ID: <20200408015946.ppdagkfJS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbi.octave@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: add missing annotation for migrate_read_lock()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-add-missing-annotation-for-migrate_read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/zsmalloc: add missing annotation for migrate_read_lock()

Sparse reports a warning at migrate_read_lock()()

 warning: context imbalance in migrate_read_lock() - wrong count at exit

The root cause is the missing annotation at migrate_read_lock()
Add the missing __acquires(&zspage->lock) annotation

Link: http://lkml.kernel.org/r/20200214204741.94112-11-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-add-missing-annotation-for-migrate_read_lock
+++ a/mm/zsmalloc.c
@@ -1833,7 +1833,7 @@ static void migrate_lock_init(struct zsp
 	rwlock_init(&zspage->lock);
 }
 
-static void migrate_read_lock(struct zspage *zspage)
+static void migrate_read_lock(struct zspage *zspage) __acquires(&zspage->lock)
 {
 	read_lock(&zspage->lock);
 }
_

Patches currently in -mm which might be from jbi.octave@gmail.com are
