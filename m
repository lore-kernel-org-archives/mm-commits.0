From: akpm@linux-foundation.org
Subject: + modules-make-module_address_lookup-safe.patch added to -mm tree
Date: Tue, 08 Jan 2008 16:22:07 -0800
Message-ID: <200801090022.m090M732007467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36439 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbYAIAWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2008 19:22:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, kyle@mcmartin.ca, mingo@elte.hu


The patch titled
     modules: make module_address_lookup safe
has been added to the -mm tree.  Its filename is
     modules-make-module_address_lookup-safe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: modules: make module_address_lookup safe
From: Rusty Russell <rusty@rustcorp.com.au>

module_address_lookup releases preemption then returns a pointer into the
module space.  The only user (kallsyms) copies the result, so just do that
under the preempt disable.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |   22 +++++++++++++---------
 kernel/kallsyms.c      |   11 ++++-------
 kernel/module.c        |   20 ++++++++++++--------
 3 files changed, 29 insertions(+), 24 deletions(-)

diff -puN include/linux/module.h~modules-make-module_address_lookup-safe include/linux/module.h
--- a/include/linux/module.h~modules-make-module_address_lookup-safe
+++ a/include/linux/module.h
@@ -446,11 +446,14 @@ static inline void __module_get(struct m
 	__mod ? __mod->name : "kernel";		\
 })
 
-/* For kallsyms to ask for address resolution.  NULL means not found. */
-const char *module_address_lookup(unsigned long addr,
-				  unsigned long *symbolsize,
-				  unsigned long *offset,
-				  char **modname);
+/* For kallsyms to ask for address resolution.  namebuf should be at
+ * least KSYM_NAME_LEN long: a pointer to namebuf is returned if
+ * found, otherwise NULL. */
+char *module_address_lookup(unsigned long addr,
+			    unsigned long *symbolsize,
+			    unsigned long *offset,
+			    char **modname,
+			    char *namebuf);
 int lookup_module_symbol_name(unsigned long addr, char *symname);
 int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
 
@@ -516,10 +519,11 @@ static inline void module_put(struct mod
 #define module_name(mod) "kernel"
 
 /* For kallsyms to ask for address resolution.  NULL means not found. */
-static inline const char *module_address_lookup(unsigned long addr,
-						unsigned long *symbolsize,
-						unsigned long *offset,
-						char **modname)
+static inline char *module_address_lookup(unsigned long addr,
+					  unsigned long *symbolsize,
+					  unsigned long *offset,
+					  char **modname,
+					  char *namebuf)
 {
 	return NULL;
 }
diff -puN kernel/kallsyms.c~modules-make-module_address_lookup-safe kernel/kallsyms.c
--- a/kernel/kallsyms.c~modules-make-module_address_lookup-safe
+++ a/kernel/kallsyms.c
@@ -224,10 +224,11 @@ static unsigned long get_symbol_pos(unsi
 int kallsyms_lookup_size_offset(unsigned long addr, unsigned long *symbolsize,
 				unsigned long *offset)
 {
+	char namebuf[KSYM_NAME_LEN];
 	if (is_ksym_addr(addr))
 		return !!get_symbol_pos(addr, symbolsize, offset);
 
-	return !!module_address_lookup(addr, symbolsize, offset, NULL);
+	return !!module_address_lookup(addr, symbolsize, offset, NULL, namebuf);
 }
 
 /*
@@ -242,8 +243,6 @@ const char *kallsyms_lookup(unsigned lon
 			    unsigned long *offset,
 			    char **modname, char *namebuf)
 {
-	const char *msym;
-
 	namebuf[KSYM_NAME_LEN - 1] = 0;
 	namebuf[0] = 0;
 
@@ -259,10 +258,8 @@ const char *kallsyms_lookup(unsigned lon
 	}
 
 	/* see if it's in a module */
-	msym = module_address_lookup(addr, symbolsize, offset, modname);
-	if (msym)
-		return strncpy(namebuf, msym, KSYM_NAME_LEN - 1);
-
+	return module_address_lookup(addr, symbolsize, offset, modname,
+				     namebuf);
 	return NULL;
 }
 
diff -puN kernel/module.c~modules-make-module_address_lookup-safe kernel/module.c
--- a/kernel/module.c~modules-make-module_address_lookup-safe
+++ a/kernel/module.c
@@ -2215,14 +2215,13 @@ static const char *get_ksymbol(struct mo
 	return mod->strtab + mod->symtab[best].st_name;
 }
 
-/* For kallsyms to ask for address resolution.  NULL means not found.
-   We don't lock, as this is used for oops resolution and races are a
-   lesser concern. */
-/* FIXME: Risky: returns a pointer into a module w/o lock */
-const char *module_address_lookup(unsigned long addr,
-				  unsigned long *size,
-				  unsigned long *offset,
-				  char **modname)
+/* For kallsyms to ask for address resolution.  NULL means not found.  Careful
+ * not to lock to avoid deadlock on oopses, simply disable preemption. */
+char *module_address_lookup(unsigned long addr,
+			    unsigned long *size,
+			    unsigned long *offset,
+			    char **modname,
+			    char *namebuf)
 {
 	struct module *mod;
 	const char *ret = NULL;
@@ -2237,6 +2236,11 @@ const char *module_address_lookup(unsign
 			break;
 		}
 	}
+	/* Make a copy in here where it's safe */
+	if (ret) {
+		strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
+		ret = namebuf;
+	}
 	preempt_enable();
 	return ret;
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-kvm.patch
git-libata-all.patch
git-scsi-misc.patch
kallsyms-should-prefer-non-weak-symbols.patch
virtio_net-remove-double-ether_setup.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
modules-de-mutex-more-symbol-lookup-paths-in-the-module-code.patch
modules-make-module_address_lookup-safe.patch
reiser4.patch
