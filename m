From: akpm@linux-foundation.org
Subject: + slab-fix-debug==0-warning.patch added to -mm tree
Date: Wed, 12 Sep 2012 15:38:21 -0700
Message-ID: <20120912232629.8229420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:54136 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2ILX0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 19:26:32 -0400
Received: by lbbge1 with SMTP id ge1so152404lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 16:26:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, penberg@kernel.org


The patch titled
     Subject: slab: fix DEBUG==0 warning
has been added to the -mm tree.  Its filename is
     slab-fix-debug==0-warning.patch

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
Subject: slab: fix DEBUG==0 warning

mm/slab.c:808: warning: '__slab_error' defined but not used

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/slab.c~slab-fix-debug==0-warning mm/slab.c
--- a/mm/slab.c~slab-fix-debug==0-warning
+++ a/mm/slab.c
@@ -803,6 +803,7 @@ static void cache_estimate(unsigned long
 	*left_over = slab_size - nr_objs*buffer_size - mgmt_size;
 }
 
+#if DEBUG
 #define slab_error(cachep, msg) __slab_error(__func__, cachep, msg)
 
 static void __slab_error(const char *function, struct kmem_cache *cachep,
@@ -812,6 +813,7 @@ static void __slab_error(const char *fun
 	       function, cachep->name, msg);
 	dump_stack();
 }
+#endif
 
 /*
  * By default on NUMA we use alien caches to stage the freeing of
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
slab-fix-debug==0-warning.patch

