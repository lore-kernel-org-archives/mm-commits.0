From: akpm@linux-foundation.org
Subject: + slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix.patch added to -mm tree
Date: Thu, 01 May 2014 13:33:23 -0700
Message-ID: <5362af93.rydpC7PZAU+LRJ9n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaEAUdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2014 16:33:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tglx@linutronix.de, sasha.levin@oracle.com, rmk@arm.linux.org.uk, penberg@kernel.org, greg@kroah.com, cl@linux.com, bvanassche@acm.org, akpm@linux-foundation.org

Subject: + slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix.patch added to -mm tree
To: akpm@linux-foundation.org,bvanassche@acm.org,cl@linux.com,greg@kroah.com,penberg@kernel.org,rmk@arm.linux.org.uk,sasha.levin@oracle.com,tglx@linutronix.de,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 01 May 2014 13:33:23 -0700


The patch titled
     Subject: slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix
has been added to the -mm tree.  Its filename is
     slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix.patch

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
Subject: slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix

fix CONFIG_SYSFS=n build even more

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    5 +++++
 mm/slab.h                |    1 -
 mm/slub.c                |    2 --
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/slub_def.h~slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix
+++ a/include/linux/slub_def.h
@@ -103,6 +103,11 @@ struct kmem_cache {
 
 #ifdef CONFIG_SYSFS
 #define SLAB_SUPPORTS_SYSFS
+void sysfs_slab_remove(struct kmem_cache *);
+#else
+static inline void sysfs_slab_remove(struct kmem_cache *s)
+{
+}
 #endif
 
 #endif /* _LINUX_SLUB_DEF_H */
diff -puN mm/slab.h~slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix mm/slab.h
--- a/mm/slab.h~slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix
+++ a/mm/slab.h
@@ -57,7 +57,6 @@ struct mem_cgroup;
 struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
 		   unsigned long flags, void (*ctor)(void *));
-void sysfs_slab_remove(struct kmem_cache *);
 #else
 static inline struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
diff -puN mm/slub.c~slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix mm/slub.c
--- a/mm/slub.c~slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix
+++ a/mm/slub.c
@@ -215,8 +215,6 @@ static void memcg_propagate_slab_attrs(s
 static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
 static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
 							{ return 0; }
-static inline void sysfs_slab_remove(struct kmem_cache *s) { }
-
 static inline void memcg_propagate_slab_attrs(struct kmem_cache *s) { }
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix-fix.patch
slub-use-sysfses-release-mechanism-for-kmem_cache-fix.patch
slub-use-sysfses-release-mechanism-for-kmem_cache-fix-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

