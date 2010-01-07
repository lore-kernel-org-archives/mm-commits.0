From: akpm@linux-foundation.org
Subject: + mn10300-wire-up-missing-new-syscalls.patch added to -mm tree
Date: Wed, 06 Jan 2010 16:28:25 -0800
Message-ID: <201001070028.o070SPMJ027651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932420Ab0AGA2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 19:28:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, dhowelsl@redhat.com


The patch titled
     mn10300: wire up missing new syscalls
has been added to the -mm tree.  Its filename is
     mn10300-wire-up-missing-new-syscalls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

mm-make-totalhigh_pages-unsigned-long.patch
fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack.patch
nommu-avoiding-duplicate-icache-flushes-of-shared-maps.patch
nommu-use-copy__user_page-in-access_process_vm.patch
mn10300-signal-stack-fix.patch
mn10300-objcopy-flags-fix.patch
mn10300-add-cc-clobbers-to-asm-statements.patch
mn10300-wire-up-missing-new-syscalls.patch
fix-several-bogus-includes-on-mn10300-abs2305.patch
mn10300-use-kern_err-not-kern_error.patch
mn10300-use-generic-pci_enable_resources.patch
mn10300-insert-pci-root-bus-resources-for-the-asb2305-devel-motherboard.patch
mn10300-make-the-asb2305s-pcnet32-nic-work-by-using-the-pci-bridges-sram.patch
mn10300-update-the-asb2303-defconfig.patch
kernel-credc-use-kmem_cache_free.patch
frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

