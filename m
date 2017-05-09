From: akpm@linux-foundation.org
Subject: + mm-vmalloc-fix-vmalloc-users-tracking-properly.patch added to
 -mm tree
Date: Tue, 09 May 2017 13:31:05 -0700
Message-ID: <59122709.f5yRsuIbq3DheTwN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54092 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752049AbdEIUbG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 16:31:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, geert@linux-m68k.org, tklauser@distanz.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: fix vmalloc users tracking properly
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-vmalloc-users-tracking-properly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-vmalloc-users-tracking-properly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-vmalloc-users-tracking-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmalloc: fix vmalloc users tracking properly

1f5307b1e094 ("mm, vmalloc: properly track vmalloc users") has pulled
asm/pgtable.h include dependency to linux/vmalloc.h and that turned out
to be a bad idea for some architectures. E.g. m68k fails with
   In file included from arch/m68k/include/asm/pgtable_mm.h:145:0,
                    from arch/m68k/include/asm/pgtable.h:4,
                    from include/linux/vmalloc.h:9,
                    from arch/m68k/kernel/module.c:9:
   arch/m68k/include/asm/mcf_pgtable.h: In function 'nocache_page':
>> arch/m68k/include/asm/mcf_pgtable.h:339:43: error: 'init_mm' undeclared (first use in this function)
    #define pgd_offset_k(address) pgd_offset(&init_mm, address)

as spotted by kernel build bot. nios2 fails for other reason
In file included from ./include/asm-generic/io.h:767:0,
                 from ./arch/nios2/include/asm/io.h:61,
                 from ./include/linux/io.h:25,
                 from ./arch/nios2/include/asm/pgtable.h:18,
                 from ./include/linux/mm.h:70,
                 from ./include/linux/pid_namespace.h:6,
                 from ./include/linux/ptrace.h:9,
                 from ./arch/nios2/include/uapi/asm/elf.h:23,
                 from ./arch/nios2/include/asm/elf.h:22,
                 from ./include/linux/elf.h:4,
                 from ./include/linux/module.h:15,
                 from init/main.c:16:
./include/linux/vmalloc.h: In function '__vmalloc_node_flags':
./include/linux/vmalloc.h:99:40: error: 'PAGE_KERNEL' undeclared (first use in this function); did you mean 'GFP_KERNEL'?

which is due to the newly added #include <asm/pgtable.h>, which on nios2
includes <linux/io.h> and thus <asm/io.h> and <asm-generic/io.h> which
again includes <linux/vmalloc.h>.

Tweaking that around just turns out a bigger headache than necessary. 
This patch reverts 1f5307b1e094 and reimplements the original fix in a
different way.  __vmalloc_node_flags can stay static inline which will
cover vmalloc* functions.  We only have one external user (kvmalloc_node)
and we can export __vmalloc_node_flags_caller and provide the caller
directly.  This is much simpler and it doesn't really need any games with
header files.

Fixes: 1f5307b1e094 ("mm, vmalloc: properly track vmalloc users")
Link: http://lkml.kernel.org/r/20170509153702.GR6481@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Tobias Klauser <tklauser@distanz.ch>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |   17 ++++++-----------
 mm/util.c               |    3 ++-
 mm/vmalloc.c            |   18 +++++++++++++++++-
 3 files changed, 25 insertions(+), 13 deletions(-)

diff -puN include/linux/vmalloc.h~mm-vmalloc-fix-vmalloc-users-tracking-properly include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmalloc-fix-vmalloc-users-tracking-properly
+++ a/include/linux/vmalloc.h
@@ -6,7 +6,6 @@
 #include <linux/list.h>
 #include <linux/llist.h>
 #include <asm/page.h>		/* pgprot_t */
-#include <asm/pgtable.h>	/* PAGE_KERNEL */
 #include <linux/rbtree.h>
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
@@ -83,22 +82,18 @@ extern void *__vmalloc_node_range(unsign
 			const void *caller);
 #ifndef CONFIG_MMU
 extern void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags);
+static inline void *__vmalloc_node_flags_caller(unsigned long size, int node, gfp_t flags, void* caller)
+{
+	return __vmalloc_node_flags(size, node, flags);
+}
 #else
-extern void *__vmalloc_node(unsigned long size, unsigned long align,
-			    gfp_t gfp_mask, pgprot_t prot,
-			    int node, const void *caller);
-
 /*
  * We really want to have this inlined due to caller tracking. This
  * function is used by the highlevel vmalloc apis and so we want to track
  * their callers and inlining will achieve that.
  */
-static inline void *__vmalloc_node_flags(unsigned long size,
-					int node, gfp_t flags)
-{
-	return __vmalloc_node(size, 1, flags, PAGE_KERNEL,
-					node, __builtin_return_address(0));
-}
+extern void *__vmalloc_node_flags_caller(unsigned long size,
+					int node, gfp_t flags, void* caller);
 #endif
 
 extern void vfree(const void *addr);
diff -puN mm/util.c~mm-vmalloc-fix-vmalloc-users-tracking-properly mm/util.c
--- a/mm/util.c~mm-vmalloc-fix-vmalloc-users-tracking-properly
+++ a/mm/util.c
@@ -382,7 +382,8 @@ void *kvmalloc_node(size_t size, gfp_t f
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
-	return __vmalloc_node_flags(size, node, flags);
+	return __vmalloc_node_flags_caller(size, node, flags,
+			__builtin_return_address(0));
 }
 EXPORT_SYMBOL(kvmalloc_node);
 
diff -puN mm/vmalloc.c~mm-vmalloc-fix-vmalloc-users-tracking-properly mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-fix-vmalloc-users-tracking-properly
+++ a/mm/vmalloc.c
@@ -1649,6 +1649,9 @@ void *vmap(struct page **pages, unsigned
 }
 EXPORT_SYMBOL(vmap);
 
+static void *__vmalloc_node(unsigned long size, unsigned long align,
+			    gfp_t gfp_mask, pgprot_t prot,
+			    int node, const void *caller);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, int node)
 {
@@ -1791,7 +1794,7 @@ fail:
  *	with mm people.
  *
  */
-void *__vmalloc_node(unsigned long size, unsigned long align,
+static void *__vmalloc_node(unsigned long size, unsigned long align,
 			    gfp_t gfp_mask, pgprot_t prot,
 			    int node, const void *caller)
 {
@@ -1806,6 +1809,19 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
+static inline void *__vmalloc_node_flags(unsigned long size,
+					int node, gfp_t flags)
+{
+	return __vmalloc_node(size, 1, flags, PAGE_KERNEL,
+					node, __builtin_return_address(0));
+}
+
+
+void *__vmalloc_node_flags_caller(unsigned long size, int node, gfp_t flags, void *caller)
+{
+	return __vmalloc_node(size, 1, flags, PAGE_KERNEL, node, caller);
+}
+
 /**
  *	vmalloc  -  allocate virtually contiguous memory
  *	@size:		allocation size
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmalloc-fix-vmalloc-users-tracking-properly.patch

