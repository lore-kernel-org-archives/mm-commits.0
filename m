From: akpm@linux-foundation.org
Subject: + cross-memory-attach-make-it-kconfigurable.patch added to -mm tree
Date: Fri, 27 Apr 2012 16:22:29 -0700
Message-ID: <20120427232229.B0EA8A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:56697 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2D0XWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 19:22:31 -0400
Received: by wejx9 with SMTP id x9so60931wej.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 16:22:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cyeoh@au1.ibm.com, yeohc@au1.ibm.com


The patch titled
     Subject: Cross Memory Attach: make it Kconfigurable
has been added to the -mm tree.  Its filename is
     cross-memory-attach-make-it-kconfigurable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: Cross Memory Attach: make it Kconfigurable

Patches currently in -mm which might be from cyeoh@au1.ibm.com are

cross-memory-attach-make-it-kconfigurable.patch
aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch

