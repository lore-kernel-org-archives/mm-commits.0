From: akpm@linux-foundation.org
Subject: + vsprintf-fix-%ps-on-non-symbols-when-using-kallsyms.patch added to -mm tree
Date: Mon, 23 Apr 2012 15:00:29 -0700
Message-ID: <20120423220029.D84E4A0172@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:47003 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab2DWWAb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Apr 2012 18:00:31 -0400
Received: by vcbfk26 with SMTP id fk26so3935vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Apr 2012 15:00:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     Subject: vsprintf: fix %ps on non symbols when using kallsyms
has been added to the -mm tree.  Its filename is
     vsprintf-fix-%ps-on-non-symbols-when-using-kallsyms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: vsprintf: fix %ps on non symbols when using kallsyms

Using %ps in a printk format will sometimes fail silently and print the
empty string if the address passed in does not match a symbol that
kallsyms knows about.  But using %pS will fall back to printing the full
address if kallsyms can't find the symbol.  Make %ps act the same as %pS
by falling back to printing the address.

While we're here also make %ps print the module that a symbol comes from
so that it matches what %pS already does.  Take this simple function for
example (in a module):

	static void test_printk(void)
	{
		int test;
		pr_info("with pS: %pS\n", &test);
		pr_info("with ps: %ps\n", &test);
	}

Before this patch:

 with pS: 0xdff7df44
 with ps:

After this patch:

 with pS: 0xdff7df44
 with ps: 0xdff7df44

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |    7 +++++++
 kernel/kallsyms.c        |   32 ++++++++++++++++++++++++--------
 lib/vsprintf.c           |    2 +-
 3 files changed, 32 insertions(+), 9 deletions(-)

diff -puN include/linux/kallsyms.h~vsprintf-fix-%ps-on-non-symbols-when-using-kallsyms include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~vsprintf-fix-%ps-on-non-symbols-when-using-kallsyms
+++ a/include/linux/kallsyms.h
@@ -36,6 +36,7 @@ const char *kallsyms_lookup(unsigned lon
 
 /* Look up a kernel symbol and return it in a text buffer. */
 extern int sprint_symbol(char *buffer, unsigned long address);
+extern int sprint_symbol_no_offset(char *buffer, unsigned long address);
 extern int sprint_backtrace(char *buffer, unsigned long address);
 
 /* Look up a kernel symbol and print it to the kernel messages. */
@@ -80,6 +81,12 @@ static inline int sprint_symbol(char *bu
 	return 0;
 }
 
+static inline int sprint_symbol_no_offset(char *buffer, unsigned long addr)
+{
+	*buffer = '\0';
+	return 0;
+}
+
 static inline int sprint_backtrace(char *buffer, unsigned long addr)
 {
 	*buffer = '\0';
diff -puN kernel/kallsyms.c~vsprintf-fix-%ps-on-non-symbols-when-using-kallsyms kernel/kallsyms.c
--- a/kernel/kallsyms.c~vsprintf-fix-%ps-on-non-symbols-when-using-kallsyms
+++ a/kernel/kallsyms.c
@@ -343,7 +343,7 @@ int lookup_symbol_attrs(unsigned long ad
 
 /* Look up a kernel symbol and return it in a text buffer. */
 static int __sprint_symbol(char *buffer, unsigned long address,
-			   int symbol_offset)
+			   int symbol_offset, int add_offset)
 {
 	char *modname;
 	const char *name;
@@ -358,13 +358,13 @@ static int __sprint_symbol(char *buffer,
 	if (name != buffer)
 		strcpy(buffer, name);
 	len = strlen(buffer);
-	buffer += len;
 	offset -= symbol_offset;
 
+	if (add_offset)
+		len += sprintf(buffer + len, "+%#lx/%#lx", offset, size);
+
 	if (modname)
-		len += sprintf(buffer, "+%#lx/%#lx [%s]", offset, size, modname);
-	else
-		len += sprintf(buffer, "+%#lx/%#lx", offset, size);
+		len += sprintf(buffer + len, " [%s]", modname);
 
 	return len;
 }
@@ -382,12 +382,28 @@ static int __sprint_symbol(char *buffer,
  */
 int sprint_symbol(char *buffer, unsigned long address)
 {
-	return __sprint_symbol(buffer, address, 0);
+	return __sprint_symbol(buffer, address, 0, 1);
 }
-
 EXPORT_SYMBOL_GPL(sprint_symbol);
 
 /**
+ * sprint_symbol_no_offset - Look up a kernel symbol and return it in a text buffer
+ * @buffer: buffer to be stored
+ * @address: address to lookup
+ *
+ * This function looks up a kernel symbol with @address and stores its name
+ * and module name to @buffer if possible. If no symbol was found, just saves
+ * its @address as is.
+ *
+ * This function returns the number of bytes stored in @buffer.
+ */
+int sprint_symbol_no_offset(char *buffer, unsigned long address)
+{
+	return __sprint_symbol(buffer, address, 0, 0);
+}
+EXPORT_SYMBOL_GPL(sprint_symbol_no_offset);
+
+/**
  * sprint_backtrace - Look up a backtrace symbol and return it in a text buffer
  * @buffer: buffer to be stored
  * @address: address to lookup
@@ -403,7 +419,7 @@ EXPORT_SYMBOL_GPL(sprint_symbol);
  */
 int sprint_backtrace(char *buffer, unsigned long address)
 {
-	return __sprint_symbol(buffer, address, -1);
+	return __sprint_symbol(buffer, address, -1, 1);
 }
 
 /* Look up a kernel symbol and print it to the kernel messages. */
diff -puN lib/vsprintf.c~vsprintf-fix-%ps-on-non-symbols-when-using-kallsyms lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-fix-%ps-on-non-symbols-when-using-kallsyms
+++ a/lib/vsprintf.c
@@ -535,7 +535,7 @@ char *symbol_string(char *buf, char *end
 	else if (ext != 'f' && ext != 's')
 		sprint_symbol(sym, value);
 	else
-		kallsyms_lookup(value, NULL, NULL, NULL, sym);
+		sprint_symbol_no_offset(sym, value);
 
 	return string(buf, end, sym, spec);
 #else
_
Subject: Subject: vsprintf: fix %ps on non symbols when using kallsyms

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
linux-next.patch
vsprintf-fix-%ps-on-non-symbols-when-using-kallsyms.patch
spinlock_debug-print-kallsyms-name-for-lock.patch

