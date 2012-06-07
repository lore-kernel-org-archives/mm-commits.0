From: akpm@linux-foundation.org
Subject: [folded] btree-fix-tree-corruption-in-btree_get_prev-fix.patch removed from -mm tree
Date: Thu, 07 Jun 2012 14:18:11 -0700
Message-ID: <20120607211811.9D129A02F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:33706 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757195Ab2FGVSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2012 17:18:14 -0400
Received: by lagr15 with SMTP id r15so65377lag.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Jun 2012 14:18:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joern@logfs.org, roland@purestorage.com, mm-commits@vger.kernel.org


The patch titled
     Subject: btree-fix-tree-corruption-in-btree_get_prev-fix
has been removed from the -mm tree.  Its filename was
     btree-fix-tree-corruption-in-btree_get_prev-fix.patch

This patch was dropped because it was folded into btree-fix-tree-corruption-in-btree_get_prev.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: btree-fix-tree-corruption-in-btree_get_prev-fix

avoid the double longcpy()

Cc: Joern Engel <joern@logfs.org>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/btree.c~btree-fix-tree-corruption-in-btree_get_prev-fix lib/btree.c
--- a/lib/btree.c~btree-fix-tree-corruption-in-btree_get_prev-fix
+++ a/lib/btree.c
@@ -319,8 +319,8 @@ void *btree_get_prev(struct btree_head *
 
 	if (head->height == 0)
 		return NULL;
-retry:
 	longcpy(key, __key, geo->keylen);
+retry:
 	dec_key(geo, key);
 
 	node = head->node;
@@ -351,7 +351,7 @@ retry:
 	}
 miss:
 	if (retry_key) {
-		longcpy(__key, retry_key, geo->keylen);
+		longcpy(key, retry_key, geo->keylen);
 		retry_key = NULL;
 		goto retry;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
btree-fix-tree-corruption-in-btree_get_prev.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
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

