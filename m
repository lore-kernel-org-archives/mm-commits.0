From: akpm@linux-foundation.org
Subject: + module-fix-up-config_kallsyms=n-build.patch added to -mm tree
Date: Thu, 24 Sep 2009 21:06:53 -0700
Message-ID: <200909250406.n8P46rPt009069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbZIYEHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Sep 2009 00:07:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, jbeulich@novell.com, rusty@rustcorp.com.au


The patch titled
     module: fix up CONFIG_KALLSYMS=n build.
has been added to the -mm tree.  Its filename is
     module-fix-up-config_kallsyms=n-build.patch

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
Subject: module: fix up CONFIG_KALLSYMS=n build.
From: Paul Mundt <lethal@linux-sh.org>

Starting from commit 4a4962263f07d14660849ec134ee42b63e95ea9a "reduce
symbol table for loaded modules (v2)", the kernel/module.c build is broken
with CONFIG_KALLSYMS disabled.

  CC      kernel/module.o
kernel/module.c:1995: warning: type defaults to 'int' in declaration of 'Elf_Hdr'
kernel/module.c:1995: error: expected ';', ',' or ')' before '*' token
kernel/module.c: In function 'load_module':
kernel/module.c:2203: error: 'strmap' undeclared (first use in this function)
kernel/module.c:2203: error: (Each undeclared identifier is reported only once
kernel/module.c:2203: error: for each function it appears in.)
kernel/module.c:2239: error: 'symoffs' undeclared (first use in this function)
kernel/module.c:2239: error: implicit declaration of function 'layout_symtab'
kernel/module.c:2240: error: 'stroffs' undeclared (first use in this function)
make[1]: *** [kernel/module.o] Error 1
make: *** [kernel/module.o] Error 2

There are three different issues:

    - layout_symtab() takes a const Elf_Ehdr

    - layout_symtab() needs to return a value

    - symoffs/stroffs/strmap are referenced by the load_module() code
      despite being ifdefed out, which seems unnecessary given the noop
      behaviour of layout_symtab()/add_kallsyms() in the case of
      CONFIG_KALLSYMS=n.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/module.c~module-fix-up-config_kallsyms=n-build kernel/module.c
--- a/kernel/module.c~module-fix-up-config_kallsyms=n-build
+++ a/kernel/module.c
@@ -1992,12 +1992,14 @@ static inline unsigned long layout_symta
 					  Elf_Shdr *sechdrs,
 					  unsigned int symindex,
 					  unsigned int strindex,
-					  const Elf_Hdr *hdr,
+					  const Elf_Ehdr *hdr,
 					  const char *secstrings,
 					  unsigned long *pstroffs,
 					  unsigned long *strmap)
 {
+	return 0;
 }
+
 static inline void add_kallsyms(struct module *mod,
 				Elf_Shdr *sechdrs,
 				unsigned int shnum,
@@ -2081,9 +2083,8 @@ static noinline struct module *load_modu
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
-#ifdef CONFIG_KALLSYMS
 	unsigned long symoffs, stroffs, *strmap;
-#endif
+
 	mm_segment_t old_fs;
 
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
procfs-disable-per-task-stack-usage-on-nommu.patch
nommu-fix-map_private-mmap-of-objects-where-the-data-can-be-mapped-directly.patch
module-fix-up-config_kallsyms=n-build.patch
mtd-maps-gpio-addr-flash-fix-up-the-generic_gpio=n-build.patch
linux-next.patch
mmc-make-the-configuration-memory-resource-optional.patch
tmio_mmc-optionally-support-using-platform-clock.patch
sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch

