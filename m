From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-kernelh-make-might_fault-to-be-a-nop-for-mmu.patch removed
 from -mm tree
Date: Mon, 16 Dec 2013 12:39:28 -0800
Message-ID: <52af6500.5dEde7D/GKN7bdPp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3LPUj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 15:39:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, mst@redhat.com, axel.lin@ingics.com

Subject: [merged] include-linux-kernelh-make-might_fault-to-be-a-nop-for-mmu.patch removed from -mm tree
To: axel.lin@ingics.com,mst@redhat.com,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 12:39:28 -0800


The patch titled
     Subject: include/linux/kernel.h: make might_fault() a nop for !MMU
has been removed from the -mm tree.  Its filename was
     include-linux-kernelh-make-might_fault-to-be-a-nop-for-mmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: include/linux/kernel.h: make might_fault() a nop for !MMU

The machine cannot fault if !MUU, so make might_fault() a nop for !MMU.

This fixes below build error if
!CONFIG_MMU && (CONFIG_PROVE_LOCKING=y || CONFIG_DEBUG_ATOMIC_SLEEP=y):

arch/arm/kernel/built-in.o: In function `arch_ptrace':
arch/arm/kernel/ptrace.c:852: undefined reference to `might_fault'
arch/arm/kernel/built-in.o: In function `restore_sigframe':
arch/arm/kernel/signal.c:173: undefined reference to `might_fault'
arch/arm/kernel/signal.c:174: undefined reference to `might_fault'
arch/arm/kernel/signal.c:175: undefined reference to `might_fault'
arch/arm/kernel/signal.c:176: undefined reference to `might_fault'
arch/arm/kernel/built-in.o:arch/arm/kernel/signal.c:177: more undefined references to `might_fault' follow
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~include-linux-kernelh-make-might_fault-to-be-a-nop-for-mmu include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-kernelh-make-might_fault-to-be-a-nop-for-mmu
+++ a/include/linux/kernel.h
@@ -193,7 +193,8 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
-#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
+#if defined(CONFIG_MMU) && \
+	(defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP))
 void might_fault(void);
 #else
 static inline void might_fault(void) { }
_

Patches currently in -mm which might be from axel.lin@ingics.com are

fs-ramfs-file-nommuc-make-ramfs_nommu_get_unmapped_area-and-ramfs_nommu_mmap-static.patch
fs-ramfs-move-ramfs_aops-to-inodec.patch
linux-next.patch

