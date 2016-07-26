From: akpm@linux-foundation.org
Subject: [folded-merged] mm-add-nr_zsmalloc-to-vmstat-fix.patch removed
 from -mm tree
Date: Tue, 26 Jul 2016 14:58:24 -0700
Message-ID: <5797dd00.n8ANRE+FhKWbGqBR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbcGZV6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chan.jeong@lge.com, chanho.min@lge.com, minchan@kernel.org, sangseok.lee@lge.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-nr_zsmalloc-to-vmstat-fix
has been removed from the -mm tree.  Its filename was
     mm-add-nr_zsmalloc-to-vmstat-fix.patch

This patch was dropped because it was folded into mm-add-nr_zsmalloc-to-vmstat.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-nr_zsmalloc-to-vmstat-fix

fix build with CONFIG_ZSMALLOC=m

Cc: Chan Gyun Jeong <chan.jeong@lge.com>
Cc: Chanho Min <chanho.min@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/vmstat.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-add-nr_zsmalloc-to-vmstat-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-nr_zsmalloc-to-vmstat-fix
+++ a/include/linux/mmzone.h
@@ -140,7 +140,7 @@ enum zone_stat_item {
 	NR_DIRTIED,		/* page dirtyings since bootup */
 	NR_WRITTEN,		/* page writings since bootup */
 	NR_PAGES_SCANNED,	/* pages scanned since last reclaim */
-#ifdef CONFIG_ZSMALLOC
+#if IS_ENABLED(CONFIG_ZSMALLOC)
 	NR_ZSMALLOC,
 #endif
 #ifdef CONFIG_NUMA
diff -puN mm/vmstat.c~mm-add-nr_zsmalloc-to-vmstat-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-add-nr_zsmalloc-to-vmstat-fix
+++ a/mm/vmstat.c
@@ -718,7 +718,7 @@ const char * const vmstat_text[] = {
 	"nr_dirtied",
 	"nr_written",
 	"nr_pages_scanned",
-#ifdef CONFIG_ZSMALLOC
+#if IS_ENABLED(CONFIG_ZSMALLOC)
 	"nr_zsmalloc",
 #endif
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-nr_zsmalloc-to-vmstat.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch

