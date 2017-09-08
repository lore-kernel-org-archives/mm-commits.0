From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-interval_tree-fast-overlap-detection-fix.patch removed from -mm tree
Date: Fri, 08 Sep 2017 16:02:16 -0700
Message-ID: <59b32178.nf/+bto/5v4yt28n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757289AbdIHXCR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:02:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, dbueso@suse.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier: fix deadlock from typo vm_lock_anon_vma()
has been removed from the -mm tree.  Its filename was
     lib-interval_tree-fast-overlap-detection-fix.patch

This patch was dropped because it was folded into lib-interval_tree-fast-overlap-detection.patch

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/mmu_notifier: fix deadlock from typo vm_lock_anon_vma()

Fix typo introduced by 0c67e6038580e343bd ("lib/interval_tree: fast
overlap detection") which result in deadlock when mm_take_all_locks() is
call (only user being mmu_notifier at this time).

Link: http://lkml.kernel.org/r/20170808225719.20723-1-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~lib-interval_tree-fast-overlap-detection-fix mm/mmap.c
--- a/mm/mmap.c~lib-interval_tree-fast-overlap-detection-fix
+++ a/mm/mmap.c
@@ -3340,7 +3340,7 @@ static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 {
-	if (!test_bit(0, (unsigned long *) &anon_vma->rb_root.rb_root.rb_node)) {
+	if (!test_bit(0, (unsigned long *) &anon_vma->root->rb_root.rb_root.rb_node)) {
 		/*
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
_

Patches currently in -mm which might be from jglisse@redhat.com are

hmm-heterogeneous-memory-management-documentation-v3.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short-v5.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v4.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-v5.patch
mm-zone_device-special-case-put_page-for-device-private-pages-v4.patch
mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch
mm-memcontrol-support-memory_device_private-v4.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device-v7.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3.patch
mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v5.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-migrate-support-un-addressable-zone_device-page-in-migration-v3.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch
mm-device-public-memory-device-memory-cache-coherent-with-cpu-v5.patch
mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch
mm-hmm-avoid-bloating-arch-that-do-not-make-use-of-hmm.patch
mm-hmm-fix-build-when-hmm-is-disabled.patch
lib-interval_tree-fast-overlap-detection.patch

