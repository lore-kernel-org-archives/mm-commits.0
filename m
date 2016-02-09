From: akpm@linux-foundation.org
Subject: + mm-compaction-introduce-kcompactd-fix.patch added to -mm tree
Date: Tue, 09 Feb 2016 12:12:42 -0800
Message-ID: <56ba483a.C90j6uvUF5koPt/D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbcBIUMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 15:12:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: fix build errors with kcompactd
has been added to the -mm tree.  Its filename is
     mm-compaction-introduce-kcompactd-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-introduce-kcompactd-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-introduce-kcompactd-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-compaction-introduce-kcompactd-fix.patch
profile-hide-unused-functions-when-config_proc_fs.patch

