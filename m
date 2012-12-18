From: akpm@linux-foundation.org
Subject: [merged] percpu_rw_semaphore-introduce-config_percpu_rwsem.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:33 -0800
Message-ID: <20121218200633.C576782004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:58093 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2LRUGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:35 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so125742yen.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, anton@redhat.com, mingo@elte.hu, mmarek@suse.cz, mpatocka@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, srikar@linux.vnet.ibm.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: percpu_rw_semaphore: introduce CONFIG_PERCPU_RWSEM
has been removed from the -mm tree.  Its filename was
     percpu_rw_semaphore-introduce-config_percpu_rwsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -9,7 +9,7 @@ endif
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
-	 idr.o int_sqrt.o extable.o percpu-rwsem.o \
+	 idr.o int_sqrt.o extable.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
@@ -40,6 +40,7 @@ obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
+lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

