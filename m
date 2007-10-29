From: akpm@linux-foundation.org
Subject: + remove-support-for-un-needed-_extratext-section.patch added to -mm tree
Date: Mon, 29 Oct 2007 15:22:33 -0700
Message-ID: <200710292222.l9TMMX0M028843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263AbXJ2WX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 18:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rgetz@blackfin.uclinux.org, benh@kernel.crashing.org, dwmw2@infradead.org, jdl@freescale.com, paulus@samba.org, sam@ravnborg.org


The patch titled
     remove support for un-needed _extratext section
has been added to the -mm tree.  Its filename is
     remove-support-for-un-needed-_extratext-section.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove support for un-needed _extratext section
From: Robin Getz <rgetz@blackfin.uclinux.org>

When passing a zero address to kallsyms_lookup(), the kernel thought it was
a valid kernel address, even if it is not.  This is because is_ksym_addr()
called is_kernel_extratext() and checked against labels that don't exist on
many archs (which default as zero).  Since PPC was the only kernel which
defines _extra_text, (in 2005), and no longer needs it, this patch removes
_extra_text support.

For some history (provided by Jon):
 http://ozlabs.org/pipermail/linuxppc-dev/2005-September/019734.html
 http://ozlabs.org/pipermail/linuxppc-dev/2005-September/019736.html
 http://ozlabs.org/pipermail/linuxppc-dev/2005-September/019751.html

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jon Loeliger <jdl@freescale.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/kernel/vmlinux.lds.S  |    5 -----
 include/asm-generic/sections.h |    2 --
 kernel/kallsyms.c              |   11 +----------
 scripts/kallsyms.c             |   24 ++++++++++--------------
 4 files changed, 11 insertions(+), 31 deletions(-)

diff -puN arch/ppc/kernel/vmlinux.lds.S~remove-support-for-un-needed-_extratext-section arch/ppc/kernel/vmlinux.lds.S
--- a/arch/ppc/kernel/vmlinux.lds.S~remove-support-for-un-needed-_extratext-section
+++ a/arch/ppc/kernel/vmlinux.lds.S
@@ -143,11 +143,6 @@ SECTIONS
 
   . = ALIGN(4096);
   __init_end = .;
-
-  . = ALIGN(4096);
-  _sextratext = .;
-  _eextratext = .;
-
   __bss_start = .;
   .bss       :
   {
diff -puN include/asm-generic/sections.h~remove-support-for-un-needed-_extratext-section include/asm-generic/sections.h
--- a/include/asm-generic/sections.h~remove-support-for-un-needed-_extratext-section
+++ a/include/asm-generic/sections.h
@@ -8,8 +8,6 @@ extern char _data[], _sdata[], _edata[];
 extern char __bss_start[], __bss_stop[];
 extern char __init_begin[], __init_end[];
 extern char _sinittext[], _einittext[];
-extern char _sextratext[] __attribute__((weak));
-extern char _eextratext[] __attribute__((weak));
 extern char _end[];
 extern char __per_cpu_start[], __per_cpu_end[];
 extern char __kprobes_text_start[], __kprobes_text_end[];
diff -puN kernel/kallsyms.c~remove-support-for-un-needed-_extratext-section kernel/kallsyms.c
--- a/kernel/kallsyms.c~remove-support-for-un-needed-_extratext-section
+++ a/kernel/kallsyms.c
@@ -48,14 +48,6 @@ static inline int is_kernel_inittext(uns
 	return 0;
 }
 
-static inline int is_kernel_extratext(unsigned long addr)
-{
-	if (addr >= (unsigned long)_sextratext
-	    && addr <= (unsigned long)_eextratext)
-		return 1;
-	return 0;
-}
-
 static inline int is_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_stext && addr <= (unsigned long)_etext)
@@ -75,8 +67,7 @@ static int is_ksym_addr(unsigned long ad
 	if (all_var)
 		return is_kernel(addr);
 
-	return is_kernel_text(addr) || is_kernel_inittext(addr) ||
-		is_kernel_extratext(addr);
+	return is_kernel_text(addr) || is_kernel_inittext(addr);
 }
 
 /* expand a compressed symbol data into the resulting uncompressed string,
diff -puN scripts/kallsyms.c~remove-support-for-un-needed-_extratext-section scripts/kallsyms.c
--- a/scripts/kallsyms.c~remove-support-for-un-needed-_extratext-section
+++ a/scripts/kallsyms.c
@@ -41,7 +41,7 @@ struct sym_entry {
 
 static struct sym_entry *table;
 static unsigned int table_size, table_cnt;
-static unsigned long long _text, _stext, _etext, _sinittext, _einittext, _sextratext, _eextratext;
+static unsigned long long _text, _stext, _etext, _sinittext, _einittext;
 static int all_symbols = 0;
 static char symbol_prefix_char = '\0';
 
@@ -99,10 +99,6 @@ static int read_symbol(FILE *in, struct 
 		_sinittext = s->addr;
 	else if (strcmp(sym, "_einittext") == 0)
 		_einittext = s->addr;
-	else if (strcmp(sym, "_sextratext") == 0)
-		_sextratext = s->addr;
-	else if (strcmp(sym, "_eextratext") == 0)
-		_eextratext = s->addr;
 	else if (toupper(stype) == 'A')
 	{
 		/* Keep these useful absolute symbols */
@@ -165,18 +161,18 @@ static int symbol_valid(struct sym_entry
 	 * and inittext sections are discarded */
 	if (!all_symbols) {
 		if ((s->addr < _stext || s->addr > _etext)
-		    && (s->addr < _sinittext || s->addr > _einittext)
-		    && (s->addr < _sextratext || s->addr > _eextratext))
+		    && (s->addr < _sinittext || s->addr > _einittext))
 			return 0;
 		/* Corner case.  Discard any symbols with the same value as
-		 * _etext _einittext or _eextratext; they can move between pass
-		 * 1 and 2 when the kallsyms data are added.  If these symbols
-		 * move then they may get dropped in pass 2, which breaks the
-		 * kallsyms rules.
+		 * _etext _einittext; they can move between pass 1 and 2 when
+		 * the kallsyms data are added.  If these symbols move then
+		 * they may get dropped in pass 2, which breaks the kallsyms
+		 * rules.
 		 */
-		if ((s->addr == _etext && strcmp((char*)s->sym + offset, "_etext")) ||
-		    (s->addr == _einittext && strcmp((char*)s->sym + offset, "_einittext")) ||
-		    (s->addr == _eextratext && strcmp((char*)s->sym + offset, "_eextratext")))
+		if ((s->addr == _etext &&
+				strcmp((char*)s->sym + offset, "_etext")) ||
+		    (s->addr == _einittext &&
+				strcmp((char*)s->sym + offset, "_einittext")))
 			return 0;
 	}
 
_

Patches currently in -mm which might be from rgetz@blackfin.uclinux.org are

kernel-printkc-concerns-about-the-console-handover.patch
remove-support-for-un-needed-_extratext-section.patch
