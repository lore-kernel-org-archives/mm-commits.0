From: akpm@linux-foundation.org
Subject: + init-do_mounts-add-create_dev-failure-log-fix.patch added to
 -mm tree
Date: Wed, 27 May 2015 16:28:20 -0700
Message-ID: <55665314.qmrtS5D/AmnsFvhN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbbE0X2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 May 2015 19:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dehrenberg@chromium.org, mszeredi@suse.cz, paul.gortmaker@windriver.com, pavel@ucw.cz, snitzer@redhat.com, vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init-do_mounts-add-create_dev-failure-log-fix
has been added to the -mm tree.  Its filename is
     init-do_mounts-add-create_dev-failure-log-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-do_mounts-add-create_dev-failure-log-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-do_mounts-add-create_dev-failure-log-fix.patch

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
Subject: init-do_mounts-add-create_dev-failure-log-fix

simplify printk(), use pr_emerg(), display errno

Cc: Dan Ehrenberg <dehrenberg@chromium.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN init/do_mounts.c~init-do_mounts-add-create_dev-failure-log-fix init/do_mounts.c
--- a/init/do_mounts.c~init-do_mounts-add-create_dev-failure-log-fix
+++ a/init/do_mounts.c
@@ -533,9 +533,13 @@ void __init mount_root(void)
 	}
 #endif
 #ifdef CONFIG_BLOCK
-	if (create_dev("/dev/root", ROOT_DEV) < 0)
-		pr_err("Failed to create %s device !\n", "/dev/root");
-	mount_block_root("/dev/root", root_mountflags);
+	{
+		int err = create_dev("/dev/root", ROOT_DEV);
+
+		if (err < 0)
+			pr_emerg("Failed to create /dev/root: %d\n", err);
+		mount_block_root("/dev/root", root_mountflags);
+	}
 #endif
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
init-do_mounts-add-create_dev-failure-log-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
linux-next-rejects.patch
arch-x86-kvm-mmuc-work-around-gcc-444-bug.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
drivers-gpu-drm-i915-i915_gem_gttc-hack-around-build-error-on-i386.patch
drivers-gpu-drm-i915-i915_gem_gttc-hack-around-build-error-on-i386.patch
a.patch

