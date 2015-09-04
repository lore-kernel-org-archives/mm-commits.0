From: akpm@linux-foundation.org
Subject: + userfaultfd-activate-syscall-fix-2.patch added to -mm tree
Date: Fri, 04 Sep 2015 13:35:52 -0700
Message-ID: <55ea00a8.Iab64WFQZiBP9VOU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646AbbIDUfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 16:35:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, benh@kernel.crashing.org, mpe@ellerman.id.au, paulus@samba.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-activate-syscall-fix-2
has been added to the -mm tree.  Its filename is
     userfaultfd-activate-syscall-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-activate-syscall-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-activate-syscall-fix-2.patch

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
Subject: userfaultfd-activate-syscall-fix-2

don't enable userfaultfd on powerpc, per some email discussion which I've
lost

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/systbl.h      |    1 -
 arch/powerpc/include/asm/unistd.h      |    2 +-
 arch/powerpc/include/uapi/asm/unistd.h |    1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/powerpc/include/asm/systbl.h~userfaultfd-activate-syscall-fix-2 arch/powerpc/include/asm/systbl.h
--- a/arch/powerpc/include/asm/systbl.h~userfaultfd-activate-syscall-fix-2
+++ a/arch/powerpc/include/asm/systbl.h
@@ -368,4 +368,3 @@ SYSCALL_SPU(memfd_create)
 SYSCALL_SPU(bpf)
 COMPAT_SYS(execveat)
 PPC64ONLY(switch_endian)
-SYSCALL_SPU(userfaultfd)
diff -puN arch/powerpc/include/asm/unistd.h~userfaultfd-activate-syscall-fix-2 arch/powerpc/include/asm/unistd.h
--- a/arch/powerpc/include/asm/unistd.h~userfaultfd-activate-syscall-fix-2
+++ a/arch/powerpc/include/asm/unistd.h
@@ -12,7 +12,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define __NR_syscalls		365
+#define __NR_syscalls		364
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff -puN arch/powerpc/include/uapi/asm/unistd.h~userfaultfd-activate-syscall-fix-2 arch/powerpc/include/uapi/asm/unistd.h
--- a/arch/powerpc/include/uapi/asm/unistd.h~userfaultfd-activate-syscall-fix-2
+++ a/arch/powerpc/include/uapi/asm/unistd.h
@@ -386,6 +386,5 @@
 #define __NR_bpf		361
 #define __NR_execveat		362
 #define __NR_switch_endian	363
-#define __NR_userfaultfd	364
 
 #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-activate-syscall-fix-2.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch

