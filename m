From: akpm@linux-foundation.org
Subject: [folded-merged] mm-compaction-introduce-kcompactd-fix.patch
 removed from -mm tree
Date: Thu, 17 Mar 2016 13:51:08 -0700
Message-ID: <56eb18bc.P1Mwjfd598gyV/Ql%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935675AbcCQUvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:51:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: fix build errors with kcompactd
has been removed from the -mm tree.  Its filename was
     mm-compaction-introduce-kcompactd-fix.patch

This patch was dropped because it was folded into mm-compaction-introduce-kcompactd.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm, compaction: fix build errors with kcompactd

The newly added kcompactd code introduces multiple build errors:

include/linux/compaction.h:91:12: error: 'kcompactd_run' defined but not used [-Werror=unused-function]
mm/compaction.c:1953:2: error: implicit declaration of function 'hotcpu_notifier' [-Werror=implicit-function-declaration]

This marks the new empty wrapper functions as 'inline' to avoid unused-function warnings,
and includes linux/cpu.h to get the hotcpu_notifier declaration.

Fixes: 8364acdfa45a ("mm, compaction: introduce kcompactd")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    6 +++---
 mm/compaction.c            |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-introduce-kcompactd-fix include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-introduce-kcompactd-fix
+++ a/include/linux/compaction.h
@@ -88,15 +88,15 @@ static inline bool compaction_deferred(s
 	return true;
 }
 
-static int kcompactd_run(int nid)
+static inline int kcompactd_run(int nid)
 {
 	return 0;
 }
-static void kcompactd_stop(int nid)
+static inline void kcompactd_stop(int nid)
 {
 }
 
-static void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx)
+static inline void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx)
 {
 }
 
diff -puN mm/compaction.c~mm-compaction-introduce-kcompactd-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-introduce-kcompactd-fix
+++ a/mm/compaction.c
@@ -7,6 +7,7 @@
  *
  * Copyright IBM Corp. 2007-2010 Mel Gorman <mel@csn.ul.ie>
  */
+#include <linux/cpu.h>
 #include <linux/swap.h>
 #include <linux/migrate.h>
 #include <linux/compaction.h>
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-compaction-introduce-kcompactd.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-2.patch

