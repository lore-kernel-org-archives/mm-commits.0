From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Tue, 07 Jul 2015 17:24:09 -0700
Message-ID: <559c6da9.1uXEYdrYAQZ/qYDD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbbGHAYK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 20:24:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

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
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/entry.S |   10 +++++++++-
 arch/cris/arch-v32/kernel/entry.S |   10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff -puN arch/cris/arch-v10/kernel/entry.S~linux-next-rejects arch/cris/arch-v10/kernel/entry.S
--- a/arch/cris/arch-v10/kernel/entry.S~linux-next-rejects
+++ a/arch/cris/arch-v10/kernel/entry.S
@@ -955,7 +955,15 @@ sys_call_table:
 	.long sys_process_vm_writev
 	.long sys_kcmp			/* 350 */
 	.long sys_finit_module
-	.long sys_mlock2
+	.long sys_sched_setattr
+	.long sys_sched_getattr
+	.long sys_renameat2
+	.long sys_seccomp		/* 355 */
+	.long sys_getrandom
+	.long sys_memfd_create
+	.long sys_bpf
+	.long sys_execveat
+	.long sys_mlock2		/* 360 */
 	.long sys_munlock2
 	.long sys_munlockall2
 
diff -puN arch/cris/arch-v32/kernel/entry.S~linux-next-rejects arch/cris/arch-v32/kernel/entry.S
--- a/arch/cris/arch-v32/kernel/entry.S~linux-next-rejects
+++ a/arch/cris/arch-v32/kernel/entry.S
@@ -886,7 +886,15 @@ sys_call_table:
 	.long sys_process_vm_writev
 	.long sys_kcmp			/* 350 */
 	.long sys_finit_module
-	.long sys_mlock2
+	.long sys_sched_setattr
+	.long sys_sched_getattr
+	.long sys_renameat2
+	.long sys_seccomp		/* 355 */
+	.long sys_getrandom
+	.long sys_memfd_create
+	.long sys_bpf
+	.long sys_execveat
+	.long sys_mlock2		/* 360 */
 	.long sys_munlock2
 	.long sys_munlockall2
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
openrisc-fix-config_uid16-setting.patch
mm.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
linux-next.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
linux-next-rejects.patch

