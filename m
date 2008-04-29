From: akpm@linux-foundation.org
Subject: + x86-ioremap-add-checks-for-virtual-addresses.patch added to -mm tree
Date: Tue, 29 Apr 2008 14:20:00 -0700
Message-ID: <200804292120.m3TLK0HV010351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763452AbYD2VU7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 17:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86 ioremap(): add checks for virtual addresses
has been added to the -mm tree.  Its filename is
     x86-ioremap-add-checks-for-virtual-addresses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 ioremap(): add checks for virtual addresses
From: Christoph Lameter <clameter@sgi.com>

Add checks to ensure that virtual addresses are not used in invalid contexts.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c     |    1 +
 include/asm-x86/page_32.h |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/ioremap.c~x86-ioremap-add-checks-for-virtual-addresses arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-ioremap-add-checks-for-virtual-addresses
+++ a/arch/x86/mm/ioremap.c
@@ -25,6 +25,7 @@
 
 unsigned long __phys_addr(unsigned long x)
 {
+	VM_BUG_ON(is_vmalloc_addr((void *)x));
 	if (x >= __START_KERNEL_map)
 		return x - __START_KERNEL_map + phys_base;
 	return x - PAGE_OFFSET;
diff -puN include/asm-x86/page_32.h~x86-ioremap-add-checks-for-virtual-addresses include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h~x86-ioremap-add-checks-for-virtual-addresses
+++ a/include/asm-x86/page_32.h
@@ -64,7 +64,12 @@ typedef struct page *pgtable_t;
 #endif
 
 #ifndef __ASSEMBLY__
-#define __phys_addr(x)		((x) - PAGE_OFFSET)
+static inline unsigned long __phys_addr(unsigned long x)
+{
+	VM_BUG_ON(is_vmalloc_addr((void *)x));
+	return x - PAGE_OFFSET;
+}
+
 #define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
 #ifdef CONFIG_FLATMEM
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
ipc-add-definitions-of-ushort_max-and-others.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
x86-use-kbuildh.patch
mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
alpha-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch
sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
avr32-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch
sh-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
git-unionfs.patch
git-pekka.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
x86-ioremap-add-checks-for-virtual-addresses.patch

