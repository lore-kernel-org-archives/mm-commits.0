From: akpm@linux-foundation.org
Subject: + revert-324d76561842e551051e2a897b958b0539f6867b.patch added to -mm tree
Date: Wed, 23 Jun 2010 15:26:20 -0700
Message-ID: <201006232255.o5NMt5kM004234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab0FWWzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 18:55:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au


The patch titled
     revert 324d76561842e551051e2a897b958b0539f6867b
has been added to the -mm tree.  Its filename is
     revert-324d76561842e551051e2a897b958b0539f6867b.patch

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
Subject: revert 324d76561842e551051e2a897b958b0539f6867b
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |  372 ++++++++++++++++++++++++++--------------------
 1 file changed, 215 insertions(+), 157 deletions(-)

diff -puN kernel/module.c~revert-324d76561842e551051e2a897b958b0539f6867b kernel/module.c
--- a/kernel/module.c~revert-324d76561842e551051e2a897b958b0539f6867b
+++ a/kernel/module.c
@@ -152,38 +152,42 @@ void __module_put_and_exit(struct module
 EXPORT_SYMBOL(__module_put_and_exit);
 
 /* Find a module section: 0 means not found. */
-static unsigned int find_sec(const struct load_info *info, const char *name)
+static unsigned int find_sec(Elf_Ehdr *hdr,
+			     Elf_Shdr *sechdrs,
+			     const char *secstrings,
+			     const char *name)
 {
 	unsigned int i;
 
-	for (i = 1; i < info->hdr->e_shnum; i++) {
-		Elf_Shdr *shdr = &info->sechdrs[i];
+	for (i = 1; i < hdr->e_shnum; i++)
 		/* Alloc bit cleared means "ignore it." */
-		if ((shdr->sh_flags & SHF_ALLOC)
-		    && strcmp(info->secstrings + shdr->sh_name, name) == 0)
+		if ((sechdrs[i].sh_flags & SHF_ALLOC)
+		    && strcmp(secstrings+sechdrs[i].sh_name, name) == 0)
 			return i;
-	}
 	return 0;
 }
 
 /* Find a module section, or NULL. */
-static void *section_addr(const struct load_info *info, const char *name)
+static void *section_addr(Elf_Ehdr *hdr, Elf_Shdr *shdrs,
+			  const char *secstrings, const char *name)
 {
 	/* Section 0 has sh_addr 0. */
-	return (void *)info->sechdrs[find_sec(info, name)].sh_addr;
+	return (void *)shdrs[find_sec(hdr, shdrs, secstrings, name)].sh_addr;
 }
 
 /* Find a module section, or NULL.  Fill in number of "objects" in section. */
-static void *section_objs(const struct load_info *info,
+static void *section_objs(Elf_Ehdr *hdr,
+			  Elf_Shdr *sechdrs,
+			  const char *secstrings,
 			  const char *name,
 			  size_t object_size,
 			  unsigned int *num)
 {
-	unsigned int sec = find_sec(info, name);
+	unsigned int sec = find_sec(hdr, sechdrs, secstrings, name);
 
 	/* Section 0 has sh_addr 0 and sh_size 0. */
-	*num = info->sechdrs[sec].sh_size / object_size;
-	return (void *)info->sechdrs[sec].sh_addr;
+	*num = sechdrs[sec].sh_size / object_size;
+	return (void *)sechdrs[sec].sh_addr;
 }
 
 /* Provided by the linker */
@@ -413,9 +417,11 @@ static void percpu_modfree(struct module
 	free_percpu(mod->percpu);
 }
 
-static unsigned int find_pcpusec(struct load_info *info)
+static unsigned int find_pcpusec(Elf_Ehdr *hdr,
+				 Elf_Shdr *sechdrs,
+				 const char *secstrings)
 {
-	return find_sec(info, ".data..percpu");
+	return find_sec(hdr, sechdrs, secstrings, ".data..percpu");
 }
 
 static void percpu_modcopy(struct module *mod,
@@ -475,7 +481,9 @@ static inline int percpu_modalloc(struct
 static inline void percpu_modfree(struct module *mod)
 {
 }
-static unsigned int find_pcpusec(struct load_info *info)
+static inline unsigned int find_pcpusec(Elf_Ehdr *hdr,
+					Elf_Shdr *sechdrs,
+					const char *secstrings)
 {
 	return 0;
 }
@@ -1060,9 +1068,10 @@ static inline int same_magic(const char 
 #endif /* CONFIG_MODVERSIONS */
 
 /* Resolve a symbol for this module.  I.e. if we find one, record usage. */
-static const struct kernel_symbol *resolve_symbol(struct module *mod,
-						  const struct load_info *info,
+static const struct kernel_symbol *resolve_symbol(Elf_Shdr *sechdrs,
+						  unsigned int versindex,
 						  const char *name,
+						  struct module *mod,
 						  char ownername[])
 {
 	struct module *owner;
@@ -1076,8 +1085,7 @@ static const struct kernel_symbol *resol
 	if (!sym)
 		goto unlock;
 
-	if (!check_version(info->sechdrs, info->index.vers, name, mod, crc,
-			   owner)) {
+	if (!check_version(sechdrs, versindex, name, mod, crc, owner)) {
 		sym = ERR_PTR(-EINVAL);
 		goto getname;
 	}
@@ -1096,20 +1104,21 @@ unlock:
 	return sym;
 }
 
-static const struct kernel_symbol *
-resolve_symbol_wait(struct module *mod,
-		    const struct load_info *info,
-		    const char *name)
+static const struct kernel_symbol *resolve_symbol_wait(Elf_Shdr *sechdrs,
+						       unsigned int versindex,
+						       const char *name,
+						       struct module *mod)
 {
 	const struct kernel_symbol *ksym;
-	char owner[MODULE_NAME_LEN];
+	char ownername[MODULE_NAME_LEN];
 
 	if (wait_event_interruptible_timeout(module_wq,
-			!IS_ERR(ksym = resolve_symbol(mod, info, name, owner))
-			|| PTR_ERR(ksym) != -EBUSY,
+			!IS_ERR(ksym = resolve_symbol(sechdrs, versindex, name,
+						      mod, ownername)) ||
+			PTR_ERR(ksym) != -EBUSY,
 					     30 * HZ) <= 0) {
 		printk(KERN_WARNING "%s: gave up waiting for init of module %s.\n",
-		       mod->name, owner);
+		       mod->name, ownername);
 	}
 	return ksym;
 }
@@ -1629,23 +1638,25 @@ static int verify_export_symbols(struct 
 }
 
 /* Change all symbols so that st_value encodes the pointer directly. */
-static int simplify_symbols(struct module *mod, const struct load_info *info)
+static int simplify_symbols(Elf_Shdr *sechdrs,
+			    unsigned int symindex,
+			    const char *strtab,
+			    unsigned int versindex,
+			    unsigned int pcpuindex,
+			    struct module *mod)
 {
-	Elf_Shdr *symsec = &info->sechdrs[info->index.sym];
-	Elf_Sym *sym = (void *)symsec->sh_addr;
+	Elf_Sym *sym = (void *)sechdrs[symindex].sh_addr;
 	unsigned long secbase;
-	unsigned int i;
+	unsigned int i, n = sechdrs[symindex].sh_size / sizeof(Elf_Sym);
 	int ret = 0;
 	const struct kernel_symbol *ksym;
 
-	for (i = 1; i < symsec->sh_size / sizeof(Elf_Sym); i++) {
-		const char *name = info->strtab + sym[i].st_name;
-
+	for (i = 1; i < n; i++) {
 		switch (sym[i].st_shndx) {
 		case SHN_COMMON:
 			/* We compiled with -fno-common.  These are not
 			   supposed to happen.  */
-			DEBUGP("Common symbol: %s\n", name);
+			DEBUGP("Common symbol: %s\n", strtab + sym[i].st_name);
 			printk("%s: please compile with -fno-common\n",
 			       mod->name);
 			ret = -ENOEXEC;
@@ -1658,7 +1669,9 @@ static int simplify_symbols(struct modul
 			break;
 
 		case SHN_UNDEF:
-			ksym = resolve_symbol_wait(mod, info, name);
+			ksym = resolve_symbol_wait(sechdrs, versindex,
+						   strtab + sym[i].st_name,
+						   mod);
 			/* Ok if resolved.  */
 			if (ksym && !IS_ERR(ksym)) {
 				sym[i].st_value = ksym->value;
@@ -1670,16 +1683,17 @@ static int simplify_symbols(struct modul
 				break;
 
 			printk(KERN_WARNING "%s: Unknown symbol %s (err %li)\n",
-			       mod->name, name, PTR_ERR(ksym));
+			       mod->name, strtab + sym[i].st_name,
+			       PTR_ERR(ksym));
 			ret = PTR_ERR(ksym) ?: -ENOENT;
 			break;
 
 		default:
 			/* Divert to percpu allocation if a percpu var. */
-			if (sym[i].st_shndx == info->index.pcpu)
+			if (sym[i].st_shndx == pcpuindex)
 				secbase = (unsigned long)mod_percpu(mod);
 			else
-				secbase = info->sechdrs[sym[i].st_shndx].sh_addr;
+				secbase = sechdrs[sym[i].st_shndx].sh_addr;
 			sym[i].st_value += secbase;
 			break;
 		}
@@ -1688,29 +1702,33 @@ static int simplify_symbols(struct modul
 	return ret;
 }
 
-static int apply_relocations(struct module *mod, const struct load_info *info)
+static int apply_relocations(struct module *mod,
+			     Elf_Ehdr *hdr,
+			     Elf_Shdr *sechdrs,
+			     unsigned int symindex,
+			     unsigned int strindex)
 {
 	unsigned int i;
 	int err = 0;
 
 	/* Now do relocations. */
-	for (i = 1; i < info->hdr->e_shnum; i++) {
-		unsigned int infosec = info->sechdrs[i].sh_info;
+	for (i = 1; i < hdr->e_shnum; i++) {
+		const char *strtab = (char *)sechdrs[strindex].sh_addr;
+		unsigned int info = sechdrs[i].sh_info;
 
 		/* Not a valid relocation section? */
-		if (infosec >= info->hdr->e_shnum)
+		if (info >= hdr->e_shnum)
 			continue;
 
 		/* Don't bother with non-allocated sections */
-		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
+		if (!(sechdrs[info].sh_flags & SHF_ALLOC))
 			continue;
 
-		if (info->sechdrs[i].sh_type == SHT_REL)
-			err = apply_relocate(info->sechdrs, info->strtab,
-					     info->index.sym, i, mod);
-		else if (info->sechdrs[i].sh_type == SHT_RELA)
-			err = apply_relocate_add(info->sechdrs, info->strtab,
-						 info->index.sym, i, mod);
+		if (sechdrs[i].sh_type == SHT_REL)
+			err = apply_relocate(sechdrs, strtab, symindex, i, mod);
+		else if (sechdrs[i].sh_type == SHT_RELA)
+			err = apply_relocate_add(sechdrs, strtab, symindex, i,
+						 mod);
 		if (err < 0)
 			break;
 	}
@@ -1741,7 +1759,10 @@ static long get_offset(struct module *mo
    might -- code, read-only data, read-write data, small data.  Tally
    sizes, and place the offsets into sh_entsize fields: high bit means it
    belongs in init. */
-static void layout_sections(struct module *mod, struct load_info *info)
+static void layout_sections(struct module *mod,
+			    const Elf_Ehdr *hdr,
+			    Elf_Shdr *sechdrs,
+			    const char *secstrings)
 {
 	static unsigned long const masks[][2] = {
 		/* NOTE: all executable code must be the first section
@@ -1754,22 +1775,21 @@ static void layout_sections(struct modul
 	};
 	unsigned int m, i;
 
-	for (i = 0; i < info->hdr->e_shnum; i++)
-		info->sechdrs[i].sh_entsize = ~0UL;
+	for (i = 0; i < hdr->e_shnum; i++)
+		sechdrs[i].sh_entsize = ~0UL;
 
 	DEBUGP("Core section allocation order:\n");
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
-		for (i = 0; i < info->hdr->e_shnum; ++i) {
-			Elf_Shdr *s = &info->sechdrs[i];
-			const char *sname = info->secstrings + s->sh_name;
+		for (i = 0; i < hdr->e_shnum; ++i) {
+			Elf_Shdr *s = &sechdrs[i];
 
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
 			    || s->sh_entsize != ~0UL
-			    || strstarts(sname, ".init"))
+			    || strstarts(secstrings + s->sh_name, ".init"))
 				continue;
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
-			DEBUGP("\t%s\n", name);
+			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
 		if (m == 0)
 			mod->core_text_size = mod->core_size;
@@ -1777,18 +1797,17 @@ static void layout_sections(struct modul
 
 	DEBUGP("Init section allocation order:\n");
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
-		for (i = 0; i < info->hdr->e_shnum; ++i) {
-			Elf_Shdr *s = &info->sechdrs[i];
-			const char *sname = info->secstrings + s->sh_name;
+		for (i = 0; i < hdr->e_shnum; ++i) {
+			Elf_Shdr *s = &sechdrs[i];
 
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
 			    || s->sh_entsize != ~0UL
-			    || !strstarts(sname, ".init"))
+			    || !strstarts(secstrings + s->sh_name, ".init"))
 				continue;
 			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
 					 | INIT_OFFSET_MASK);
-			DEBUGP("\t%s\n", sname);
+			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
 		if (m == 0)
 			mod->init_text_size = mod->init_size;
@@ -1827,28 +1846,33 @@ static char *next_string(char *string, u
 	return string;
 }
 
-static char *get_modinfo(struct load_info *info, const char *tag)
+static char *get_modinfo(const Elf_Shdr *sechdrs,
+			 unsigned int info,
+			 const char *tag)
 {
 	char *p;
 	unsigned int taglen = strlen(tag);
-	Elf_Shdr *infosec = &info->sechdrs[info->index.info];
-	unsigned long size = infosec->sh_size;
+	unsigned long size = sechdrs[info].sh_size;
 
-	for (p = (char *)infosec->sh_addr; p; p = next_string(p, &size)) {
+	for (p = (char *)sechdrs[info].sh_addr; p; p = next_string(p, &size)) {
 		if (strncmp(p, tag, taglen) == 0 && p[taglen] == '=')
 			return p + taglen + 1;
 	}
 	return NULL;
 }
 
-static void setup_modinfo(struct module *mod, struct load_info *info)
+static void setup_modinfo(struct module *mod, Elf_Shdr *sechdrs,
+			  unsigned int infoindex)
 {
 	struct module_attribute *attr;
 	int i;
 
 	for (i = 0; (attr = modinfo_attrs[i]); i++) {
 		if (attr->setup)
-			attr->setup(mod, get_modinfo(info, attr->attr.name));
+			attr->setup(mod,
+				    get_modinfo(sechdrs,
+						infoindex,
+						attr->attr.name));
 	}
 }
 
@@ -1950,45 +1974,56 @@ static bool is_core_symbol(const Elf_Sym
 	return true;
 }
 
-static void layout_symtab(struct module *mod, struct load_info *info)
-{
-	Elf_Shdr *symsect = info->sechdrs + info->index.sym;
-	Elf_Shdr *strsect = info->sechdrs + info->index.str;
+static unsigned long layout_symtab(struct module *mod,
+				   Elf_Shdr *sechdrs,
+				   unsigned int symindex,
+				   unsigned int strindex,
+				   const Elf_Ehdr *hdr,
+				   const char *secstrings,
+				   unsigned long *pstroffs,
+				   unsigned long *strmap)
+{
+	unsigned long symoffs;
+	Elf_Shdr *symsect = sechdrs + symindex;
+	Elf_Shdr *strsect = sechdrs + strindex;
 	const Elf_Sym *src;
+	const char *strtab;
 	unsigned int i, nsrc, ndst;
 
 	/* Put symbol section at end of init part of module. */
 	symsect->sh_flags |= SHF_ALLOC;
 	symsect->sh_entsize = get_offset(mod, &mod->init_size, symsect,
-					 info->index.sym) | INIT_OFFSET_MASK;
-	DEBUGP("\t%s\n", info->secstrings + symsect->sh_name);
+					 symindex) | INIT_OFFSET_MASK;
+	DEBUGP("\t%s\n", secstrings + symsect->sh_name);
 
-	src = (void *)info->hdr + symsect->sh_offset;
+	src = (void *)hdr + symsect->sh_offset;
 	nsrc = symsect->sh_size / sizeof(*src);
+	strtab = (void *)hdr + strsect->sh_offset;
 	for (ndst = i = 1; i < nsrc; ++i, ++src)
-		if (is_core_symbol(src, info->sechdrs, info->hdr->e_shnum)) {
+		if (is_core_symbol(src, sechdrs, hdr->e_shnum)) {
 			unsigned int j = src->st_name;
 
-			while (!__test_and_set_bit(j, info->strmap)
-			       && info->strtab[j])
+			while(!__test_and_set_bit(j, strmap) && strtab[j])
 				++j;
 			++ndst;
 		}
 
 	/* Append room for core symbols at end of core part. */
-	info->symoffs = ALIGN(mod->core_size, symsect->sh_addralign ?: 1);
-	mod->core_size = info->symoffs + ndst * sizeof(Elf_Sym);
+	symoffs = ALIGN(mod->core_size, symsect->sh_addralign ?: 1);
+	mod->core_size = symoffs + ndst * sizeof(Elf_Sym);
 
 	/* Put string table section at end of init part of module. */
 	strsect->sh_flags |= SHF_ALLOC;
 	strsect->sh_entsize = get_offset(mod, &mod->init_size, strsect,
-					 info->index.str) | INIT_OFFSET_MASK;
-	DEBUGP("\t%s\n", info->secstrings + strsect->sh_name);
+					 strindex) | INIT_OFFSET_MASK;
+	DEBUGP("\t%s\n", secstrings + strsect->sh_name);
 
 	/* Append room for core symbols' strings at end of core part. */
-	info->stroffs = mod->core_size;
-	__set_bit(0, info->strmap);
-	mod->core_size += bitmap_weight(info->strmap, strsect->sh_size);
+	*pstroffs = mod->core_size;
+	__set_bit(0, strmap);
+	mod->core_size += bitmap_weight(strmap, strsect->sh_size);
+
+	return symoffs;
 }
 
 static void add_kallsyms(struct module *mod, struct load_info *info)
@@ -2026,8 +2061,16 @@ static void add_kallsyms(struct module *
 			*++s = mod->strtab[i];
 }
 #else
-static inline void layout_symtab(struct module *mod, struct load_info *info)
+static inline unsigned long layout_symtab(struct module *mod,
+					  Elf_Shdr *sechdrs,
+					  unsigned int symindex,
+					  unsigned int strindex,
+					  const Elf_Ehdr *hdr,
+					  const char *secstrings,
+					  unsigned long *pstroffs,
+					  unsigned long *strmap)
 {
+	return 0;
 }
 
 static void add_kallsyms(struct module *mod, struct load_info *info)
@@ -2067,28 +2110,30 @@ static void *module_alloc_update_bounds(
 }
 
 #ifdef CONFIG_DEBUG_KMEMLEAK
-static void kmemleak_load_module(const struct module *mod,
-				 const struct load_info *info)
+static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
+				 const Elf_Shdr *sechdrs,
+				 const char *secstrings)
 {
 	unsigned int i;
 
 	/* only scan the sections containing data */
 	kmemleak_scan_area(mod, sizeof(struct module), GFP_KERNEL);
 
-	for (i = 1; i < info->hdr->e_shnum; i++) {
-		const char *name = info->secstrings + info->sechdrs[i].sh_name;
-		if (!(info->sechdrs[i].sh_flags & SHF_ALLOC))
+	for (i = 1; i < hdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
 			continue;
-		if (!strstarts(name, ".data") && !strstarts(name, ".bss"))
+		if (strncmp(secstrings + sechdrs[i].sh_name, ".data", 5) != 0
+		    && strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
 			continue;
 
-		kmemleak_scan_area((void *)info->sechdrs[i].sh_addr,
-				   info->sechdrs[i].sh_size, GFP_KERNEL);
+		kmemleak_scan_area((void *)sechdrs[i].sh_addr,
+				   sechdrs[i].sh_size, GFP_KERNEL);
 	}
 }
 #else
-static inline void kmemleak_load_module(const struct module *mod,
-					const struct load_info *info)
+static inline void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
+					Elf_Shdr *sechdrs,
+					const char *secstrings)
 {
 }
 #endif
@@ -2179,8 +2224,8 @@ static int rewrite_section_headers(struc
 	}
 
 	/* Track but don't keep modinfo and version sections. */
-	info->index.vers = find_sec(info, "__versions");
-	info->index.info = find_sec(info, ".modinfo");
+	info->index.vers = find_sec(info->hdr, info->sechdrs, info->secstrings, "__versions");
+	info->index.info = find_sec(info->hdr, info->sechdrs, info->secstrings, ".modinfo");
 	info->sechdrs[info->index.info].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	info->sechdrs[info->index.vers].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	return 0;
@@ -2220,7 +2265,8 @@ static struct module *setup_load_info(st
 		}
 	}
 
-	info->index.mod = find_sec(info, ".gnu.linkonce.this_module");
+	info->index.mod = find_sec(info->hdr, info->sechdrs, info->secstrings,
+			    ".gnu.linkonce.this_module");
 	if (!info->index.mod) {
 		printk(KERN_WARNING "No module found in object\n");
 		return ERR_PTR(-ENOEXEC);
@@ -2234,7 +2280,7 @@ static struct module *setup_load_info(st
 		return ERR_PTR(-ENOEXEC);
 	}
 
-	info->index.pcpu = find_pcpusec(info);
+	info->index.pcpu = find_pcpusec(info->hdr, info->sechdrs, info->secstrings);
 
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(info->sechdrs, info->index.vers, mod))
@@ -2243,9 +2289,11 @@ static struct module *setup_load_info(st
 	return mod;
 }
 
-static int check_modinfo(struct module *mod, struct load_info *info)
+static int check_modinfo(struct module *mod,
+			 const Elf_Shdr *sechdrs,
+			 unsigned int infoindex, unsigned int versindex)
 {
-	const char *modmagic = get_modinfo(info, "vermagic");
+	const char *modmagic = get_modinfo(sechdrs, infoindex, "vermagic");
 	int err;
 
 	/* This is allowed: modprobe --force will invalidate it. */
@@ -2253,13 +2301,13 @@ static int check_modinfo(struct module *
 		err = try_to_force_load(mod, "bad vermagic");
 		if (err)
 			return err;
-	} else if (!same_magic(modmagic, vermagic, info->index.vers)) {
+	} else if (!same_magic(modmagic, vermagic, versindex)) {
 		printk(KERN_ERR "%s: version magic '%s' should be '%s'\n",
 		       mod->name, modmagic, vermagic);
 		return -ENOEXEC;
 	}
 
-	if (get_modinfo(info, "staging")) {
+	if (get_modinfo(sechdrs, infoindex, "staging")) {
 		add_taint_module(mod, TAINT_CRAP);
 		printk(KERN_WARNING "%s: module is from the staging directory,"
 		       " the quality is unknown, you have been warned.\n",
@@ -2267,51 +2315,58 @@ static int check_modinfo(struct module *
 	}
 
 	/* Set up license info based on the info section */
-	set_license(mod, get_modinfo(info, "license"));
+	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
 
 	return 0;
 }
 
-static void find_module_sections(struct module *mod,
-				 const struct load_info *info)
+static void find_module_sections(struct module *mod, Elf_Ehdr *hdr,
+				 Elf_Shdr *sechdrs, const char *secstrings)
 {
-	mod->kp = section_objs(info, "__param",
+	mod->kp = section_objs(hdr, sechdrs, secstrings, "__param",
 			       sizeof(*mod->kp), &mod->num_kp);
-	mod->syms = section_objs(info, "__ksymtab",
+	mod->syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab",
 				 sizeof(*mod->syms), &mod->num_syms);
-	mod->crcs = section_addr(info, "__kcrctab");
-	mod->gpl_syms = section_objs(info, "__ksymtab_gpl",
+	mod->crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab");
+	mod->gpl_syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab_gpl",
 				     sizeof(*mod->gpl_syms),
 				     &mod->num_gpl_syms);
-	mod->gpl_crcs = section_addr(info, "__kcrctab_gpl");
-	mod->gpl_future_syms = section_objs(info,
+	mod->gpl_crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab_gpl");
+	mod->gpl_future_syms = section_objs(hdr, sechdrs, secstrings,
 					    "__ksymtab_gpl_future",
 					    sizeof(*mod->gpl_future_syms),
 					    &mod->num_gpl_future_syms);
-	mod->gpl_future_crcs = section_addr(info, "__kcrctab_gpl_future");
+	mod->gpl_future_crcs = section_addr(hdr, sechdrs, secstrings,
+					    "__kcrctab_gpl_future");
 
 #ifdef CONFIG_UNUSED_SYMBOLS
-	mod->unused_syms = section_objs(info, "__ksymtab_unused",
+	mod->unused_syms = section_objs(hdr, sechdrs, secstrings,
+					"__ksymtab_unused",
 					sizeof(*mod->unused_syms),
 					&mod->num_unused_syms);
-	mod->unused_crcs = section_addr(info, "__kcrctab_unused");
-	mod->unused_gpl_syms = section_objs(info, "__ksymtab_unused_gpl",
+	mod->unused_crcs = section_addr(hdr, sechdrs, secstrings,
+					"__kcrctab_unused");
+	mod->unused_gpl_syms = section_objs(hdr, sechdrs, secstrings,
+					    "__ksymtab_unused_gpl",
 					    sizeof(*mod->unused_gpl_syms),
 					    &mod->num_unused_gpl_syms);
-	mod->unused_gpl_crcs = section_addr(info, "__kcrctab_unused_gpl");
+	mod->unused_gpl_crcs = section_addr(hdr, sechdrs, secstrings,
+					    "__kcrctab_unused_gpl");
 #endif
 #ifdef CONFIG_CONSTRUCTORS
-	mod->ctors = section_objs(info, ".ctors",
+	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
 				  sizeof(*mod->ctors), &mod->num_ctors);
 #endif
 
 #ifdef CONFIG_TRACEPOINTS
-	mod->tracepoints = section_objs(info, "__tracepoints",
+	mod->tracepoints = section_objs(hdr, sechdrs, secstrings,
+					"__tracepoints",
 					sizeof(*mod->tracepoints),
 					&mod->num_tracepoints);
 #endif
 #ifdef CONFIG_EVENT_TRACING
-	mod->trace_events = section_objs(info, "_ftrace_events",
+	mod->trace_events = section_objs(hdr, sechdrs, secstrings,
+					 "_ftrace_events",
 					 sizeof(*mod->trace_events),
 					 &mod->num_trace_events);
 	/*
@@ -2323,17 +2378,20 @@ static void find_module_sections(struct 
 #endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 	/* sechdrs[0].sh_size is always zero */
-	mod->ftrace_callsites = section_objs(info, "__mcount_loc",
+	mod->ftrace_callsites = section_objs(hdr, sechdrs, secstrings,
+					     "__mcount_loc",
 					     sizeof(*mod->ftrace_callsites),
 					     &mod->num_ftrace_callsites);
 #endif
 
-	if (section_addr(info, "__obsparm"))
+	if (section_addr(hdr, sechdrs, secstrings, "__obsparm"))
 		printk(KERN_WARNING "%s: Ignoring obsolete parameters\n",
 		       mod->name);
 }
 
-static int move_module(struct module *mod, struct load_info *info)
+static int move_module(struct module *mod,
+		       Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
+		       const char *secstrings, unsigned modindex)
 {
 	int i;
 	void *ptr;
@@ -2369,31 +2427,32 @@ static int move_module(struct module *mo
 
 	/* Transfer each section which specifies SHF_ALLOC */
 	DEBUGP("final section addresses:\n");
-	for (i = 0; i < info->hdr->e_shnum; i++) {
+	for (i = 0; i < hdr->e_shnum; i++) {
 		void *dest;
-		Elf_Shdr *shdr = &info->sechdrs[i];
 
-		if (!(shdr->sh_flags & SHF_ALLOC))
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
 			continue;
 
-		if (shdr->sh_entsize & INIT_OFFSET_MASK)
+		if (sechdrs[i].sh_entsize & INIT_OFFSET_MASK)
 			dest = mod->module_init
-				+ (shdr->sh_entsize & ~INIT_OFFSET_MASK);
+				+ (sechdrs[i].sh_entsize & ~INIT_OFFSET_MASK);
 		else
-			dest = mod->module_core + shdr->sh_entsize;
+			dest = mod->module_core + sechdrs[i].sh_entsize;
 
-		if (shdr->sh_type != SHT_NOBITS)
-			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
+		if (sechdrs[i].sh_type != SHT_NOBITS)
+			memcpy(dest, (void *)sechdrs[i].sh_addr,
+			       sechdrs[i].sh_size);
 		/* Update sh_addr to point to copy in image. */
-		shdr->sh_addr = (unsigned long)dest;
+		sechdrs[i].sh_addr = (unsigned long)dest;
 		DEBUGP("\t0x%lx %s\n",
-		       shdr->sh_addr, info->secstrings + shdr->sh_name);
+		       sechdrs[i].sh_addr, secstrings + sechdrs[i].sh_name);
 	}
 
 	return 0;
 }
 
-static int check_module_license_and_versions(struct module *mod)
+static int check_module_license_and_versions(struct module *mod,
+					     Elf_Shdr *sechdrs)
 {
 	/*
 	 * ndiswrapper is under GPL by itself, but loads proprietary modules.
@@ -2450,37 +2509,34 @@ static struct module *layout_and_allocat
 {
 	/* Module within temporary copy. */
 	struct module *mod;
-	Elf_Shdr *pcpusec;
 	int err;
 
 	mod = setup_load_info(info);
 	if (IS_ERR(mod))
 		return mod;
 
-	err = check_modinfo(mod, info);
+	err = check_modinfo(mod, info->sechdrs, info->index.info, info->index.vers);
 	if (err)
 		return ERR_PTR(err);
 
 	/* Allow arches to frob section contents and sizes.  */
-	err = module_frob_arch_sections(info->hdr, info->sechdrs,
-					info->secstrings, mod);
+	err = module_frob_arch_sections(info->hdr, info->sechdrs, info->secstrings, mod);
 	if (err < 0)
 		goto free_args;
 
-	pcpusec = &info->sechdrs[info->index.pcpu];
-	if (pcpusec->sh_size) {
+	if (info->index.pcpu) {
 		/* We have a special allocation for this section. */
-		err = percpu_modalloc(mod,
-				      pcpusec->sh_size, pcpusec->sh_addralign);
+		err = percpu_modalloc(mod, info->sechdrs[info->index.pcpu].sh_size,
+				      info->sechdrs[info->index.pcpu].sh_addralign);
 		if (err)
 			goto free_args;
-		pcpusec->sh_flags &= ~(unsigned long)SHF_ALLOC;
+		info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	}
 
 	/* Determine total sizes, and put offsets in sh_entsize.  For now
 	   this is done generically; there doesn't appear to be any
 	   special cases for the architectures. */
-	layout_sections(mod, info);
+	layout_sections(mod, info->hdr, info->sechdrs, info->secstrings);
 
 	info->strmap = kzalloc(BITS_TO_LONGS(info->sechdrs[info->index.str].sh_size)
 			 * sizeof(long), GFP_KERNEL);
@@ -2488,16 +2544,17 @@ static struct module *layout_and_allocat
 		err = -ENOMEM;
 		goto free_percpu;
 	}
-	layout_symtab(mod, info);
+	info->symoffs = layout_symtab(mod, info->sechdrs, info->index.sym, info->index.str, info->hdr,
+				info->secstrings, &info->stroffs, info->strmap);
 
 	/* Allocate and move to the final place */
-	err = move_module(mod, info);
+	err = move_module(mod, info->hdr, info->sechdrs, info->secstrings, info->index.mod);
 	if (err)
 		goto free_strmap;
 
 	/* Module has been copied to its final place now: return it. */
 	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
-	kmemleak_load_module(mod, info);
+	kmemleak_load_module(mod, info->hdr, info->sechdrs, info->secstrings);
 	return mod;
 
 free_strmap:
@@ -2545,33 +2602,34 @@ static noinline struct module *load_modu
 		goto free_copy;
 	}
 
-	/* Now module is in final location, initialize linked lists, etc. */
+	/* Now we've moved module, initialize linked lists, etc. */
 	err = module_unload_init(mod);
 	if (err)
 		goto free_module;
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
-	find_module_sections(mod, &info);
+	find_module_sections(mod, info.hdr, info.sechdrs, info.secstrings);
 
-	err = check_module_license_and_versions(mod);
+	err = check_module_license_and_versions(mod, info.sechdrs);
 	if (err)
 		goto free_unload;
 
 	/* Set up MODINFO_ATTR fields */
-	setup_modinfo(mod, &info);
+	setup_modinfo(mod, info.sechdrs, info.index.info);
 
 	/* Fix up syms, so that st_value is a pointer to location. */
-	err = simplify_symbols(mod, &info);
+	err = simplify_symbols(info.sechdrs, info.index.sym, info.strtab, info.index.vers, info.index.pcpu,
+			       mod);
 	if (err < 0)
 		goto free_modinfo;
 
-	err = apply_relocations(mod, &info);
+	err = apply_relocations(mod, info.hdr, info.sechdrs, info.index.sym, info.index.str);
 	if (err < 0)
 		goto free_modinfo;
 
   	/* Set up and sort exception table */
-	mod->extable = section_objs(&info, "__ex_table",
+	mod->extable = section_objs(info.hdr, info.sechdrs, info.secstrings, "__ex_table",
 				    sizeof(*mod->extable), &mod->num_exentries);
 	sort_extable(mod->extable, mod->extable + mod->num_exentries);
 
@@ -2582,7 +2640,7 @@ static noinline struct module *load_modu
 	add_kallsyms(mod, &info);
 
 	if (!mod->taints)
-		debug = section_objs(&info, "__verbose",
+		debug = section_objs(info.hdr, info.sechdrs, info.secstrings, "__verbose",
 				     sizeof(*debug), &num_debug);
 
 	err = module_finalize(info.hdr, info.sechdrs, mod);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch
revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch
revert-fdc8302019d9bc10729cd3e8d348571e833388aa.patch
revert-324d76561842e551051e2a897b958b0539f6867b.patch
revert-e92e80797e7eaaf2a9bbd586c63f7c6bd3177276.patch
revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch
revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch
revert-4624469822455b4accc886557f6c997ccdd59066.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix-fix.patch
drivers-gpio-is-platform-neutral-fix.patch
ipc-semc-bugfix-for-semop-not-reporting-successful-operation-fix.patch
fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch
acpi-fix-bogus-preemption-logic-fix.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

