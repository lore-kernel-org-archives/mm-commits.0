From: akpm@linux-foundation.org
Subject: + extend-print_symbol-capability.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:17:56 -0800
Message-ID: <200703020217.l222HuBt029850@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280AbXCBCSh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:18:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpeterso@redhat.com, rdunlap@xenotime.net, rusty@rustcorp.com.au, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     Extend print_symbol capability
has been added to the -mm tree.  Its filename is
     extend-print_symbol-capability.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Extend print_symbol capability
From: Robert Peterson <rpeterso@redhat.com>

Today's print_symbol function dumps a kernel symbol with printk.  This
patch extends the functionality of kallsyms.c so that the symbol lookup
function may be used without the printk.  This is useful for modules that
want to dump symbols elsewhere, for example, to debugfs.  I intend to use
the new function call in the GFS2 file system (which will be a separate
patch).

Signed-off-by: Robert Peterson <rpeterso@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |   10 ++++++++++
 kernel/kallsyms.c        |   21 ++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff -puN include/linux/kallsyms.h~extend-print_symbol-capability include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~extend-print_symbol-capability
+++ a/include/linux/kallsyms.h
@@ -7,6 +7,8 @@
 
 
 #define KSYM_NAME_LEN 127
+#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN + \
+			2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1)
 
 #ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
@@ -22,6 +24,9 @@ const char *kallsyms_lookup(unsigned lon
 			    unsigned long *offset,
 			    char **modname, char *namebuf);
 
+/* Look up a kernel symbol and return it in a text buffer. */
+extern void lookup_symbol(unsigned long addr, char *buffer);
+
 /* Replace "%s" in format with address, if found */
 extern void __print_symbol(const char *fmt, unsigned long address);
 
@@ -47,6 +52,11 @@ static inline const char *kallsyms_looku
 	return NULL;
 }
 
+static inline void lookup_symbol(unsigned long addr, char *buffer)
+{
+	return NULL;
+}
+
 /* Stupid that this does nothing, but I didn't create this mess. */
 #define __print_symbol(fmt, addr)
 #endif /*CONFIG_KALLSYMS*/
diff -puN kernel/kallsyms.c~extend-print_symbol-capability kernel/kallsyms.c
--- a/kernel/kallsyms.c~extend-print_symbol-capability
+++ a/kernel/kallsyms.c
@@ -267,20 +267,17 @@ const char *kallsyms_lookup(unsigned lon
 	return NULL;
 }
 
-/* Replace "%s" in format with address, or returns -errno. */
-void __print_symbol(const char *fmt, unsigned long address)
+/* Look up a kernel symbol and return it in a text buffer. */
+void lookup_symbol(unsigned long addr, char *buffer)
 {
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
 	char namebuf[KSYM_NAME_LEN+1];
-	char buffer[sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +
-		    2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1];
-
-	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
 
+	name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
 	if (!name)
-		sprintf(buffer, "0x%lx", address);
+		sprintf(buffer, "0x%lx", addr);
 	else {
 		if (modname)
 			sprintf(buffer, "%s+%#lx/%#lx [%s]", name, offset,
@@ -288,6 +285,15 @@ void __print_symbol(const char *fmt, uns
 		else
 			sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
 	}
+}
+
+/* Replace "%s" in format with address, or returns -errno. */
+void __print_symbol(const char *fmt, unsigned long address)
+{
+	char buffer[KSYM_SYMBOL_LEN];
+
+	lookup_symbol(address, buffer);
+
 	printk(fmt, buffer);
 }
 
@@ -452,3 +458,4 @@ static int __init kallsyms_init(void)
 __initcall(kallsyms_init);
 
 EXPORT_SYMBOL(__print_symbol);
+EXPORT_SYMBOL(lookup_symbol);
_

Patches currently in -mm which might be from rpeterso@redhat.com are

extend-print_symbol-capability.patch
