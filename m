Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7105322B79
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 19:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769627999; cv=none; b=VUxdAveRkbQWp9QwY3/4wbxPW5XgzHwb50OtiC8I6fuy/ZUEwGq+7jkexU79Aq7pnvsCoZxpMEa/b1QWKypbWO6Xt2B/z5RrvyGoSA+xI6/0zgat02Yj1tcqep1O082S7PgMvV/f5TBRWggXxoujDiChRP3mut4SgYyazHHk5V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769627999; c=relaxed/simple;
	bh=GksUaoBhLHRvwmEm5DBszZjkUO3FnhHWd8YO3yar3LY=;
	h=Date:To:From:Subject:Message-Id; b=SLIV8wUpR0fO8OWIqOXp1ziLtiXzshG6/DGHmBIKisXPgvUx70h+86uTx+RG9Kr15gOUTm3IS7UVjisRLm9YVT7Ct4iz4i9v0WudmH/yCC3pHXOFSAcXlJ+h0CaJWoY+X3G/1DTBpv02+HCCzzazxVfuYj6SAnCSETBSlZ41zqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ncAyxLnR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ncAyxLnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DF8C4CEF1;
	Wed, 28 Jan 2026 19:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769627999;
	bh=GksUaoBhLHRvwmEm5DBszZjkUO3FnhHWd8YO3yar3LY=;
	h=Date:To:From:Subject:From;
	b=ncAyxLnRohEbg5DePZ/nnE9qAOYeR6VqXn+NXymm6aVcCvnMgfni7YR7kTwvo8JAS
	 oDrkblA9F9Y3xWViDTG5TaipUIzml1NET6eZJ6HF+LhW9APoZ/SOGZACHtwTb/0HBN
	 6V51aN0TS1FjxW4tIMmtR8sxCf9p68cAsUSl6TLU=
Date: Wed, 28 Jan 2026 11:19:58 -0800
To: mm-commits@vger.kernel.org,bhe@redhat.com,me@linux.beauty,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-derive-purgatory-entry-from-symbol-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20260128191959.15DF8C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec-derive-purgatory-entry-from-symbol-v2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-derive-purgatory-entry-from-symbol-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-derive-purgatory-entry-from-symbol-v2.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

kexec-derive-purgatory-entry-from-symbol.patch
kexec-derive-purgatory-entry-from-symbol-v2.patch

