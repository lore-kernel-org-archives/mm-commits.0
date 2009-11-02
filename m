From: akpm@linux-foundation.org
Subject: + nommu-fix-malloc-performance-by-adding-uninitialized-flag.patch added to -mm tree
Date: Mon, 02 Nov 2009 13:43:34 -0800
Message-ID: <200911022143.nA2LhYVa008520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755550AbZKBVoh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 16:44:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jie.zhang@analog.com, dhowells@redhat.com, gerg@snapgear.com, lethal@linux-sh.org, rgetz@blackfin.uclinux.org, vapier@gentoo.org


The patch titled
     nommu: fix malloc performance by adding uninitialized flag
has been added to the -mm tree.  Its filename is
     nommu-fix-malloc-performance-by-adding-uninitialized-flag.patch

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
Subject: nommu: fix malloc performance by adding uninitialized flag
From: Jie Zhang <jie.zhang@analog.com>

The NOMMU code currently clears all anonymous mmapped memory.  While this
is what we want in the default case, all memory allocation from userspace
under NOMMU has to go through this interface, including malloc() which is
allowed to return uninitialized memory.  This can easily be a significant
performance penalty.  So for constrained embedded systems were security is
irrelevant, allow people to avoid clearing memory unnecessarily.

This also alters the ELF-FDPIC binfmt such that it obtains uninitialised
memory for the brk and stack region.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/nommu-mmap.txt~nommu-fix-malloc-performance-by-adding-uninitialized-flag Documentation/nommu-mmap.txt
--- a/Documentation/nommu-mmap.txt~nommu-fix-malloc-performance-by-adding-uninitialized-flag
+++ a/Documentation/nommu-mmap.txt
@@ -119,6 +119,32 @@ FURTHER NOTES ON NO-MMU MMAP
      granule but will only discard the excess if appropriately configured as
      this has an effect on fragmentation.
 
+ (*) The memory allocated by a request for an anonymous mapping will normally
+     be cleared by the kernel before being returned in accordance with the
+     Linux man pages (ver 2.22 or later).
+
+     In the MMU case this can be achieved with reasonable performance as
+     regions are backed by virtual pages, with the contents only being mapped
+     to cleared physical pages when a write happens on that specific page
+     (prior to which, the pages are effectively mapped to the global zero page
+     from which reads can take place).  This spreads out the time it takes to
+     initialize the contents of a page - depending on the write-usage of the
+     mapping.
+
+     In the no-MMU case, however, anonymous mappings are backed by physical
+     pages, and the entire map is cleared at allocation time.  This can cause
+     significant delays during a userspace malloc() as the C library does an
+     anonymous mapping and the kernel then does a memset for the entire map.
+
+     However, for memory that isn't required to be precleared - such as that
+     returned by malloc() - mmap() can take a MAP_UNINITIALIZED flag to
+     indicate to the kernel that it shouldn't bother clearing the memory before
+     returning it.  Note that CONFIG_MMAP_ALLOW_UNINITIALIZED must be enabled
+     to permit this, otherwise the flag will be ignored.
+
+     uClibc uses this to speed up malloc(), and the ELF-FDPIC binfmt uses this
+     to allocate the brk and stack region.
+
  (*) A list of all the private copy and anonymous mappings on the system is
      visible through /proc/maps in no-MMU mode.
 
diff -puN fs/binfmt_elf_fdpic.c~nommu-fix-malloc-performance-by-adding-uninitialized-flag fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~nommu-fix-malloc-performance-by-adding-uninitialized-flag
+++ a/fs/binfmt_elf_fdpic.c
@@ -380,7 +380,8 @@ static int load_elf_fdpic_binary(struct 
 	down_write(&current->mm->mmap_sem);
 	current->mm->start_brk = do_mmap(NULL, 0, stack_size,
 					 PROT_READ | PROT_WRITE | PROT_EXEC,
-					 MAP_PRIVATE | MAP_ANONYMOUS | MAP_GROWSDOWN,
+					 MAP_PRIVATE | MAP_ANONYMOUS |
+					 MAP_UNINITIALIZED | MAP_GROWSDOWN,
 					 0);
 
 	if (IS_ERR_VALUE(current->mm->start_brk)) {
diff -puN include/asm-generic/mman-common.h~nommu-fix-malloc-performance-by-adding-uninitialized-flag include/asm-generic/mman-common.h
--- a/include/asm-generic/mman-common.h~nommu-fix-malloc-performance-by-adding-uninitialized-flag
+++ a/include/asm-generic/mman-common.h
@@ -19,6 +19,11 @@
 #define MAP_TYPE	0x0f		/* Mask for type of mapping */
 #define MAP_FIXED	0x10		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x20		/* don't use a file */
+#ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
+# define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be uninitialized */
+#else
+# define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
+#endif
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_INVALIDATE	2		/* invalidate the caches */
diff -puN init/Kconfig~nommu-fix-malloc-performance-by-adding-uninitialized-flag init/Kconfig
--- a/init/Kconfig~nommu-fix-malloc-performance-by-adding-uninitialized-flag
+++ a/init/Kconfig
@@ -1095,6 +1095,28 @@ config SLOB
 
 endchoice
 
+config MMAP_ALLOW_UNINITIALIZED
+	bool "Allow mmapped anonymous memory to be uninitialized"
+	depends on EMBEDDED && !MMU
+	default n
+	help
+	  Normally, and according to the Linux spec, anonymous memory obtained
+	  from mmap() has it's contents cleared before it is passed to
+	  userspace.  Enabling this config option allows you to request that
+	  mmap() skip that if it is given an MAP_UNINITIALIZED flag, thus
+	  providing a huge performance boost.  If this option is not enabled,
+	  then the flag will be ignored.
+
+	  This is taken advantage of by uClibc's malloc(), and also by
+	  ELF-FDPIC binfmt's brk and stack allocator.
+
+	  Because of the obvious security issues, this option should only be
+	  enabled on embedded devices where you control what is run in
+	  userspace.  Since that isn't generally a problem on no-MMU systems,
+	  it is normally safe to say Y here.
+
+	  See Documentation/nommu-mmap.txt for more information.
+
 config PROFILING
 	bool "Profiling support (EXPERIMENTAL)"
 	help
diff -puN mm/nommu.c~nommu-fix-malloc-performance-by-adding-uninitialized-flag mm/nommu.c
--- a/mm/nommu.c~nommu-fix-malloc-performance-by-adding-uninitialized-flag
+++ a/mm/nommu.c
@@ -1143,9 +1143,6 @@ static int do_mmap_private(struct vm_are
 		if (ret < rlen)
 			memset(base + ret, 0, rlen - ret);
 
-	} else {
-		/* if it's an anonymous mapping, then just clear it */
-		memset(base, 0, rlen);
 	}
 
 	return 0;
@@ -1343,6 +1340,11 @@ unsigned long do_mmap_pgoff(struct file 
 		goto error_just_free;
 	add_nommu_region(region);
 
+	/* clear anonymous mappings that don't ask for uninitialized data */
+	if (!vma->vm_file && !(flags & MAP_UNINITIALIZED))
+		memset((void *)region->vm_start, 0,
+		       region->vm_end - region->vm_start);
+
 	/* okay... we have a mapping; now we have to register it */
 	result = vma->vm_start;
 
_

Patches currently in -mm which might be from jie.zhang@analog.com are

nommu-fix-malloc-performance-by-adding-uninitialized-flag.patch

