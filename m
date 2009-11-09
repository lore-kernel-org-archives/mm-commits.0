From: akpm@linux-foundation.org
Subject: + mm-make-totalhigh_pages-unsigned-long.patch added to -mm tree
Date: Sun, 08 Nov 2009 16:01:51 -0800
Message-ID: <200911090001.nA901pUD031601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbZKIADZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Nov 2009 19:03:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andreas.fenkart@streamunlimited.com, dhowells@redhat.com, hpa@zytor.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com, mingo@elte.hu, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, tglx@linutronix.de


The patch titled
     mm: make totalhigh_pages unsigned long
has been added to the -mm tree.  Its filename is
     mm-make-totalhigh_pages-unsigned-long.patch

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
Subject: mm: make totalhigh_pages unsigned long
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>

Makes it consistent with the extern declaration, used when CONFIG_HIGHMEM
is set Removes redundant casts in printout messages

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c               |    2 +-
 arch/mips/mm/init.c              |    2 +-
 arch/mips/sgi-ip27/ip27-memory.c |    2 +-
 arch/mn10300/mm/init.c           |    3 +--
 arch/score/mm/init.c             |    2 +-
 arch/x86/mm/init_32.c            |    3 +--
 include/linux/highmem.h          |    2 +-
 7 files changed, 7 insertions(+), 9 deletions(-)

diff -puN arch/arm/mm/init.c~mm-make-totalhigh_pages-unsigned-long arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~mm-make-totalhigh_pages-unsigned-long
+++ a/arch/arm/mm/init.c
@@ -616,7 +616,7 @@ void __init mem_init(void)
 		"%dK data, %dK init, %luK highmem)\n",
 		nr_free_pages() << (PAGE_SHIFT-10), codesize >> 10,
 		datasize >> 10, initsize >> 10,
-		(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
+		totalhigh_pages << (PAGE_SHIFT-10));
 
 	if (PAGE_SIZE >= 16384 && num_physpages <= 128) {
 		extern int sysctl_overcommit_memory;
diff -puN arch/mips/mm/init.c~mm-make-totalhigh_pages-unsigned-long arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~mm-make-totalhigh_pages-unsigned-long
+++ a/arch/mips/mm/init.c
@@ -424,7 +424,7 @@ void __init mem_init(void)
 	       reservedpages << (PAGE_SHIFT-10),
 	       datasize >> 10,
 	       initsize >> 10,
-	       (unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
+	       totalhigh_pages << (PAGE_SHIFT-10));
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
diff -puN arch/mips/sgi-ip27/ip27-memory.c~mm-make-totalhigh_pages-unsigned-long arch/mips/sgi-ip27/ip27-memory.c
--- a/arch/mips/sgi-ip27/ip27-memory.c~mm-make-totalhigh_pages-unsigned-long
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -505,5 +505,5 @@ void __init mem_init(void)
 	       (num_physpages - tmp) << (PAGE_SHIFT-10),
 	       datasize >> 10,
 	       initsize >> 10,
-	       (unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
+	       totalhigh_pages << (PAGE_SHIFT-10));
 }
diff -puN arch/mn10300/mm/init.c~mm-make-totalhigh_pages-unsigned-long arch/mn10300/mm/init.c
--- a/arch/mn10300/mm/init.c~mm-make-totalhigh_pages-unsigned-long
+++ a/arch/mn10300/mm/init.c
@@ -118,8 +118,7 @@ void __init mem_init(void)
 	       reservedpages << (PAGE_SHIFT - 10),
 	       datasize >> 10,
 	       initsize >> 10,
-	       (unsigned long) (totalhigh_pages << (PAGE_SHIFT - 10))
-	       );
+	       totalhigh_pages << (PAGE_SHIFT - 10));
 }
 
 /*
diff -puN arch/score/mm/init.c~mm-make-totalhigh_pages-unsigned-long arch/score/mm/init.c
--- a/arch/score/mm/init.c~mm-make-totalhigh_pages-unsigned-long
+++ a/arch/score/mm/init.c
@@ -111,7 +111,7 @@ void __init mem_init(void)
 			ram << (PAGE_SHIFT-10), codesize >> 10,
 			reservedpages << (PAGE_SHIFT-10), datasize >> 10,
 			initsize >> 10,
-			(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
+			totalhigh_pages << (PAGE_SHIFT-10));
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
diff -puN arch/x86/mm/init_32.c~mm-make-totalhigh_pages-unsigned-long arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-make-totalhigh_pages-unsigned-long
+++ a/arch/x86/mm/init_32.c
@@ -892,8 +892,7 @@ void __init mem_init(void)
 		reservedpages << (PAGE_SHIFT-10),
 		datasize >> 10,
 		initsize >> 10,
-		(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10))
-	       );
+		totalhigh_pages << (PAGE_SHIFT-10));
 
 	printk(KERN_INFO "virtual kernel memory layout:\n"
 		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
diff -puN include/linux/highmem.h~mm-make-totalhigh_pages-unsigned-long include/linux/highmem.h
--- a/include/linux/highmem.h~mm-make-totalhigh_pages-unsigned-long
+++ a/include/linux/highmem.h
@@ -46,7 +46,7 @@ void kmap_flush_unused(void);
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
 
-#define totalhigh_pages 0
+#define totalhigh_pages 0UL
 
 #ifndef ARCH_HAS_KMAP
 static inline void *kmap(struct page *page)
_

Patches currently in -mm which might be from andreas.fenkart@streamunlimited.com are

mm-make-totalhigh_pages-unsigned-long.patch

