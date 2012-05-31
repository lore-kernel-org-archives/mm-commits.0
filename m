From: akpm@linux-foundation.org
Subject: [merged] cross-memory-attach-make-it-kconfigurable.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:37 -0700
Message-ID: <20120531191437.4FDEFA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:48199 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab2EaTOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:39 -0400
Received: by vbnl22 with SMTP id l22so134122vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyeoh@au1.ibm.com, yeohc@au1.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Cross Memory Attach: make it Kconfigurable
has been removed from the -mm tree.  Its filename was
     cross-memory-attach-make-it-kconfigurable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Christopher Yeoh <cyeoh@au1.ibm.com>
Subject: Cross Memory Attach: make it Kconfigurable

Add a Kconfig option to allow people who don't want cross memory attach to
not have it included in their build.

Signed-off-by: Chris Yeoh <yeohc@au1.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig  |   10 ++++++++++
 mm/Makefile |    7 +++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN mm/Kconfig~cross-memory-attach-make-it-kconfigurable mm/Kconfig
--- a/mm/Kconfig~cross-memory-attach-make-it-kconfigurable
+++ a/mm/Kconfig
@@ -349,6 +349,16 @@ choice
 	  benefit.
 endchoice
 
+config CROSS_MEMORY_ATTACH
+	bool "Cross Memory Support"
+	depends on MMU
+	default y
+	help
+	  Enabling this option adds the system calls process_vm_readv and
+	  process_vm_writev which allow a process with the correct privileges
+	  to directly read from or write to to another process's address space.
+	  See the man page for more details.
+
 #
 # UP and nommu archs use km based percpu allocator
 #
diff -puN mm/Makefile~cross-memory-attach-make-it-kconfigurable mm/Makefile
--- a/mm/Makefile~cross-memory-attach-make-it-kconfigurable
+++ a/mm/Makefile
@@ -5,8 +5,11 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o pagewalk.o pgtable-generic.o \
-			   process_vm_access.o
+			   vmalloc.o pagewalk.o pgtable-generic.o
+
+ifdef CONFIG_CROSS_MEMORY_ATTACH
+mmu-$(CONFIG_MMU)	+= process_vm_access.o
+endif
 
 obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
_

Patches currently in -mm which might be from cyeoh@au1.ibm.com are

origin.patch
aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch

