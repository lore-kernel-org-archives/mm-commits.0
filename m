From: akpm@linux-foundation.org
Subject: [failures] mm-introduce-kernelcore=mirror-option-fix.patch
 removed from -mm tree
Date: Tue, 05 Jan 2016 12:59:33 -0800
Message-ID: <568c2eb5.8/DIaFJKW2H3BWjr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbcAEU7d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jan 2016 15:59:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, izumi.taku@jp.fujitsu.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-kernelcore=mirror-option-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-kernelcore=mirror-option-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a

fix build with CONFIG_HAVE_MEMBLOCK_NODE_MAP=n

Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-introduce-kernelcore=mirror-option-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-kernelcore=mirror-option-fix
+++ a/mm/page_alloc.c
@@ -4486,6 +4486,7 @@ void __meminit memmap_init_zone(unsigned
 						&nr_initialised))
 				break;
 
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 			/*
 			 * if not mirrored_kernelcore and ZONE_MOVABLE exists,
 			 * range from zone_movable_pfn[nid] to end of each node
@@ -4495,7 +4496,6 @@ void __meminit memmap_init_zone(unsigned
 				if (zone == ZONE_NORMAL &&
 				    pfn >= zone_movable_pfn[nid])
 					continue;
-
 			/*
 			 * check given memblock attribute by firmware which
 			 * can affect kernel memory layout.
@@ -4517,6 +4517,7 @@ void __meminit memmap_init_zone(unsigned
 					continue;
 				}
 			}
+#endif
 		}
 
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-printk-introduce-new-format-string-for-flags-fix-2.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-oom-introduce-oom-reaper-fix-fix.patch
mm-oom-introduce-oom-reaper-fix-fix-2.patch
mm-oom-introduce-oom-reaper-checkpatch-fixes.patch
mm-oom-introduce-oom-reaper-fix-3.patch
mm-oom-introduce-oom-reaper-fix-4-fix.patch
mm-oom-introduce-oom-reaper-fix-5-fix.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

