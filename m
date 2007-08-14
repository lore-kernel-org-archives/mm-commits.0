From: akpm@linux-foundation.org
Subject: - frv-connect-up-fallocate.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:02:47 -0700
Message-ID: <200708140502.l7E52lTA032001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44305 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760212AbXHNFD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:03:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     FRV: connect up fallocate
has been removed from the -mm tree.  Its filename was
     frv-connect-up-fallocate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FRV: connect up fallocate
From: David Howells <dhowells@redhat.com>

Connect up the fallocate() system call.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/entry.S  |    1 +
 include/asm-frv/unistd.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/frv/kernel/entry.S~frv-connect-up-fallocate arch/frv/kernel/entry.S
--- a/arch/frv/kernel/entry.S~frv-connect-up-fallocate
+++ a/arch/frv/kernel/entry.S
@@ -1496,6 +1496,7 @@ sys_call_table:
 	.long sys_signalfd
 	.long sys_timerfd
 	.long sys_eventfd
+	.long sys_fallocate
 
 
 syscall_table_size = (. - sys_call_table)
diff -puN include/asm-frv/unistd.h~frv-connect-up-fallocate include/asm-frv/unistd.h
--- a/include/asm-frv/unistd.h~frv-connect-up-fallocate
+++ a/include/asm-frv/unistd.h
@@ -330,10 +330,11 @@
 #define __NR_signalfd		321
 #define __NR_timerfd		322
 #define __NR_eventfd		323
+#define __NR_fallocate		324
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 324
+#define NR_syscalls 325
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
_

Patches currently in -mm which might be from dhowells@redhat.com are

changing-include-asm-generic-pgtableh-for-non-mmu.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
block-hide-the-contents-of-linux-bioh-if-config_block=n.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
remove-frv-usage-of-flush_tlb_pgtables.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
fs-afs-possible-cleanups.patch
ecryptfs-add-key-list-structure-search-keyring.patch
64-bit-i_version-afs-fixes.patch
mutex-subsystem-synchro-test-module.patch
