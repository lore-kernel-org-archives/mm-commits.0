From: akpm@linux-foundation.org
Subject: [folded-merged] mm-support-madvisemadv_free-fix-2-fix.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 16:25:58 -0800
Message-ID: <56998e16.iIIuGVRHKQez9ush%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030229AbcAPAZ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:25:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-support-madvisemadv_free-fix-2-fix
has been removed from the -mm tree.  Its filename was
     mm-support-madvisemadv_free-fix-2-fix.patch

This patch was dropped because it was folded into mm-support-madvisemadv_free.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-support-madvisemadv_free-fix-2-fix

small cleanups

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-support-madvisemadv_free-fix-2-fix mm/rmap.c
--- a/mm/rmap.c~mm-support-madvisemadv_free-fix-2-fix
+++ a/mm/rmap.c
@@ -1608,7 +1608,7 @@ int try_to_unmap(struct page *page, enum
 
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
-		.arg = (void *)&rp,
+		.arg = &rp,
 		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 	};
@@ -1654,7 +1654,6 @@ int try_to_unmap(struct page *page, enum
 int try_to_munlock(struct page *page)
 {
 	int ret;
-
 	struct rmap_private rp = {
 		.flags = TTU_MUNLOCK,
 		.lazyfreed = 0,
@@ -1662,7 +1661,7 @@ int try_to_munlock(struct page *page)
 
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
-		.arg = (void *)&rp,
+		.arg = &rp,
 		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-support-madvisemadv_free.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch

