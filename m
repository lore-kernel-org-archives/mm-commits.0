From: akpm@linux-foundation.org
Subject: + mm-introduce-mm_find_pmd-fix.patch added to -mm tree
Date: Thu, 25 Oct 2012 15:35:42 -0700
Message-ID: <20121025223543.70F8C1E13F3@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:57072 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2JYWfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Oct 2012 18:35:44 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so271301vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 25 Oct 2012 15:35:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, lliubbo@gmail.com, mhocko@suse.cz, minchan.kim@gmail.com, nizhan.chen@gmail.com, sfr@canb.auug.org.au


The patch titled
     Subject: mm-introduce-mm_find_pmd-fix
has been added to the -mm tree.  Its filename is
     mm-introduce-mm_find_pmd-fix.patch

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
Subject: mm-introduce-mm_find_pmd-fix

mm/rmap.c: In function 'try_to_unmap_cluster':
mm/rmap.c:1364:9: warning: unused variable 'pud' [-Wunused-variable]
mm/rmap.c:1363:9: warning: unused variable 'pgd' [-Wunused-variable]

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/rmap.c~mm-introduce-mm_find_pmd-fix mm/rmap.c
--- a/mm/rmap.c~mm-introduce-mm_find_pmd-fix
+++ a/mm/rmap.c
@@ -1357,8 +1357,6 @@ static int try_to_unmap_cluster(unsigned
 		struct vm_area_struct *vma, struct page *check_page)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 	pte_t pteval;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pidns-limit-the-nesting-depth-of-pid-namespaces.patch
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
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
selftests-ipc-message-queue-copy-feature-test-checkpatch-fixes.patch
random-make-it-possible-to-enable-debugging-without-rebuild-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

