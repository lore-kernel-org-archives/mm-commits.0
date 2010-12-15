From: akpm@linux-foundation.org
Subject: [merged] mm-install_special_mapping-skips-security_file_mmap-check-fix.patch removed from -mm tree
Date: Wed, 15 Dec 2010 13:04:52 -0800
Message-ID: <201012152107.oBFL7Xrx006021__2580.19308462298$1292447328$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350Ab0LOVIh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 16:08:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eugene@redhat.com, greg@kroah.com, jmorris@namei.org, kees.cook@canonical.com, randy.dunlap@oracle.com, stable@kernel.org, swiecki@google.com, taviso@cmpxch


The patch titled
     mm-install_special_mapping-skips-security_file_mmap-check-fix
has been removed from the -mm tree.  Its filename was
     mm-install_special_mapping-skips-security_file_mmap-check-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-install_special_mapping-skips-security_file_mmap-check-fix
From: Andrew Morton <akpm@linux-foundation.org>

preserve security_file_mmap() and insert_vm_struct return values

Cc: <stable@kernel.org>
Cc: Eugene Teo <eugene@redhat.com>
Cc: Greg KH <greg@kroah.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Robert Swiecki <swiecki@google.com>
Cc: Tavis Ormandy <taviso@cmpxchg8b.com>
Cc: Tavis Ormandy <taviso@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN mm/mmap.c~mm-install_special_mapping-skips-security_file_mmap-check-fix mm/mmap.c
--- a/mm/mmap.c~mm-install_special_mapping-skips-security_file_mmap-check-fix
+++ a/mm/mmap.c
@@ -2463,6 +2463,7 @@ int install_special_mapping(struct mm_st
 			    unsigned long vm_flags, struct page **pages)
 {
 	struct vm_area_struct *vma;
+	int ret;
 
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (unlikely(vma == NULL))
@@ -2479,21 +2480,21 @@ int install_special_mapping(struct mm_st
 	vma->vm_ops = &special_mapping_vmops;
 	vma->vm_private_data = pages;
 
-	if (security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1)) {
-		kmem_cache_free(vm_area_cachep, vma);
-		return -EPERM;
-	}
-
-	if (unlikely(insert_vm_struct(mm, vma))) {
-		kmem_cache_free(vm_area_cachep, vma);
-		return -ENOMEM;
-	}
+	ret = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
+	if (ret < 0)
+		goto out;
+
+	ret = insert_vm_struct(mm, vma);
+	if (ret < 0)
+		goto out;
 
 	mm->total_vm += len >> PAGE_SHIFT;
 
 	perf_event_mmap(vma);
-
 	return 0;
+out:
+	kmem_cache_free(vm_area_cachep, vma);
+	return ret;
 }
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
delayacct-fix-iotop-on-x86_64-fix.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-async-pps-event-handler-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

