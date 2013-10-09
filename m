From: akpm@linux-foundation.org
Subject: +
 init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch added to -mm tree
Date: Wed, 09 Oct 2013 14:48:58 -0700
Message-ID: <5255cf4a.MfLTOObRMYc0uTUw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3JIVs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Oct 2013 17:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, prasad@redhat.com, akpm@linux-foundation.org

Subject: + init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch added to -mm tree
To: akpm@linux-foundation.org,prasad@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 09 Oct 2013 14:48:58 -0700


The patch titled
     Subject: init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix
has been added to the -mm tree.  Its filename is
     init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch

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
Subject: init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix

mention that the problem is with the ramdisk, don't print known-to-be-NULL value

Cc: P J P <prasad@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_rd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/do_mounts_rd.c~init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix
+++ a/init/do_mounts_rd.c
@@ -344,8 +344,8 @@ static int __init crd_load(int in_fd, in
 	crd_outfd = out_fd;
 
 	if (!deco) {
-		pr_emerg("Invalid decompression routine: %p; "
-				 "Select appropriate config option.\n", deco);
+		pr_emerg("Invalid ramdisk decompression routine.  "
+			 "Select appropriate config option.\n");
 		panic("Could not decompress initial ramdisk image.");
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ipc-update-locking-scheme-comments-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

