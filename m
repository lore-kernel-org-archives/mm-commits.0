From: akpm@linux-foundation.org
Subject: + mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch added to -mm tree
Date: Fri, 08 Jun 2012 13:12:43 -0700
Message-ID: <20120608201243.4E57EA02F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:40834 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab2FHUMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 16:12:44 -0400
Received: by ghbz15 with SMTP id z15so203756ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 13:12:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, penberg@cs.helsinki.fi, pshelar@nicira.com


The patch titled
     Subject: mm-fix-slab-page-_count-corruption-when-using-slub-fix
has been added to the -mm tree.  Its filename is
     mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm-fix-slab-page-_count-corruption-when-using-slub-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

