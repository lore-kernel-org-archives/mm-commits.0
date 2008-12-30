From: akpm@linux-foundation.org
Subject: + kmemleak-enable-the-building-of-the-memory-leak-detector.patch added to -mm tree
Date: Mon, 29 Dec 2008 16:23:11 -0800
Message-ID: <200812300023.mBU0NBPL006089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371AbYL3AX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 19:23:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com


The patch titled
     kmemleak: enable the building of the memory leak detector
has been added to the -mm tree.  Its filename is
     kmemleak-enable-the-building-of-the-memory-leak-detector.patch

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
Subject: kmemleak: enable the building of the memory leak detector
From: Catalin Marinas <catalin.marinas@arm.com>

Add the Kconfig.debug and Makefile entries needed for building kmemleak
into the kernel.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   22 ++++++++++++++++++++++
 mm/Makefile       |    1 +
 2 files changed, 23 insertions(+)

diff -puN lib/Kconfig.debug~kmemleak-enable-the-building-of-the-memory-leak-detector lib/Kconfig.debug
--- a/lib/Kconfig.debug~kmemleak-enable-the-building-of-the-memory-leak-detector
+++ a/lib/Kconfig.debug
@@ -298,6 +298,28 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
+config DEBUG_KMEMLEAK
+	bool "Kernel memory leak detector"
+	default n
+	depends on EXPERIMENTAL
+	select DEBUG_SLAB if SLAB
+	select SLUB_DEBUG if SLUB
+	select DEBUG_FS if SYSFS
+	select STACKTRACE if STACKTRACE_SUPPORT
+	select KALLSYMS
+	help
+	  Say Y here if you want to enable the memory leak
+	  detector. The memory allocation/freeing is traced in a way
+	  similar to the Boehm's conservative garbage collector, the
+	  difference being that the orphan objects are not freed but
+	  only shown in /sys/kernel/debug/kmemleak. Enabling this
+	  feature will introduce an overhead to memory
+	  allocations. See Documentation/kmemleak.txt for more
+	  details.
+
+	  In order to access the kmemleak file, debugfs needs to be
+	  mounted (usually at /sys/kernel/debug).
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)
diff -puN mm/Makefile~kmemleak-enable-the-building-of-the-memory-leak-detector mm/Makefile
--- a/mm/Makefile~kmemleak-enable-the-building-of-the-memory-leak-detector
+++ a/mm/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
+obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
kmemleak-add-the-base-support.patch
kmemleak-add-the-base-support-fix.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch
kmemleak-add-the-slab-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slob-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch
kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks.patch
kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch
kmemleak-add-modules-support.patch
x86-provide-_sdata-in-the-vmlinux_ldss-files.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

