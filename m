From: akpm@linux-foundation.org
Subject: + simplify-module_get_kallsym-by-dropping-length-arg.patch added to -mm tree
Date: Tue, 03 Apr 2007 17:10:22 -0700
Message-ID: <200704040010.l340AMvf007284@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49704 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946038AbXDDALD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 20:11:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, rusty@rustcorp.com.au


The patch titled
     Simplify module_get_kallsym() by dropping length arg
has been added to the -mm tree.  Its filename is
     simplify-module_get_kallsym-by-dropping-length-arg.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Simplify module_get_kallsym() by dropping length arg
From: Alexey Dobriyan <adobriyan@sw.ru>

module_get_kallsym() could in theory truncate module symbol name to fit in
buffer, but nobody does this.  Always use KSYM_NAME_LEN + 1 bytes for name.

Suggested by lg^WRusty.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    5 ++---
 kernel/kallsyms.c      |    2 +-
 kernel/module.c        |    5 +++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/module.h~simplify-module_get_kallsym-by-dropping-length-arg include/linux/module.h
--- a/include/linux/module.h~simplify-module_get_kallsym-by-dropping-length-arg
+++ a/include/linux/module.h
@@ -374,7 +374,7 @@ int is_module_address(unsigned long addr
 /* Returns module and fills in value, defined and namebuf, or NULL if
    symnum out of range. */
 struct module *module_get_kallsym(unsigned int symnum, unsigned long *value,
-				char *type, char *name, size_t namelen);
+				char *type, char *name);
 
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name);
@@ -532,8 +532,7 @@ static inline const char *module_address
 
 static inline struct module *module_get_kallsym(unsigned int symnum,
 						unsigned long *value,
-						char *type, char *name,
-						size_t namelen)
+						char *type, char *name)
 {
 	return NULL;
 }
diff -puN kernel/kallsyms.c~simplify-module_get_kallsym-by-dropping-length-arg kernel/kallsyms.c
--- a/kernel/kallsyms.c~simplify-module_get_kallsym-by-dropping-length-arg
+++ a/kernel/kallsyms.c
@@ -312,7 +312,7 @@ static int get_ksymbol_mod(struct kallsy
 {
 	iter->owner = module_get_kallsym(iter->pos - kallsyms_num_syms,
 					 &iter->value, &iter->type,
-					 iter->name, sizeof(iter->name));
+					 iter->name);
 	if (iter->owner == NULL)
 		return 0;
 
diff -puN kernel/module.c~simplify-module_get_kallsym-by-dropping-length-arg kernel/module.c
--- a/kernel/module.c~simplify-module_get_kallsym-by-dropping-length-arg
+++ a/kernel/module.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/moduleloader.h>
 #include <linux/init.h>
+#include <linux/kallsyms.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -2200,7 +2201,7 @@ const char *module_address_lookup(unsign
 }
 
 struct module *module_get_kallsym(unsigned int symnum, unsigned long *value,
-				char *type, char *name, size_t namelen)
+				char *type, char *name)
 {
 	struct module *mod;
 
@@ -2210,7 +2211,7 @@ struct module *module_get_kallsym(unsign
 			*value = mod->symtab[symnum].st_value;
 			*type = mod->symtab[symnum].st_info;
 			strlcpy(name, mod->strtab + mod->symtab[symnum].st_name,
-				namelen);
+				KSYM_NAME_LEN + 1);
 			mutex_unlock(&module_mutex);
 			return mod;
 		}
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
git-cpufreq.patch
2621-rc5-mm3-fix-e1000-compilation.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
proc-remove-pathetic-deleted-warn_on.patch
add-file-position-info-to-proc.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-oom_score-oops-re-badness.patch
protect-tty-drivers-list-with-tty_mutex.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
