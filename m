From: akpm@linux-foundation.org
Subject: + frv-connect-up-fallocate.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:45:19 -0700
Message-ID: <200708012245.l71MjJP9021323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbXHAWqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:46:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     FRV: connect up fallocate
has been added to the -mm tree.  Its filename is
     frv-connect-up-fallocate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
frv-connect-up-fallocate.patch
changing-include-asm-generic-pgtableh-for-non-mmu.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
remove-frv-usage-of-flush_tlb_pgtables.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
fs-afs-possible-cleanups.patch
ecryptfs-add-key-list-structure-search-keyring.patch
64-bit-i_version-afs-fixes.patch
mutex-subsystem-synchro-test-module.patch
