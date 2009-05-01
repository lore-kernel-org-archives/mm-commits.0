From: akpm@linux-foundation.org
Subject: [merged] vsprintf-introduce-%pf.patch removed from -mm tree
Date: Fri, 01 May 2009 13:14:16 -0700
Message-ID: <200905012014.n41KEGYZ024432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765565AbZEAUTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2009 16:19:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, 20090415154817.GC5989@nowhere, lizf@cn.fujitsu.com, mingo@elte.hu, rostedt@goodmis.org, tzanussi@gmail.com, vapier.adi@gmail.com, zhaolei@cn.fujitsu.com, mm-commit


The patch titled
     vsprintf: introduce %pf format specifier
has been removed from the -mm tree.  Its filename was
     vsprintf-introduce-%pf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vsprintf: introduce %pf format specifier
From: Frederic Weisbecker <fweisbec@gmail.com>

A format which could let us to print a pure function name has been
suggested by Andrew Morton some monthes ago.

The current %pF is very convenient to print a function symbol, but often
we only want to print the name of the function, without its asm offset.

That's what does %pf in this patch.  The lowecase f has been chosen for
its intuitive sense of a weak kind of %pF

The support for this new format would be welcome for the tracing tree
where the need to print pure function names is often needed and also on
other parts:

$ git-grep -E "kallsyms_lookup\(.+?\)"
arch/blackfin/kernel/traps.c:   symname = kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
arch/powerpc/xmon/xmon.c:               name = kallsyms_lookup(pc, &size, &offset, NULL, tmpstr);
arch/sh/kernel/cpu/sh5/unwind.c:        sym = kallsyms_lookup(pc, NULL, &offset, NULL, namebuf);
arch/x86/kernel/ftrace.c:       kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
kernel/kprobes.c:               sym = kallsyms_lookup((unsigned long)p->addr, NULL,
kernel/lockdep.c:       return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
kernel/trace/ftrace.c:  kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
kernel/trace/trace_functions.c: kallsyms_lookup(ip, NULL, NULL, NULL, str);
kernel/trace/trace_output.c:    kallsyms_lookup(address, NULL, NULL, NULL, str);

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Mike Frysinger <vapier.adi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-introduce-%pf lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-introduce-%pf
+++ a/lib/vsprintf.c
@@ -573,12 +573,15 @@ static char *string(char *buf, char *end
 }
 
 static char *symbol_string(char *buf, char *end, void *ptr,
-				struct printf_spec spec)
+				struct printf_spec spec, char ext)
 {
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	sprint_symbol(sym, value);
+	if (ext != 'f')
+		sprint_symbol(sym, value);
+	else
+		kallsyms_lookup(value, NULL, NULL, NULL, sym);
 	return string(buf, end, sym, spec);
 #else
 	spec.field_width = 2*sizeof(void *);
@@ -690,7 +693,8 @@ static char *ip4_addr_string(char *buf, 
  *
  * Right now we handle:
  *
- * - 'F' For symbolic function descriptor pointers
+ * - 'F' For symbolic function descriptor pointers with offset
+ * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers
  * - 'R' For a struct resource pointer, it prints the range of
  *       addresses (not the name nor the flags)
@@ -713,10 +717,11 @@ static char *pointer(const char *fmt, ch
 
 	switch (*fmt) {
 	case 'F':
+	case 'f':
 		ptr = dereference_function_descriptor(ptr);
 		/* Fallthrough */
 	case 'S':
-		return symbol_string(buf, end, ptr, spec);
+		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 		return resource_string(buf, end, ptr, spec);
 	case 'm':
@@ -943,7 +948,8 @@ qualifier:
  *
  * This function follows C99 vsnprintf, but has some extensions:
  * %pS output the name of a text symbol
- * %pF output the name of a function pointer
+ * %pF output the name of a function pointer with its offset
+ * %pf output the name of a function pointer without its offset
  * %pR output the address range in a struct resource
  *
  * The return value is the number of characters which would
@@ -1391,7 +1397,8 @@ EXPORT_SYMBOL_GPL(vbin_printf);
  *
  * The format follows C99 vsnprintf, but has some extensions:
  * %pS output the name of a text symbol
- * %pF output the name of a function pointer
+ * %pF output the name of a function pointer with its offset
+ * %pf output the name of a function pointer without its offset
  * %pR output the address range in a struct resource
  * %n is ignored
  *
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch

