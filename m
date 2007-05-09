From: akpm@linux-foundation.org
Subject: - simplify-module_get_kallsym-by-dropping-length-arg.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:43 -0700
Message-ID: <200705090248.l492mhuj009142@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966823AbXEICtY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Simplify module_get_kallsym() by dropping length arg
has been removed from the -mm tree.  Its filename was
     simplify-module_get_kallsym-by-dropping-length-arg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -373,7 +373,7 @@ int is_module_address(unsigned long addr
 /* Returns module and fills in value, defined and namebuf, or NULL if
    symnum out of range. */
 struct module *module_get_kallsym(unsigned int symnum, unsigned long *value,
-				char *type, char *name, size_t namelen);
+				char *type, char *name);
 
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name);
@@ -529,8 +529,7 @@ static inline const char *module_address
 
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
@@ -2124,7 +2125,7 @@ const char *module_address_lookup(unsign
 }
 
 struct module *module_get_kallsym(unsigned int symnum, unsigned long *value,
-				char *type, char *name, size_t namelen)
+				char *type, char *name)
 {
 	struct module *mod;
 
@@ -2134,7 +2135,7 @@ struct module *module_get_kallsym(unsign
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
2621-rc5-mm3-fix-e1000-compilation.patch
fix-rmmod-read-write-races-in-proc-entries.patch
