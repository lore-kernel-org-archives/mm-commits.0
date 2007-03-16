From: akpm@linux-foundation.org
Subject: + revoke-wire-up-i386-system-calls.patch added to -mm tree
Date: Thu, 15 Mar 2007 17:16:01 -0800
Message-ID: <200703160116.l2G1G1A7031764@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47952 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbXCPBQZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 21:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, ak@suse.de, alan@redhat.com, hch@lst.de, linux-arch@vger.kernel.org, mtk-manpages@gmx.net


The patch titled
     revoke: wire up i386 system calls
has been added to the -mm tree.  Its filename is
     revoke-wire-up-i386-system-calls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revoke: wire up i386 system calls
From: Pekka Enberg <penberg@cs.helsinki.fi>

Make revokeat and frevoke system calls available to user-space on i386.

Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Andi Kleen <ak@suse.de>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/syscall_table.S |    2 ++
 include/asm-i386/unistd.h        |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/syscall_table.S~revoke-wire-up-i386-system-calls arch/i386/kernel/syscall_table.S
--- a/arch/i386/kernel/syscall_table.S~revoke-wire-up-i386-system-calls
+++ a/arch/i386/kernel/syscall_table.S
@@ -320,3 +320,5 @@ ENTRY(sys_call_table)
 	.long sys_getcpu
 	.long sys_epoll_pwait
 	.long sys_lutimesat		/* 320 */
+ 	.long sys_revokeat
+ 	.long sys_frevoke
diff -puN include/asm-i386/unistd.h~revoke-wire-up-i386-system-calls include/asm-i386/unistd.h
--- a/include/asm-i386/unistd.h~revoke-wire-up-i386-system-calls
+++ a/include/asm-i386/unistd.h
@@ -326,10 +326,12 @@
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
 #define __NR_lutimesat		320
+#define __NR_revokeat		321
+#define __NR_frevoke		322
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 321
+#define NR_syscalls 323
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
