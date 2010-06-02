From: akpm@linux-foundation.org
Subject: + kmap_atomic-make-kunmap_atomic-harder-to-misuse.patch added to -mm tree
Date: Wed, 02 Jun 2010 14:12:10 -0700
Message-ID: <201006022112.o52LCAjr017183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932805Ab0FBVNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 17:13:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, arnd@arndb.de, benh@kernel.crashing.org, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, hpa@zytor.com, jejb@parisc-linux.org, kyle@mcmartin.ca, linux@arm.linux.org.uk, mingo@redhat.com, paulus@samba.org, ralf@linux-mips.org, rusty@rustcorp.com.au, tglx@linutronix.de, yasutake.koichi@jp.panasonic.com


The patch titled
     kmap_atomic: make kunmap_atomic() harder to misuse
has been added to the -mm tree.  Its filename is
     kmap_atomic-make-kunmap_atomic-harder-to-misuse.patch

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
Subject: kmap_atomic: make kunmap_atomic() harder to misuse
From: Cesar Eduardo Barros <cesarb@cesarb.net>

kunmap_atomic() is currently at level -4 on Rusty's "Hard To Misuse"
list[1] ("Follow common convention and you'll get it wrong"), except in
some architectures when CONFIG_DEBUG_HIGHMEM is set[2][3].

kunmap() takes a pointer to a struct page; kunmap_atomic(), however, takes
takes a pointer to within the page itself.  This seems to once in a while
trip people up (the convention they are following is the one from
kunmap()).

Make it much harder to misuse, by moving it to level 9 on Rusty's list[4]
("The compiler/linker won't let you get it wrong").  This is done by
refusing to build if the type of its first argument is a pointer to a
struct page.

The real kunmap_atomic() is renamed to kunmap_atomic_notypecheck()
(which is what you would call in case for some strange reason calling it
with a pointer to a struct page is not incorrect in your code).

The previous version of this patch was compile tested on x86-64.

[1] http://ozlabs.org/~rusty/index.cgi/tech/2008-04-01.html
[2] In these cases, it is at level 5, "Do it right or it will always
    break at runtime."
[3] At least mips and powerpc look very similar, and sparc also seems to
    share a common ancestor with both; there seems to be quite some
    degree of copy-and-paste coding here. The include/asm/highmem.h file
    for these three archs mention x86 CPUs at its top.
[4] http://ozlabs.org/~rusty/index.cgi/tech/2008-03-30.html
[5] As an aside, could someone tell me why mn10300 uses unsigned long as
    the first parameter of kunmap_atomic() instead of void *?

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Russell King <linux@arm.linux.org.uk> (arch/arm)
Cc: Ralf Baechle <ralf@linux-mips.org> (arch/mips)
Cc: David Howells <dhowells@redhat.com> (arch/frv, arch/mn10300)
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com> (arch/mn10300)
Cc: Kyle McMartin <kyle@mcmartin.ca> (arch/parisc)
Cc: Helge Deller <deller@gmx.de> (arch/parisc)
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org> (arch/parisc)
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org> (arch/powerpc)
Cc: Paul Mackerras <paulus@samba.org> (arch/powerpc)
Cc: "David S. Miller" <davem@davemloft.net> (arch/sparc)
Cc: Thomas Gleixner <tglx@linutronix.de> (arch/x86)
Cc: Ingo Molnar <mingo@redhat.com> (arch/x86)
Cc: "H. Peter Anvin" <hpa@zytor.com> (arch/x86)
Cc: Arnd Bergmann <arnd@arndb.de> (include/asm-generic)
Cc: Rusty Russell <rusty@rustcorp.com.au> ("Hard To Misuse" list)
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/highmem.h       |    2 +-
 arch/arm/mm/highmem.c                |    4 ++--
 arch/frv/include/asm/highmem.h       |    2 +-
 arch/mips/include/asm/highmem.h      |    4 ++--
 arch/mips/mm/highmem.c               |    4 ++--
 arch/mn10300/include/asm/highmem.h   |    2 +-
 arch/parisc/include/asm/cacheflush.h |    2 +-
 arch/powerpc/include/asm/highmem.h   |    2 +-
 arch/powerpc/mm/highmem.c            |    4 ++--
 arch/sparc/include/asm/highmem.h     |    2 +-
 arch/sparc/mm/highmem.c              |    4 ++--
 arch/x86/include/asm/highmem.h       |    2 +-
 arch/x86/mm/highmem_32.c             |    4 ++--
 include/linux/highmem.h              |   10 +++++++++-
 14 files changed, 28 insertions(+), 20 deletions(-)

diff -puN arch/arm/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/arm/include/asm/highmem.h
--- a/arch/arm/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/arm/include/asm/highmem.h
@@ -36,7 +36,7 @@ extern void kunmap_high_l1_vipt(struct p
 extern void *kmap(struct page *page);
 extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page, enum km_type type);
-extern void kunmap_atomic(void *kvaddr, enum km_type type);
+extern void kunmap_atomic_notypecheck(void *kvaddr, enum km_type type);
 extern void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
 extern struct page *kmap_atomic_to_page(const void *ptr);
 #endif
diff -puN arch/arm/mm/highmem.c~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/arm/mm/highmem.c
--- a/arch/arm/mm/highmem.c~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/arm/mm/highmem.c
@@ -73,7 +73,7 @@ void *kmap_atomic(struct page *page, enu
 }
 EXPORT_SYMBOL(kmap_atomic);
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+void kunmap_atomic_notypecheck(void *kvaddr, enum km_type type)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	unsigned int idx = type + KM_TYPE_NR * smp_processor_id();
@@ -94,7 +94,7 @@ void kunmap_atomic(void *kvaddr, enum km
 	}
 	pagefault_enable();
 }
-EXPORT_SYMBOL(kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_notypecheck);
 
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
 {
diff -puN arch/frv/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/frv/include/asm/highmem.h
--- a/arch/frv/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/frv/include/asm/highmem.h
@@ -152,7 +152,7 @@ do {									\
 	asm volatile("tlbpr %0,gr0,#4,#1" : : "r"(vaddr) : "memory");	\
 } while(0)
 
-static inline void kunmap_atomic(void *kvaddr, enum km_type type)
+static inline void kunmap_atomic_notypecheck(void *kvaddr, enum km_type type)
 {
 	switch (type) {
         case 0:		__kunmap_atomic_primary(0, 2);	break;
diff -puN arch/mips/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/mips/include/asm/highmem.h
--- a/arch/mips/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/mips/include/asm/highmem.h
@@ -48,14 +48,14 @@ extern void kunmap_high(struct page *pag
 extern void *__kmap(struct page *page);
 extern void __kunmap(struct page *page);
 extern void *__kmap_atomic(struct page *page, enum km_type type);
-extern void __kunmap_atomic(void *kvaddr, enum km_type type);
+extern void __kunmap_atomic_notypecheck(void *kvaddr, enum km_type type);
 extern void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
 extern struct page *__kmap_atomic_to_page(void *ptr);
 
 #define kmap			__kmap
 #define kunmap			__kunmap
 #define kmap_atomic		__kmap_atomic
-#define kunmap_atomic		__kunmap_atomic
+#define kunmap_atomic_notypecheck		__kunmap_atomic_notypecheck
 #define kmap_atomic_to_page	__kmap_atomic_to_page
 
 #define flush_cache_kmaps()	flush_cache_all()
diff -puN arch/mips/mm/highmem.c~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/mips/mm/highmem.c
--- a/arch/mips/mm/highmem.c~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/mips/mm/highmem.c
@@ -64,7 +64,7 @@ void *__kmap_atomic(struct page *page, e
 }
 EXPORT_SYMBOL(__kmap_atomic);
 
-void __kunmap_atomic(void *kvaddr, enum km_type type)
+void __kunmap_atomic_notypecheck(void *kvaddr, enum km_type type)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
@@ -87,7 +87,7 @@ void __kunmap_atomic(void *kvaddr, enum 
 
 	pagefault_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(__kunmap_atomic_notypecheck);
 
 /*
  * This is the same as kmap_atomic() but can map memory that doesn't
diff -puN arch/mn10300/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/mn10300/include/asm/highmem.h
--- a/arch/mn10300/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/mn10300/include/asm/highmem.h
@@ -91,7 +91,7 @@ static inline unsigned long kmap_atomic(
 	return vaddr;
 }
 
-static inline void kunmap_atomic(unsigned long vaddr, enum km_type type)
+static inline void kunmap_atomic_notypecheck(unsigned long vaddr, enum km_type type)
 {
 #if HIGHMEM_DEBUG
 	enum fixed_addresses idx = type + KM_TYPE_NR * smp_processor_id();
diff -puN arch/parisc/include/asm/cacheflush.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/parisc/include/asm/cacheflush.h
--- a/arch/parisc/include/asm/cacheflush.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/parisc/include/asm/cacheflush.h
@@ -132,7 +132,7 @@ static inline void *kmap_atomic(struct p
 	return page_address(page);
 }
 
-static inline void kunmap_atomic(void *addr, enum km_type idx)
+static inline void kunmap_atomic_notypecheck(void *addr, enum km_type idx)
 {
 	kunmap_parisc(addr);
 	pagefault_enable();
diff -puN arch/powerpc/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/powerpc/include/asm/highmem.h
--- a/arch/powerpc/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/powerpc/include/asm/highmem.h
@@ -62,7 +62,7 @@ extern void *kmap_high(struct page *page
 extern void kunmap_high(struct page *page);
 extern void *kmap_atomic_prot(struct page *page, enum km_type type,
 			      pgprot_t prot);
-extern void kunmap_atomic(void *kvaddr, enum km_type type);
+extern void kunmap_atomic_notypecheck(void *kvaddr, enum km_type type);
 
 static inline void *kmap(struct page *page)
 {
diff -puN arch/powerpc/mm/highmem.c~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/powerpc/mm/highmem.c
--- a/arch/powerpc/mm/highmem.c~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/powerpc/mm/highmem.c
@@ -52,7 +52,7 @@ void *kmap_atomic_prot(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_prot);
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+void kunmap_atomic_notypecheck(void *kvaddr, enum km_type type)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
@@ -74,4 +74,4 @@ void kunmap_atomic(void *kvaddr, enum km
 #endif
 	pagefault_enable();
 }
-EXPORT_SYMBOL(kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_notypecheck);
diff -puN arch/sparc/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/sparc/include/asm/highmem.h
--- a/arch/sparc/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/sparc/include/asm/highmem.h
@@ -71,7 +71,7 @@ static inline void kunmap(struct page *p
 }
 
 extern void *kmap_atomic(struct page *page, enum km_type type);
-extern void kunmap_atomic(void *kvaddr, enum km_type type);
+extern void kunmap_atomic_notypecheck(void *kvaddr, enum km_type type);
 extern struct page *kmap_atomic_to_page(void *vaddr);
 
 #define flush_cache_kmaps()	flush_cache_all()
diff -puN arch/sparc/mm/highmem.c~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/sparc/mm/highmem.c
--- a/arch/sparc/mm/highmem.c~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/sparc/mm/highmem.c
@@ -65,7 +65,7 @@ void *kmap_atomic(struct page *page, enu
 }
 EXPORT_SYMBOL(kmap_atomic);
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+void kunmap_atomic_notypecheck(void *kvaddr, enum km_type type)
 {
 #ifdef CONFIG_DEBUG_HIGHMEM
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
@@ -100,7 +100,7 @@ void kunmap_atomic(void *kvaddr, enum km
 
 	pagefault_enable();
 }
-EXPORT_SYMBOL(kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_notypecheck);
 
 /* We may be fed a pagetable here by ptep_to_xxx and others. */
 struct page *kmap_atomic_to_page(void *ptr)
diff -puN arch/x86/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/x86/include/asm/highmem.h
--- a/arch/x86/include/asm/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/x86/include/asm/highmem.h
@@ -61,7 +61,7 @@ void *kmap(struct page *page);
 void kunmap(struct page *page);
 void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot);
 void *kmap_atomic(struct page *page, enum km_type type);
-void kunmap_atomic(void *kvaddr, enum km_type type);
+void kunmap_atomic_notypecheck(void *kvaddr, enum km_type type);
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
 void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
 struct page *kmap_atomic_to_page(void *ptr);
diff -puN arch/x86/mm/highmem_32.c~kmap_atomic-make-kunmap_atomic-harder-to-misuse arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/arch/x86/mm/highmem_32.c
@@ -53,7 +53,7 @@ void *kmap_atomic(struct page *page, enu
 	return kmap_atomic_prot(page, type, kmap_prot);
 }
 
-void kunmap_atomic(void *kvaddr, enum km_type type)
+void kunmap_atomic_notypecheck(void *kvaddr, enum km_type type)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
@@ -102,7 +102,7 @@ struct page *kmap_atomic_to_page(void *p
 EXPORT_SYMBOL(kmap);
 EXPORT_SYMBOL(kunmap);
 EXPORT_SYMBOL(kmap_atomic);
-EXPORT_SYMBOL(kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_notypecheck);
 EXPORT_SYMBOL(kmap_atomic_prot);
 EXPORT_SYMBOL(kmap_atomic_to_page);
 
diff -puN include/linux/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse include/linux/highmem.h
--- a/include/linux/highmem.h~kmap_atomic-make-kunmap_atomic-harder-to-misuse
+++ a/include/linux/highmem.h
@@ -2,6 +2,7 @@
 #define _LINUX_HIGHMEM_H
 
 #include <linux/fs.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 
@@ -72,7 +73,7 @@ static inline void *kmap_atomic(struct p
 }
 #define kmap_atomic_prot(page, idx, prot)	kmap_atomic(page, idx)
 
-#define kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
+#define kunmap_atomic_notypecheck(addr, idx)	do { pagefault_enable(); } while (0)
 #define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
 
@@ -81,6 +82,13 @@ static inline void *kmap_atomic(struct p
 
 #endif /* CONFIG_HIGHMEM */
 
+/* Prevent people trying to call kunmap_atomic() as if it were kunmap() */
+/* kunmap_atomic() should get the return value of kmap_atomic, not the page. */
+#define kunmap_atomic(addr, idx) do { \
+		BUILD_BUG_ON(__same_type((addr), struct page *)); \
+		kunmap_atomic_notypecheck((addr), (idx)); \
+	} while (0)
+
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 #ifndef clear_user_highpage
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
_

Patches currently in -mm which might be from cesarb@cesarb.net are

arch-um-fix-kunmap_atomic-call-in-skas-uaccessc.patch
kmap_atomic-make-kunmap_atomic-harder-to-misuse.patch

