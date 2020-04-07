From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 082/166] mm/zsmalloc: add missing annotation for
 migrate_read_lock()
Date: Mon, 06 Apr 2020 20:08:21 -0700
Message-ID: <20200407030821.ZZoGCdggg%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDIX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:23 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbi.octave@gmail.com, linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
