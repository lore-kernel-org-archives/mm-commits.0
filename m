Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7AAA59
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769904513; cv=none; b=ryhMgvGOh7mXguS92OProRSjEw7ik6z2hMiowtJyti/3v/t/c413SKb1rwfGFAdP/hQi0JAKJ5T6J7GJIUhyNg8quYYV7IM8bZPJjXJmsQb5zf6yWyK0Rf9Vo8zNHCDiWfH2TSQ5LArQ7+pPk+4O0eDC7ef6whzPhylbOpyicow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769904513; c=relaxed/simple;
	bh=S3CIunG/jTtLtmudZozLzJqNavkon6o00Ub3L/OQtZs=;
	h=Date:To:From:Subject:Message-Id; b=F/o+/bU0z8RoN486/2cK5dEno4rK4Ma5cKEAW24CdsHkm73NEkz2Ff2gYQM6ggI6UUPSW4IVBPE6lx0U+2ChOIhzpPTjeK1Ep9hzOZ/wbZY1BKYYV0Tdmxg7AKJU02fMgd+59jbR8Forc7fVe6vohFxV5apVG+NSTVamJo+qCn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZV3BUeiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZV3BUeiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3D9C4CEF1;
	Sun,  1 Feb 2026 00:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769904513;
	bh=S3CIunG/jTtLtmudZozLzJqNavkon6o00Ub3L/OQtZs=;
	h=Date:To:From:Subject:From;
	b=ZV3BUeiGK/euiE/X2FkeVi4Yv4wTjcVw5M18VHTTmxPZhKJw+yyEPcquRwaf4aUH3
	 rBrJPTrTsQZls7801HAd5nRyOJX1YDhFTua/b8wn/TzFGRYjAD8YgB0ItnVzjFo1m7
	 cj4Cb23ZN8af2fI9xRgnlxh9UG4uiU4jHvz96bv0=
Date: Sat, 31 Jan 2026 16:08:32 -0800
To: mm-commits@vger.kernel.org,bhe@redhat.com,me@linux.beauty,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kexec-derive-purgatory-entry-from-symbol-v2.patch removed from -mm tree
Message-Id: <20260201000833.0D3D9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec-derive-purgatory-entry-from-symbol-v2
has been removed from the -mm tree.  Its filename was
     kexec-derive-purgatory-entry-from-symbol-v2.patch

This patch was dropped because it was folded into kexec-derive-purgatory-entry-from-symbol.patch

------------------------------------------------------
From: Li Chen <me@linux.beauty>
Subject: kexec-derive-purgatory-entry-from-symbol-v2
Date: Wed, 28 Jan 2026 12:35:10 +0800

move the helper body above kexec_purgatory_setup_sechdrs() to avoid the
forward declaration, per Baoquan

Link: https://lkml.kernel.org/r/20260128043511.316860-1-me@linux.beauty
Fixes: 8652d44f466a ("kexec: support purgatories with .text.hot sections")
Signed-off-by: Li Chen <me@linux.beauty>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |  111 ++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 57 deletions(-)

--- a/kernel/kexec_file.c~kexec-derive-purgatory-entry-from-symbol-v2
+++ a/kernel/kexec_file.c
@@ -882,8 +882,60 @@ out_free_sha_regions:
 }
 
 #ifdef CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY
-static const Elf_Sym * kexec_purgatory_find_symbol(struct purgatory_info *pi,
-			      const char *name);
+/*
+ * kexec_purgatory_find_symbol - find a symbol in the purgatory
+ * @pi:		Purgatory to search in.
+ * @name:	Name of the symbol.
+ *
+ * Return: pointer to symbol in read-only symtab on success, NULL on error.
+ */
+static const Elf_Sym *kexec_purgatory_find_symbol(struct purgatory_info *pi,
+						  const char *name)
+{
+	const Elf_Shdr *sechdrs;
+	const Elf_Ehdr *ehdr;
+	const Elf_Sym *syms;
+	const char *strtab;
+	int i, k;
+
+	if (!pi->ehdr)
+		return NULL;
+
+	ehdr = pi->ehdr;
+	sechdrs = (void *)ehdr + ehdr->e_shoff;
+
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		if (sechdrs[i].sh_type != SHT_SYMTAB)
+			continue;
+
+		if (sechdrs[i].sh_link >= ehdr->e_shnum)
+			/* Invalid strtab section number */
+			continue;
+		strtab = (void *)ehdr + sechdrs[sechdrs[i].sh_link].sh_offset;
+		syms = (void *)ehdr + sechdrs[i].sh_offset;
+
+		/* Go through symbols for a match */
+		for (k = 0; k < sechdrs[i].sh_size/sizeof(Elf_Sym); k++) {
+			if (ELF_ST_BIND(syms[k].st_info) != STB_GLOBAL)
+				continue;
+
+			if (strcmp(strtab + syms[k].st_name, name) != 0)
+				continue;
+
+			if (syms[k].st_shndx == SHN_UNDEF ||
+			    syms[k].st_shndx >= ehdr->e_shnum) {
+				pr_debug("Symbol: %s has bad section index %d.\n",
+					name, syms[k].st_shndx);
+				return NULL;
+			}
+
+			/* Found the symbol we are looking for */
+			return &syms[k];
+		}
+	}
+
+	return NULL;
+}
 /*
  * kexec_purgatory_setup_kbuf - prepare buffer to load purgatory.
  * @pi:		Purgatory to be loaded.
@@ -1148,61 +1200,6 @@ out_free_kbuf:
 	return ret;
 }
 
-/*
- * kexec_purgatory_find_symbol - find a symbol in the purgatory
- * @pi:		Purgatory to search in.
- * @name:	Name of the symbol.
- *
- * Return: pointer to symbol in read-only symtab on success, NULL on error.
- */
-static const Elf_Sym *kexec_purgatory_find_symbol(struct purgatory_info *pi,
-						  const char *name)
-{
-	const Elf_Shdr *sechdrs;
-	const Elf_Ehdr *ehdr;
-	const Elf_Sym *syms;
-	const char *strtab;
-	int i, k;
-
-	if (!pi->ehdr)
-		return NULL;
-
-	ehdr = pi->ehdr;
-	sechdrs = (void *)ehdr + ehdr->e_shoff;
-
-	for (i = 0; i < ehdr->e_shnum; i++) {
-		if (sechdrs[i].sh_type != SHT_SYMTAB)
-			continue;
-
-		if (sechdrs[i].sh_link >= ehdr->e_shnum)
-			/* Invalid strtab section number */
-			continue;
-		strtab = (void *)ehdr + sechdrs[sechdrs[i].sh_link].sh_offset;
-		syms = (void *)ehdr + sechdrs[i].sh_offset;
-
-		/* Go through symbols for a match */
-		for (k = 0; k < sechdrs[i].sh_size/sizeof(Elf_Sym); k++) {
-			if (ELF_ST_BIND(syms[k].st_info) != STB_GLOBAL)
-				continue;
-
-			if (strcmp(strtab + syms[k].st_name, name) != 0)
-				continue;
-
-			if (syms[k].st_shndx == SHN_UNDEF ||
-			    syms[k].st_shndx >= ehdr->e_shnum) {
-				pr_debug("Symbol: %s has bad section index %d.\n",
-						name, syms[k].st_shndx);
-				return NULL;
-			}
-
-			/* Found the symbol we are looking for */
-			return &syms[k];
-		}
-	}
-
-	return NULL;
-}
-
 void *kexec_purgatory_get_symbol_addr(struct kimage *image, const char *name)
 {
 	struct purgatory_info *pi = &image->purgatory_info;
_

Patches currently in -mm which might be from me@linux.beauty are

documentation-document-liveupdate-cmdline-parameter.patch
kexec-derive-purgatory-entry-from-symbol.patch

