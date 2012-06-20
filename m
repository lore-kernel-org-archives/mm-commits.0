From: akpm@linux-foundation.org
Subject: [folded] mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch removed from -mm tree
Date: Wed, 20 Jun 2012 12:27:48 -0700
Message-ID: <20120620192748.77125A016C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:62368 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab2FTT1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 15:27:50 -0400
Received: by wgbdt11 with SMTP id dt11so449639wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 12:27:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, penberg@cs.helsinki.fi, pshelar@nicira.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-slab-page-_count-corruption-when-using-slub-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch

This patch was dropped because it was folded into mm-fix-slab-page-_count-corruption-when-using-slub.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-slab-page-_count-corruption-when-using-slub-fix

use standard comment layout, tweak comment text

Cc: Pravin B Shelar <pshelar@nicira.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/mm_types.h~mm-fix-slab-page-_count-corruption-when-using-slub-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-fix-slab-page-_count-corruption-when-using-slub-fix
+++ a/include/linux/mm_types.h
@@ -58,13 +58,15 @@ struct page {
 
 		union {
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
-    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
+	defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 			/* Used for cmpxchg_double in slub */
 			unsigned long counters;
 #else
-			/* Keep _count separate from slub cmpxchg_double data,
-			 * As rest of double word is protected by slab_lock
-			 * but _count is not. */
+			/*
+			 * Keep _count separate from slub cmpxchg_double data.
+			 * As the rest of the double word is protected by
+			 * slab_lock but _count is not.
+			 */
 			unsigned counters;
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
mm-fix-slab-page-_count-corruption-when-using-slub.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
memcg-prevent-from-oom-with-too-many-dirty-pages-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
backlight-l4f00242t03-use-devm_gpio_request_one-fix.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

