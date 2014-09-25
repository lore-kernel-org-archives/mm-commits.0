From: akpm@linux-foundation.org
Subject: + mm-support-compiling-out-madvise-and-fadvise.patch added to -mm tree
Date: Thu, 25 Sep 2014 12:12:51 -0700
Message-ID: <54246933.BDe43zCWM+4Mn+B6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaIYTMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 15:12:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, dave@stgolabs.net, hannes@cmpxchg.org, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: support compiling out madvise and fadvise
has been added to the -mm tree.  Its filename is
     mm-support-compiling-out-madvise-and-fadvise.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-support-compiling-out-madvise-and-fadvise.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-support-compiling-out-madvise-and-fadvise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: mm: support compiling out madvise and fadvise

Many embedded systems will not need these syscalls, and omitting them
saves space.  Add a new EXPERT config option CONFIG_ADVISE_SYSCALLS
(default y) to support compiling them out.

bloat-o-meter:
add/remove: 0/3 grow/shrink: 0/0 up/down: 0/-2250 (-2250)
function                                     old     new   delta
sys_fadvise64                                 57       -     -57
sys_fadvise64_64                             691       -    -691
sys_madvise                                 1502       -   -1502

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig    |   10 ++++++++++
 kernel/sys_ni.c |    3 +++
 mm/Makefile     |    8 ++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff -puN init/Kconfig~mm-support-compiling-out-madvise-and-fadvise init/Kconfig
--- a/init/Kconfig~mm-support-compiling-out-madvise-and-fadvise
+++ a/init/Kconfig
@@ -1526,6 +1526,16 @@ config AIO
 	  by some high performance threaded applications. Disabling
 	  this option saves about 7k.
 
+config ADVISE_SYSCALLS
+	bool "Enable madvise/fadvise syscalls" if EXPERT
+	default y
+	help
+	  This option enables the madvise and fadvise syscalls, used by
+	  applications to advise the kernel about their future memory or file
+	  usage, improving performance. If building an embedded system where no
+	  applications use these syscalls, you can disable this option to save
+	  space.
+
 config PCI_QUIRKS
 	default y
 	bool "Enable PCI quirk workarounds" if EXPERT
diff -puN kernel/sys_ni.c~mm-support-compiling-out-madvise-and-fadvise kernel/sys_ni.c
--- a/kernel/sys_ni.c~mm-support-compiling-out-madvise-and-fadvise
+++ a/kernel/sys_ni.c
@@ -156,6 +156,9 @@ cond_syscall(sys_process_vm_writev);
 cond_syscall(compat_sys_process_vm_readv);
 cond_syscall(compat_sys_process_vm_writev);
 cond_syscall(sys_uselib);
+cond_syscall(sys_fadvise64);
+cond_syscall(sys_fadvise64_64);
+cond_syscall(sys_madvise);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
diff -puN mm/Makefile~mm-support-compiling-out-madvise-and-fadvise mm/Makefile
--- a/mm/Makefile~mm-support-compiling-out-madvise-and-fadvise
+++ a/mm/Makefile
@@ -3,7 +3,7 @@
 #
 
 mmu-y			:= nommu.o
-mmu-$(CONFIG_MMU)	:= fremap.o gup.o highmem.o madvise.o memory.o mincore.o \
+mmu-$(CONFIG_MMU)	:= fremap.o gup.o highmem.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
 			   vmalloc.o pagewalk.o pgtable-generic.o
 
@@ -11,7 +11,7 @@ ifdef CONFIG_CROSS_MEMORY_ATTACH
 mmu-$(CONFIG_MMU)	+= process_vm_access.o
 endif
 
-obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
+obj-y			:= filemap.o mempool.o oom_kill.o \
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   util.o mmzone.o vmstat.o backing-dev.o \
@@ -28,6 +28,10 @@ else
 	obj-y		+= bootmem.o
 endif
 
+obj-$(CONFIG_ADVISE_SYSCALLS)	+= fadvise.o
+ifdef CONFIG_MMU
+	obj-$(CONFIG_ADVISE_SYSCALLS)	+= madvise.o
+endif
 obj-$(CONFIG_HAVE_MEMBLOCK) += memblock.o
 
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
_

Patches currently in -mm which might be from josh@joshtriplett.org are

efi-bgrt-add-error-handling-inform-the-user-when-ignoring-the-bgrt.patch
mm-support-compiling-out-madvise-and-fadvise.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
linux-next.patch

