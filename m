From: akpm@linux-foundation.org
Subject: + modpost-support-objects-with-more-than-64k-sections.patch added to -mm tree
Date: Fri, 22 Jan 2010 15:11:14 -0800
Message-ID: <201001222311.o0MNBEZh001986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432Ab0AVXMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 18:12:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com, andersk@mit.edu, andi@firstfloor.org, rusty@rustcorp.com.au


The patch titled
     modpost: support objects with more than 64k sections
has been added to the -mm tree.  Its filename is
     modpost-support-objects-with-more-than-64k-sections.patch

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
Subject: modpost: support objects with more than 64k sections
From: Denys Vlasenko <vda.linux@googlemail.com>

In order to help a bit with future merge of -ffunction-sections work, I am
resending a self-contained prerequisiste: fix for "modpost + more than
64000 sections" situation.

This patch makes modpost able to process object files with more than 64k
sections.  Needed for huge kernel builds (allyesconfig, for example) with
-ffunction-sections.

[andersk@mit.edu: updated for 2.6.29]
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Anders Kaseorg <andersk@mit.edu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/file2alias.c |    6 +-
 scripts/mod/modpost.c    |   96 ++++++++++++++++++++++++++-----------
 scripts/mod/modpost.h    |   43 ++++++++++++++++
 3 files changed, 115 insertions(+), 30 deletions(-)

diff -puN scripts/mod/file2alias.c~modpost-support-objects-with-more-than-64k-sections scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c~modpost-support-objects-with-more-than-64k-sections
+++ a/scripts/mod/file2alias.c
@@ -839,16 +839,16 @@ void handle_moddevtable(struct module *m
 	char *zeros = NULL;
 
 	/* We're looking for a section relative symbol */
-	if (!sym->st_shndx || sym->st_shndx >= info->hdr->e_shnum)
+	if (!sym->st_shndx || get_secindex(info, sym) >= info->num_sections)
 		return;
 
 	/* Handle all-NULL symbols allocated into .bss */
-	if (info->sechdrs[sym->st_shndx].sh_type & SHT_NOBITS) {
+	if (info->sechdrs[get_secindex(info, sym)].sh_type & SHT_NOBITS) {
 		zeros = calloc(1, sym->st_size);
 		symval = zeros;
 	} else {
 		symval = (void *)info->hdr
-			+ info->sechdrs[sym->st_shndx].sh_offset
+			+ info->sechdrs[get_secindex(info, sym)].sh_offset
 			+ sym->st_value;
 	}
 
diff -puN scripts/mod/modpost.c~modpost-support-objects-with-more-than-64k-sections scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~modpost-support-objects-with-more-than-64k-sections
+++ a/scripts/mod/modpost.c
@@ -253,7 +253,7 @@ static enum export export_no(const char 
 	return export_unknown;
 }
 
-static enum export export_from_sec(struct elf_info *elf, Elf_Section sec)
+static enum export export_from_sec(struct elf_info *elf, unsigned int sec)
 {
 	if (sec == elf->export_sec)
 		return export_plain;
@@ -373,6 +373,8 @@ static int parse_elf(struct elf_info *in
 	Elf_Ehdr *hdr;
 	Elf_Shdr *sechdrs;
 	Elf_Sym  *sym;
+	const char *secstrings;
+	unsigned int symtab_idx = ~0U, symtab_shndx_idx = ~0U;
 
 	hdr = grab_file(filename, &info->size);
 	if (!hdr) {
@@ -417,8 +419,19 @@ static int parse_elf(struct elf_info *in
 		return 0;
 	}
 
+	/* Fixup for more than 64k sections */
+	info->num_sections = hdr->e_shnum;
+	if (info->num_sections == 0) { /* more than 64k sections? */
+		/* note: it doesn't need shndx2secindex() */
+		info->num_sections = TO_NATIVE(sechdrs[0].sh_size);
+	}
+	info->secindex_strings = hdr->e_shstrndx;
+	if (info->secindex_strings == SHN_XINDEX)
+		info->secindex_strings =
+		    shndx2secindex(TO_NATIVE(sechdrs[0].sh_link));
+
 	/* Fix endianness in section headers */
-	for (i = 0; i < hdr->e_shnum; i++) {
+	for (i = 0; i < info->num_sections; i++) {
 		sechdrs[i].sh_name      = TO_NATIVE(sechdrs[i].sh_name);
 		sechdrs[i].sh_type      = TO_NATIVE(sechdrs[i].sh_type);
 		sechdrs[i].sh_flags     = TO_NATIVE(sechdrs[i].sh_flags);
@@ -431,9 +444,8 @@ static int parse_elf(struct elf_info *in
 		sechdrs[i].sh_entsize   = TO_NATIVE(sechdrs[i].sh_entsize);
 	}
 	/* Find symbol table. */
-	for (i = 1; i < hdr->e_shnum; i++) {
-		const char *secstrings
-			= (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+	secstrings = (void *)hdr + sechdrs[info->secindex_strings].sh_offset;
+	for (i = 1; i < info->num_sections; i++) {
 		const char *secname;
 		int nobits = sechdrs[i].sh_type == SHT_NOBITS;
 
@@ -461,14 +473,26 @@ static int parse_elf(struct elf_info *in
 		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
 			info->export_gpl_future_sec = i;
 
-		if (sechdrs[i].sh_type != SHT_SYMTAB)
-			continue;
-
-		info->symtab_start = (void *)hdr + sechdrs[i].sh_offset;
-		info->symtab_stop  = (void *)hdr + sechdrs[i].sh_offset
-			                         + sechdrs[i].sh_size;
-		info->strtab       = (void *)hdr +
-			             sechdrs[sechdrs[i].sh_link].sh_offset;
+		if (sechdrs[i].sh_type == SHT_SYMTAB) {
+			unsigned int sh_link_idx;
+			symtab_idx = i;
+			info->symtab_start = (void *)hdr +
+			    sechdrs[i].sh_offset;
+			info->symtab_stop  = (void *)hdr +
+			    sechdrs[i].sh_offset + sechdrs[i].sh_size;
+			sh_link_idx = shndx2secindex(sechdrs[i].sh_link);
+			info->strtab       = (void *)hdr +
+			    sechdrs[sh_link_idx].sh_offset;
+		}
+
+		/* 32bit section no. table? ("more than 64k sections") */
+		if (sechdrs[i].sh_type == SHT_SYMTAB_SHNDX) {
+			symtab_shndx_idx = i;
+			info->symtab_shndx_start = (void *)hdr +
+			    sechdrs[i].sh_offset;
+			info->symtab_shndx_stop  = (void *)hdr +
+			    sechdrs[i].sh_offset + sechdrs[i].sh_size;
+		}
 	}
 	if (!info->symtab_start)
 		fatal("%s has no symtab?\n", filename);
@@ -480,6 +504,21 @@ static int parse_elf(struct elf_info *in
 		sym->st_value = TO_NATIVE(sym->st_value);
 		sym->st_size  = TO_NATIVE(sym->st_size);
 	}
+
+	if (symtab_shndx_idx != ~0U) {
+		Elf32_Word *p;
+		if (symtab_idx !=
+		    shndx2secindex(sechdrs[symtab_shndx_idx].sh_link))
+			fatal("%s: SYMTAB_SHNDX has bad sh_link: %u!=%u\n",
+			      filename,
+			      shndx2secindex(sechdrs[symtab_shndx_idx].sh_link),
+			      symtab_idx);
+		/* Fix endianness */
+		for (p = info->symtab_shndx_start; p < info->symtab_shndx_stop;
+		     p++)
+			*p = TO_NATIVE(*p);
+	}
+
 	return 1;
 }
 
@@ -514,7 +553,7 @@ static void handle_modversions(struct mo
 			       Elf_Sym *sym, const char *symname)
 {
 	unsigned int crc;
-	enum export export = export_from_sec(info, sym->st_shndx);
+	enum export export = export_from_sec(info, get_secindex(info, sym));
 
 	switch (sym->st_shndx) {
 	case SHN_COMMON:
@@ -656,19 +695,19 @@ static const char *sym_name(struct elf_i
 		return "(unknown)";
 }
 
-static const char *sec_name(struct elf_info *elf, int shndx)
+static const char *sec_name(struct elf_info *elf, int secindex)
 {
 	Elf_Shdr *sechdrs = elf->sechdrs;
 	return (void *)elf->hdr +
-	        elf->sechdrs[elf->hdr->e_shstrndx].sh_offset +
-	        sechdrs[shndx].sh_name;
+		elf->sechdrs[elf->secindex_strings].sh_offset +
+		sechdrs[secindex].sh_name;
 }
 
 static const char *sech_name(struct elf_info *elf, Elf_Shdr *sechdr)
 {
 	return (void *)elf->hdr +
-	        elf->sechdrs[elf->hdr->e_shstrndx].sh_offset +
-	        sechdr->sh_name;
+		elf->sechdrs[elf->secindex_strings].sh_offset +
+		sechdr->sh_name;
 }
 
 /* if sym is empty or point to a string
@@ -1023,11 +1062,14 @@ static Elf_Sym *find_elf_symbol(struct e
 	Elf_Sym *near = NULL;
 	Elf64_Sword distance = 20;
 	Elf64_Sword d;
+	unsigned int relsym_secindex;
 
 	if (relsym->st_name != 0)
 		return relsym;
+
+	relsym_secindex = get_secindex(elf, relsym);
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
-		if (sym->st_shndx != relsym->st_shndx)
+		if (get_secindex(elf, sym) != relsym_secindex)
 			continue;
 		if (ELF_ST_TYPE(sym->st_info) == STT_SECTION)
 			continue;
@@ -1089,9 +1131,9 @@ static Elf_Sym *find_elf_symbol2(struct 
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
 		const char *symsec;
 
-		if (sym->st_shndx >= SHN_LORESERVE)
+		if (is_shndx_special(sym->st_shndx))
 			continue;
-		symsec = sec_name(elf, sym->st_shndx);
+		symsec = sec_name(elf, get_secindex(elf, sym));
 		if (strcmp(symsec, sec) != 0)
 			continue;
 		if (!is_valid_name(elf, sym))
@@ -1288,7 +1330,7 @@ static void check_section_mismatch(const
 	const char *tosec;
 	enum mismatch mismatch;
 
-	tosec = sec_name(elf, sym->st_shndx);
+	tosec = sec_name(elf, get_secindex(elf, sym));
 	mismatch = section_mismatch(fromsec, tosec);
 	if (mismatch != NO_MISMATCH) {
 		Elf_Sym *to;
@@ -1315,7 +1357,7 @@ static unsigned int *reloc_location(stru
 				    Elf_Shdr *sechdr, Elf_Rela *r)
 {
 	Elf_Shdr *sechdrs = elf->sechdrs;
-	int section = sechdr->sh_info;
+	int section = shndx2secindex(sechdr->sh_info);
 
 	return (void *)elf->hdr + sechdrs[section].sh_offset +
 		(r->r_offset - sechdrs[section].sh_addr);
@@ -1423,7 +1465,7 @@ static void section_rela(const char *mod
 		r.r_addend = TO_NATIVE(rela->r_addend);
 		sym = elf->symtab_start + r_sym;
 		/* Skip special sections */
-		if (sym->st_shndx >= SHN_LORESERVE)
+		if (is_shndx_special(sym->st_shndx))
 			continue;
 		check_section_mismatch(modname, elf, &r, sym, fromsec);
 	}
@@ -1481,7 +1523,7 @@ static void section_rel(const char *modn
 		}
 		sym = elf->symtab_start + r_sym;
 		/* Skip special sections */
-		if (sym->st_shndx >= SHN_LORESERVE)
+		if (is_shndx_special(sym->st_shndx))
 			continue;
 		check_section_mismatch(modname, elf, &r, sym, fromsec);
 	}
@@ -1506,7 +1548,7 @@ static void check_sec_ref(struct module 
 	Elf_Shdr *sechdrs = elf->sechdrs;
 
 	/* Walk through all sections */
-	for (i = 0; i < elf->hdr->e_shnum; i++) {
+	for (i = 0; i < elf->num_sections; i++) {
 		check_section(modname, elf, &elf->sechdrs[i]);
 		/* We want to process only relocation sections and not .init */
 		if (sechdrs[i].sh_type == SHT_RELA)
diff -puN scripts/mod/modpost.h~modpost-support-objects-with-more-than-64k-sections scripts/mod/modpost.h
--- a/scripts/mod/modpost.h~modpost-support-objects-with-more-than-64k-sections
+++ a/scripts/mod/modpost.h
@@ -129,8 +129,51 @@ struct elf_info {
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
+
+	/* support for 32bit section numbers */
+
+	unsigned int num_sections; /* max_secindex + 1 */
+	unsigned int secindex_strings;
+	/* if Nth symbol table entry has .st_shndx = SHN_XINDEX,
+	 * take shndx from symtab_shndx_start[N] instead */
+	Elf32_Word   *symtab_shndx_start;
+	Elf32_Word   *symtab_shndx_stop;
 };
 
+static inline int is_shndx_special(unsigned int i)
+{
+	return i != SHN_XINDEX && i >= SHN_LORESERVE && i <= SHN_HIRESERVE;
+}
+
+/* shndx is in [0..SHN_LORESERVE) U (SHN_HIRESERVE, 0xfffffff], thus:
+ * shndx == 0               <=> sechdrs[0]
+ * ......
+ * shndx == SHN_LORESERVE-1 <=> sechdrs[SHN_LORESERVE-1]
+ * shndx == SHN_HIRESERVE+1 <=> sechdrs[SHN_LORESERVE]
+ * shndx == SHN_HIRESERVE+2 <=> sechdrs[SHN_LORESERVE+1]
+ * ......
+ * fyi: sym->st_shndx is uint16, SHN_LORESERVE = ff00, SHN_HIRESERVE = ffff,
+ * so basically we map  0000..feff -> 0000..feff
+ *                      ff00..ffff -> (you are a bad boy, dont do it)
+ *                     10000..xxxx -> ff00..(xxxx-0x100)
+ */
+static inline unsigned int shndx2secindex(unsigned int i)
+{
+	if (i <= SHN_HIRESERVE)
+		return i;
+	return i - (SHN_HIRESERVE + 1 - SHN_LORESERVE);
+}
+
+/* Accessor for sym->st_shndx, hides ugliness of "64k sections" */
+static inline unsigned int get_secindex(const struct elf_info *info,
+					const Elf_Sym *sym)
+{
+	if (sym->st_shndx != SHN_XINDEX)
+		return sym->st_shndx;
+	return shndx2secindex(info->symtab_shndx_start[sym -
+						       info->symtab_start]);
+}
+
 /* file2alias.c */
 extern unsigned int cross_build;
 void handle_moddevtable(struct module *mod, struct elf_info *info,
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

modpost-support-objects-with-more-than-64k-sections.patch

