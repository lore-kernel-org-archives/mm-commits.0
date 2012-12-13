From: akpm@linux-foundation.org
Subject: + mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch added to -mm tree
Date: Thu, 13 Dec 2012 13:49:49 -0800
Message-ID: <20121213214950.86270200065@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:41908 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab2LMVtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Dec 2012 16:49:53 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so1867wib.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Dec 2012 13:49:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, jiang.liu@huawei.com, mhocko@suse.cz, wujianguo@huawei.com


The patch titled
     Subject: mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch

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
Subject: mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix

tweak coding-style, remove pointless __init on inlined function

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |    4 +++-
 mm/hugetlb_cgroup.c            |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/hugetlb_cgroup.h~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix
+++ a/include/linux/hugetlb_cgroup.h
@@ -111,7 +111,9 @@ hugetlb_cgroup_uncharge_cgroup(int idx, 
 	return;
 }
 
-static inline void __init hugetlb_cgroup_file_init() {}
+static inline void hugetlb_cgroup_file_init()
+{
+}
 
 static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
 					  struct page *newhpage)
diff -puN mm/hugetlb_cgroup.c~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix
+++ a/mm/hugetlb_cgroup.c
@@ -382,7 +382,7 @@ void __init hugetlb_cgroup_file_init()
 {
 	struct hstate *h;
 
-	for_each_hstate(h)
+	for_each_hstate(h) {
 		/*
 		 * Add cgroup control files only if the huge page consists
 		 * of more than two normal pages. This is because we use
@@ -390,6 +390,7 @@ void __init hugetlb_cgroup_file_init()
 		 */
 		if (huge_page_order(h) >= HUGETLB_CGROUP_MIN_ORDER)
 			__hugetlb_cgroup_file_init(hstate_index(h));
+	}
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
hwpoison-hugetlbfs-fix-rss-counter-warning.patch
mm-memoryc-remove-unused-code-from-do_wp_page.patch
linux-next.patch
linux-next-rejects.patch
linux-next-rejects-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
irq-tsk-comm-is-an-array.patch
block-remove-deadlock-in-disk_clear_events-fix.patch
block-prevent-race-cleanup-fix.patch
mm.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
slub-slub-specific-propagation-changes-fix.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

