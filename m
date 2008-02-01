From: akpm@linux-foundation.org
Subject: - modules-make-module_address_lookup-safe.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:44 -0800
Message-ID: <200802012230.m11MUiWQ001930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756404AbYBAWrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:47:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, kyle@mcmartin.ca, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     modules: make module_address_lookup safe
has been removed from the -mm tree.  Its filename was
     modules-make-module_address_lookup-safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2211,14 +2211,13 @@ static const char *get_ksymbol(struct mo
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
@@ -2233,6 +2232,11 @@ const char *module_address_lookup(unsign
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

origin.patch
git-kvm.patch
request_irq-always-returns-einval-with-a-null-handler.patch
kallsyms-should-prefer-non-weak-symbols.patch
virtio_net-remove-double-ether_setup.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
modules-make-module_address_lookup-safe-fix.patch
fixup-container_of-usage.patch
aio-partial-write-should-not-return-error-code.patch
aio-negative-offset-should-return-einval.patch
reiser4.patch
