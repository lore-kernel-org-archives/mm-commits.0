From: akpm@linux-foundation.org
Subject: - revoke-wire-up-i386-system-calls.patch removed from -mm tree
Date: Mon, 26 Nov 2007 11:36:21 -0800
Message-ID: <200711261936.lAQJaLIe019302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbXKZThX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 14:37:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, ak@suse.de, alan@redhat.com, hch@lst.de, linux-arch@vger.kernel.org, mtk-manpages@gmx.net, mm-commits@vger.kernel.org


The patch titled
     revoke: wire up i386 system calls
has been removed from the -mm tree.  Its filename was
     revoke-wire-up-i386-system-calls.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: revoke: wire up i386 system calls
From: Pekka Enberg <penberg@cs.helsinki.fi>

Make revokeat and frevoke system calls available to user-space on i386.

[akpm@linux-foundation.org: fix 32-bit userspace]
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Andi Kleen <ak@suse.de>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S          |    2 ++
 arch/x86/kernel/syscall_table_32.S |    2 ++
 include/asm-x86/unistd_32.h        |    4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/ia32/ia32entry.S~revoke-wire-up-i386-system-calls arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~revoke-wire-up-i386-system-calls
+++ a/arch/x86/ia32/ia32entry.S
@@ -726,4 +726,6 @@ ia32_sys_call_table:
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
 	.quad sys32_fallocate
+	.quad sys_revokeat		/* 325 */
+	.quad sys_frevoke
 ia32_syscall_end:
diff -puN arch/x86/kernel/syscall_table_32.S~revoke-wire-up-i386-system-calls arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~revoke-wire-up-i386-system-calls
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -324,3 +324,5 @@ ENTRY(sys_call_table)
 	.long sys_timerfd
 	.long sys_eventfd
 	.long sys_fallocate
+	.long sys_revokeat		/* 325 */
+	.long sys_frevoke
diff -puN include/asm-x86/unistd_32.h~revoke-wire-up-i386-system-calls include/asm-x86/unistd_32.h
--- a/include/asm-x86/unistd_32.h~revoke-wire-up-i386-system-calls
+++ a/include/asm-x86/unistd_32.h
@@ -330,10 +330,12 @@
 #define __NR_timerfd		322
 #define __NR_eventfd		323
 #define __NR_fallocate		324
+#define __NR_revokeat		325
+#define __NR_frevoke		326
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
+#define NR_syscalls 327
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

git-unionfs.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-restructure-slab-alloc.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
slab-leaks3-default-y.patch
