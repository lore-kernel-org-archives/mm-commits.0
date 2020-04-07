From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 083/166] mm/zsmalloc: add missing annotation for
 migrate_read_unlock()
Date: Mon, 06 Apr 2020 20:08:24 -0700
Message-ID: <20200407030824.LLdWpa9bU%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDIZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:25 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbi.octave@gmail.com, linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/zsmalloc: add missing annotation for migrate_read_unlock()

Sparse reports a warning at migrate_read_unlock()()

 warning: context imbalance in migrate_read_unlock() - unexpected unlock

The root cause is the missing annotation at migrate_read_unlock()
Add the missing __releases(&zspage->lock) annotation

Link: http://lkml.kernel.org/r/20200214204741.94112-12-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-add-missing-annotation-for-migrate_read_unlock
+++ a/mm/zsmalloc.c
@@ -1838,7 +1838,7 @@ static void migrate_read_lock(struct zsp
 	read_lock(&zspage->lock);
 }
 
-static void migrate_read_unlock(struct zspage *zspage)
+static void migrate_read_unlock(struct zspage *zspage) __releases(&zspage->lock)
 {
 	read_unlock(&zspage->lock);
 }
_
