From: akpm@linux-foundation.org
Subject: [merged] mn10300-wire-up-missing-new-syscalls.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:25 -0800
Message-ID: <201001112019.o0BKJPtY025566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090Ab0AKUUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:20:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, dhowelsl@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: wire up missing new syscalls
has been removed from the -mm tree.  Its filename was
     mn10300-wire-up-missing-new-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: wire up missing new syscalls
From: David Howells <dhowells@redhat.com>

Wire up missing new system calls for MN10300.

Signed-off-by: David Howells <dhowelsl@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/unistd.h |    3 ++-
 arch/mn10300/kernel/entry.S       |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/mn10300/include/asm/unistd.h~mn10300-wire-up-missing-new-syscalls arch/mn10300/include/asm/unistd.h
--- a/arch/mn10300/include/asm/unistd.h~mn10300-wire-up-missing-new-syscalls
+++ a/arch/mn10300/include/asm/unistd.h
@@ -348,10 +348,11 @@
 #define __NR_pwritev		335
 #define __NR_rt_tgsigqueueinfo	336
 #define __NR_perf_event_open	337
+#define __NR_recvmmsg		338
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 338
+#define NR_syscalls 339
 
 /*
  * specify the deprecated syscalls we want to support on this arch
diff -puN arch/mn10300/kernel/entry.S~mn10300-wire-up-missing-new-syscalls arch/mn10300/kernel/entry.S
--- a/arch/mn10300/kernel/entry.S~mn10300-wire-up-missing-new-syscalls
+++ a/arch/mn10300/kernel/entry.S
@@ -724,6 +724,7 @@ ENTRY(sys_call_table)
 	.long sys_pwritev		/* 335 */
 	.long sys_rt_tgsigqueueinfo
 	.long sys_perf_event_open
+	.long sys_recvmmsg
 
 
 nr_syscalls=(.-sys_call_table)/4
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
kernel-credc-use-kmem_cache_free.patch
frv-duplicate-output_buffer-of-e03.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

