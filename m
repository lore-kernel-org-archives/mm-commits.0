From: akpm@linux-foundation.org
Subject: + mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch added to -mm tree
Date: Tue, 06 Nov 2012 13:27:53 -0800
Message-ID: <20121106212754.33B44100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:54215 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2KFV14 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 16:27:56 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so97297qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 13:27:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, riel@redhat.com


The patch titled
     Subject: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix
has been added to the -mm tree.  Its filename is
     mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch

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
Subject: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix
+++ a/fs/hugetlbfs/inode.c
@@ -1049,7 +1049,7 @@ static int __init init_hugetlbfs_fs(void
 		goto out;
 
 	i = 0;
-	for_each_hstate (h) {
+	for_each_hstate(h) {
 		char buf[50];
 		unsigned ps_kb = 1U << (h->order + PAGE_SHIFT - 10);
 
@@ -1058,9 +1058,8 @@ static int __init init_hugetlbfs_fs(void
 							buf);
 
 		if (IS_ERR(hugetlbfs_vfsmount[i])) {
-				pr_err(
-			"hugetlb: Cannot mount internal hugetlbfs for page size %uK",
-			       ps_kb);
+			pr_err("hugetlb: Cannot mount internal hugetlbfs for "
+				"page size %uK", ps_kb);
 			error = PTR_ERR(hugetlbfs_vfsmount[i]);
 			hugetlbfs_vfsmount[i] = NULL;
 		}
@@ -1090,7 +1089,7 @@ static void __exit exit_hugetlbfs_fs(voi
 	rcu_barrier();
 	kmem_cache_destroy(hugetlbfs_inode_cachep);
 	i = 0;
-	for_each_hstate (h)
+	for_each_hstate(h)
 		kern_unmount(hugetlbfs_vfsmount[i++]);
 	unregister_filesystem(&hugetlbfs_fs_type);
 	bdi_destroy(&hugetlbfs_backing_dev_info);
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
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

