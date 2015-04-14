From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix.patch
 removed from -mm tree
Date: Tue, 14 Apr 2015 15:11:51 -0700
Message-ID: <552d90a7.0q2udqglQK8PVa80%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbbDNWLw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:11:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert+renesas@glider.be, khilman@kernel.org, marc.zyngier@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix.patch

This patch was dropped because it was folded into mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix

make it conditional on gcc-4.7.3 and arm

Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Kevin Hilman <khilman@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix mm/migrate.c
--- a/mm/migrate.c~mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix
+++ a/mm/migrate.c
@@ -901,10 +901,20 @@ out:
 }
 
 /*
+ * gcc-4.7.3 on arm gets an ICE when inlining unmap_and_move().  Work around
+ * it.
+ */
+#if GCC_VERSION == 40703 && defined(CONFIG_ARM)
+#define ICE_noinline noinline
+#else
+#define ICE_noinline
+#endif
+
+/*
  * Obtain the lock on page, remove all ptes and migrate the page
  * to the newly allocated page in newpage.
  */
-static noinline int unmap_and_move(new_page_t get_new_page,
+static ICE_noinline int unmap_and_move(new_page_t get_new_page,
 				   free_page_t put_new_page,
 				   unsigned long private, struct page *page,
 				   int force, enum migrate_mode mode)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-make-mlog_errno-return-the-errno.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix-fix.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch

