From: akpm@linux-foundation.org
Subject: - extend-print_symbol-capability.patch removed from -mm tree
Date: Thu, 03 May 2007 12:30:08 -0700
Message-ID: <200705031930.l43JU8fd018123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767810AbXECTcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpeterso@redhat.com, clameter@sgi.com, pmarques@grupopie.com, rdunlap@xenotime.net, rusty@rustcorp.com.au, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Extend print_symbol capability
has been removed from the -mm tree.  Its filename was
     extend-print_symbol-capability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Extend print_symbol capability
From: Robert Peterson <rpeterso@redhat.com>

Today's print_symbol function dumps a kernel symbol with printk.  This
patch extends the functionality of kallsyms.c so that the symbol lookup
function may be used without the printk.  This is useful for modules that
want to dump symbols elsewhere, for example, to debugfs.  I intend to use
the new function call in the GFS2 file system (which will be a separate
patch).

[akpm@linux-foundation.org: build fix]
[clameter@sgi.com: sprint_symbol should return length of string like sprintf]
Signed-off-by: Robert Peterson <rpeterso@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Paulo Marques <pmarques@grupopie.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |   13 ++++++++++++-
 kernel/kallsyms.c        |   23 +++++++++++++++--------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff -puN include/linux/kallsyms.h~extend-print_symbol-capability include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~extend-print_symbol-capability
+++ a/include/linux/kallsyms.h
@@ -7,6 +7,8 @@
 
 
 #define KSYM_NAME_LEN 127
+#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +	\
+			 2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1)
 
 #ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
@@ -22,7 +24,10 @@ const char *kallsyms_lookup(unsigned lon
 			    unsigned long *offset,
 			    char **modname, char *namebuf);
 
-/* Replace "%s" in format with address, if found */
+/* Look up a kernel symbol and return it in a text buffer. */
+extern int sprint_symbol(char *buffer, unsigned long address);
+
+/* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
 
 #else /* !CONFIG_KALLSYMS */
@@ -47,6 +52,12 @@ static inline const char *kallsyms_looku
 	return NULL;
 }
 
+static inline int sprint_symbol(char *buffer, unsigned long addr)
+{
+	*buffer = '\0';
+	return 0;
+}
+
 /* Stupid that this does nothing, but I didn't create this mess. */
 #define __print_symbol(fmt, addr)
 #endif /*CONFIG_KALLSYMS*/
diff -puN kernel/kallsyms.c~extend-print_symbol-capability kernel/kallsyms.c
--- a/kernel/kallsyms.c~extend-print_symbol-capability
+++ a/kernel/kallsyms.c
@@ -267,27 +267,33 @@ const char *kallsyms_lookup(unsigned lon
 	return NULL;
 }
 
-/* Replace "%s" in format with address, or returns -errno. */
-void __print_symbol(const char *fmt, unsigned long address)
+/* Look up a kernel symbol and return it in a text buffer. */
+int sprint_symbol(char *buffer, unsigned long address)
 {
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
 	char namebuf[KSYM_NAME_LEN+1];
-	char buffer[sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +
-		    2*(BITS_PER_LONG*3/10) + MODULE_NAME_LEN + 1];
 
 	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
-
 	if (!name)
-		sprintf(buffer, "0x%lx", address);
+		return sprintf(buffer, "0x%lx", address);
 	else {
 		if (modname)
-			sprintf(buffer, "%s+%#lx/%#lx [%s]", name, offset,
+			return sprintf(buffer, "%s+%#lx/%#lx [%s]", name, offset,
 				size, modname);
 		else
-			sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
+			return sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
 	}
+}
+
+/* Look up a kernel symbol and print it to the kernel messages. */
+void __print_symbol(const char *fmt, unsigned long address)
+{
+	char buffer[KSYM_SYMBOL_LEN];
+
+	sprint_symbol(buffer, address);
+
 	printk(fmt, buffer);
 }
 
@@ -452,3 +458,4 @@ static int __init kallsyms_init(void)
 __initcall(kallsyms_init);
 
 EXPORT_SYMBOL(__print_symbol);
+EXPORT_SYMBOL_GPL(sprint_symbol);
_

Patches currently in -mm which might be from rpeterso@redhat.com are

origin.patch
git-gfs2-nmw.patch
