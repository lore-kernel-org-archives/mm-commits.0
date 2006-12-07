From: akpm@osdl.org
Subject: + zeromap_pte_range-debug.patch added to -mm tree
Date: Wed, 06 Dec 2006 20:13:52 -0800
Message-ID: <200612070413.kB74DqWa028341@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44733 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968706AbWLGENz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 23:13:55 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kB74DqID022621
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 6 Dec 2006 20:13:53 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org


The patch titled
     a
has been added to the -mm tree.  Its filename is
     zeromap_pte_range-debug.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: a
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~zeromap_pte_range-debug mm/memory.c
--- a/mm/memory.c~zeromap_pte_range-debug
+++ a/mm/memory.c
@@ -1121,7 +1121,10 @@ static int zeromap_pte_range(struct mm_s
 		page_cache_get(page);
 		page_add_file_rmap(page);
 		inc_mm_counter(mm, file_rss);
-		BUG_ON(!pte_none(*pte));
+		if (!pte_none(*pte)) {
+			printk("pte_val: %lx\n", pte_val(*pte));
+			BUG();
+		}
 		set_pte_at(mm, addr, pte, zero_pte);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
add-bottom_half.h.patch
drm-sis-linkage-fix.patch
uml-workqueue-build-fix.patch
get-rid-of-zone_table.patch
new-scheme-to-preempt-swap-token.patch
balance_pdgat-cleanup.patch
leak-tracking-for-kmalloc_node.patch
add-numa-node-information-to-struct-device.patch
slab-deprecate-kmem_cache-t.patch
mm-make-compound-page-destructor-handling-explicit.patch
radix-tree-rcu-lockless-readside.patch
swsusp-add-resume_offset-command-line-parameter-rev-2.patch
add-include-linux-freezerh-and-move-definitions-from.patch
convert-pm_sem-to-a-mutex.patch
cciss-set-sector_size-to-2048-for-performance.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets.patch
probe_kernel_address-needs-to-do-set_fs.patch
slab-use-probe_kernel_address.patch
exar-quad-port-serial.patch
vfs_getattr-remove-dead-code.patch
ext3-uninline-large-functions.patch
ext4-uninline-large-functions.patch
sleep-profiling.patch
debug-workqueue-locking-sanity.patch
pcengines-wrap-led-support.patch
driver-base-memoryc-remove-warnings-of.patch
remove-kernel-syscalls.patch
protect-ext2-ioctl-modifying-append_only-immutable-etc-with-i_mutex.patch
remove-hash_highmem.patch
elf-fix-kcore-note-size-calculation.patch
reiserfs-add-missing-d-cache-flushing.patch
smp_call_function_single-check-that-local-interrupts-are-enabled.patch
hotplug-cpu-clean-up-hotcpu_notifier-use.patch
add-return-value-checking-of-get_user-in.patch
handle-per-subsystem-mutexes-for-config_hotplug_cpu-not-set.patch
dz-fixes-to-make-it-work.patch
ext4-balloc-fix-_with_rsv-freeze.patch
ide_scsi-allow-it-to-be-used-for-non-cd-only.patch
make-8250_pnp-serial-driver-work-after.patch
gcc-4-1-0-is-bust.patch
cleanup-include-asm-generic-atomich.patch
struct-seq_operations-and-struct-file_operations-constification.patch

