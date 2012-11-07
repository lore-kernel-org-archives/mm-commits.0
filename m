From: akpm@linux-foundation.org
Subject: + mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch added to -mm tree
Date: Wed, 07 Nov 2012 13:02:18 -0800
Message-ID: <20121107210219.069405C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:42919 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab2KGVCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 16:02:22 -0500
Received: by mail-la0-f74.google.com with SMTP id j13so135420lah.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 13:02:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andi@firstfloor.org, aquini@redhat.com, konrad.wilk@oracle.com, mel@csn.ul.ie, minchan@kernel.org, mst@redhat.com, riel@redhat.com, rusty@rustcorp.com.au


The patch titled
     Subject: mm-introduce-a-common-interface-for-balloon-pages-mobility-fix
has been added to the -mm tree.  Its filename is
     mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch

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
Subject: mm-introduce-a-common-interface-for-balloon-pages-mobility-fix

fix build with CONFIG_BALLOON_COMPACTION=n

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 balloon_compaction.c               |    0 
 include/linux/balloon_compaction.h |    6 ++----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/balloon_compaction.h~mm-introduce-a-common-interface-for-balloon-pages-mobility-fix include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-introduce-a-common-interface-for-balloon-pages-mobility-fix
+++ a/include/linux/balloon_compaction.h
@@ -207,10 +207,8 @@ static inline gfp_t balloon_mapping_gfp_
 	return GFP_HIGHUSER;
 }
 
-static inline void balloon_event_count(enum vm_event_item item)
-{
-	return;
-}
+/* A macro, to avoid generating references to the undefined COMPACTBALLOON* */
+#define balloon_event_count(item) do { } while (0)
 
 static inline bool balloon_compaction_check(void)
 {
diff -puN include/linux/migrate.h~mm-introduce-a-common-interface-for-balloon-pages-mobility-fix include/linux/migrate.h
diff -puN include/linux/pagemap.h~mm-introduce-a-common-interface-for-balloon-pages-mobility-fix include/linux/pagemap.h
diff -puN mm/Kconfig~mm-introduce-a-common-interface-for-balloon-pages-mobility-fix mm/Kconfig
diff -puN mm/Makefile~mm-introduce-a-common-interface-for-balloon-pages-mobility-fix mm/Makefile
diff -puN mm/balloon_compaction.c~mm-introduce-a-common-interface-for-balloon-pages-mobility-fix mm/balloon_compaction.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
irq-tsk-comm-is-an-array-fix.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

