From: akpm@linux-foundation.org
Subject: [folded-merged] userfaultfd-activate-syscall-fix-2.patch removed
 from -mm tree
Date: Fri, 04 Sep 2015 15:29:50 -0700
Message-ID: <55ea1b5e.4tIYDoXJU+dDjPWn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760730AbbIDW3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:29:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, benh@kernel.crashing.org, mpe@ellerman.id.au, paulus@samba.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-activate-syscall-fix-2
has been removed from the -mm tree.  Its filename was
     userfaultfd-activate-syscall-fix-2.patch

This patch was dropped because it was folded into userfaultfd-activate-syscall.patch

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
userfaultfd-activate-syscall.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch

