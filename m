From: akpm@linux-foundation.org
Subject: + percpu_rw_semaphore-introduce-config_percpu_rwsem.patch added to -mm tree
Date: Mon, 19 Nov 2012 15:06:11 -0800
Message-ID: <20121119230612.C734A200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61690 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2KSXGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 18:06:16 -0500
Received: by mail-wi0-f202.google.com with SMTP id cb5so28703wib.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 15:06:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, anton@redhat.com, mingo@elte.hu, mmarek@suse.cz, mpatocka@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, srikar@linux.vnet.ibm.com, torvalds@linux-foundation.org


The patch titled
     Subject: percpu_rw_semaphore: introduce CONFIG_PERCPU_RWSEM
has been added to the -mm tree.  Its filename is
     percpu_rw_semaphore-introduce-config_percpu_rwsem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: percpu_rw_semaphore: introduce CONFIG_PERCPU_RWSEM

Currently only block_dev and uprobes use percpu_rw_semaphore,
add the config option selected by BLOCK || UPROBES.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig  |    1 +
 block/Kconfig |    1 +
 lib/Kconfig   |    3 +++
 lib/Makefile  |    3 ++-
 4 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/Kconfig~percpu_rw_semaphore-introduce-config_percpu_rwsem arch/Kconfig
--- a/arch/Kconfig~percpu_rw_semaphore-introduce-config_percpu_rwsem
+++ a/arch/Kconfig
@@ -80,6 +80,7 @@ config UPROBES
 	bool "Transparent user-space probes (EXPERIMENTAL)"
 	depends on UPROBE_EVENT && PERF_EVENTS
 	default n
+	select PERCPU_RWSEM
 	help
 	  Uprobes is the user-space counterpart to kprobes: they
 	  enable instrumentation applications (such as 'perf probe')
diff -puN block/Kconfig~percpu_rw_semaphore-introduce-config_percpu_rwsem block/Kconfig
--- a/block/Kconfig~percpu_rw_semaphore-introduce-config_percpu_rwsem
+++ a/block/Kconfig
@@ -4,6 +4,7 @@
 menuconfig BLOCK
        bool "Enable the block layer" if EXPERT
        default y
+       select PERCPU_RWSEM
        help
 	 Provide block layer support for the kernel.
 
diff -puN lib/Kconfig~percpu_rw_semaphore-introduce-config_percpu_rwsem lib/Kconfig
--- a/lib/Kconfig~percpu_rw_semaphore-introduce-config_percpu_rwsem
+++ a/lib/Kconfig
@@ -42,6 +42,9 @@ config GENERIC_IO
 config STMP_DEVICE
 	bool
 
+config PERCPU_RWSEM
+	boolean
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff -puN lib/Makefile~percpu_rw_semaphore-introduce-config_percpu_rwsem lib/Makefile
--- a/lib/Makefile~percpu_rw_semaphore-introduce-config_percpu_rwsem
+++ a/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o earlycpio.o percpu-rwsem.o
+	 is_single_threaded.o plist.o decompress.o earlycpio.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -40,6 +40,7 @@ obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
+lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessarily.patch
percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari-lyfix.patch
percpu_rw_semaphore-kill-writer_mutex-add-write_ctr.patch
percpu_rw_semaphore-add-the-lockdep-annotations.patch
percpu_rw_semaphore-introduce-config_percpu_rwsem.patch
uprobes-use-percpu_rw_semaphore-to-fix-register-unregister-vs-dup_mmap-race.patch
ptrace-introduce-ptrace_o_exitkill.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fdinfo-show-sigmask-for-signalfd-fd-v3.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v6.patch
fs-notify-add-procfs-fdinfo-helper-v6-fix.patch

