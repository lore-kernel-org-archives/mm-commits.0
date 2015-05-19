From: akpm@linux-foundation.org
Subject: + userfaultfd-activate-syscall.patch added to -mm tree
Date: Tue, 19 May 2015 14:39:00 -0700
Message-ID: <555bad74.9w0iT2RdfQuz8kR5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbbESVjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 17:39:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: activate syscall
has been added to the -mm tree.  Its filename is
     userfaultfd-activate-syscall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-activate-syscall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-activate-syscall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: activate syscall

This activates the userfaultfd syscall.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/systbl.h      |    1 +
 arch/powerpc/include/uapi/asm/unistd.h |    1 +
 arch/x86/syscalls/syscall_32.tbl       |    1 +
 arch/x86/syscalls/syscall_64.tbl       |    1 +
 include/linux/syscalls.h               |    1 +
 kernel/sys_ni.c                        |    1 +
 6 files changed, 6 insertions(+)

diff -puN arch/powerpc/include/asm/systbl.h~userfaultfd-activate-syscall arch/powerpc/include/asm/systbl.h
--- a/arch/powerpc/include/asm/systbl.h~userfaultfd-activate-syscall
+++ a/arch/powerpc/include/asm/systbl.h
@@ -368,3 +368,4 @@ SYSCALL_SPU(memfd_create)
 SYSCALL_SPU(bpf)
 COMPAT_SYS(execveat)
 PPC64ONLY(switch_endian)
+SYSCALL_SPU(userfaultfd)
diff -puN arch/powerpc/include/uapi/asm/unistd.h~userfaultfd-activate-syscall arch/powerpc/include/uapi/asm/unistd.h
--- a/arch/powerpc/include/uapi/asm/unistd.h~userfaultfd-activate-syscall
+++ a/arch/powerpc/include/uapi/asm/unistd.h
@@ -386,5 +386,6 @@
 #define __NR_bpf		361
 #define __NR_execveat		362
 #define __NR_switch_endian	363
+#define __NR_userfaultfd	364
 
 #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
diff -puN arch/x86/syscalls/syscall_32.tbl~userfaultfd-activate-syscall arch/x86/syscalls/syscall_32.tbl
--- a/arch/x86/syscalls/syscall_32.tbl~userfaultfd-activate-syscall
+++ a/arch/x86/syscalls/syscall_32.tbl
@@ -365,3 +365,4 @@
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
 358	i386	execveat		sys_execveat			stub32_execveat
+359	i386	userfaultfd		sys_userfaultfd
diff -puN arch/x86/syscalls/syscall_64.tbl~userfaultfd-activate-syscall arch/x86/syscalls/syscall_64.tbl
--- a/arch/x86/syscalls/syscall_64.tbl~userfaultfd-activate-syscall
+++ a/arch/x86/syscalls/syscall_64.tbl
@@ -329,6 +329,7 @@
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
+323	common	userfaultfd		sys_userfaultfd
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff -puN include/linux/syscalls.h~userfaultfd-activate-syscall include/linux/syscalls.h
--- a/include/linux/syscalls.h~userfaultfd-activate-syscall
+++ a/include/linux/syscalls.h
@@ -810,6 +810,7 @@ asmlinkage long sys_timerfd_gettime(int
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_eventfd2(unsigned int count, int flags);
 asmlinkage long sys_memfd_create(const char __user *uname_ptr, unsigned int flags);
+asmlinkage long sys_userfaultfd(int flags);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 asmlinkage long sys_old_readdir(unsigned int, struct old_linux_dirent __user *, unsigned int);
 asmlinkage long sys_pselect6(int, fd_set __user *, fd_set __user *,
diff -puN kernel/sys_ni.c~userfaultfd-activate-syscall kernel/sys_ni.c
--- a/kernel/sys_ni.c~userfaultfd-activate-syscall
+++ a/kernel/sys_ni.c
@@ -218,6 +218,7 @@ cond_syscall(compat_sys_timerfd_gettime)
 cond_syscall(sys_eventfd);
 cond_syscall(sys_eventfd2);
 cond_syscall(sys_memfd_create);
+cond_syscall(sys_userfaultfd);
 
 /* performance counters: */
 cond_syscall(sys_perf_event_open);
_

Patches currently in -mm which might be from aarcange@redhat.com are

thp-cleanup-how-khugepaged-enters-freezer.patch
mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch

