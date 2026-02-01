Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF6D3EBF1D;
	Sun,  1 Feb 2026 00:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905021; cv=none; b=WtiXVdkwp7eYHiIKq4VR+HYfdZaO+aOOeS6yHHA3O0YMAqNtY+aT7XrfdbFBpTF4GkUexq9ril2ZNQFeCK8zXPs1mOLDH7vRoQ8HEVO5ORWxg1tMdYdVFWi6XTUG53225SyWFFB+gPdSine+Ysa/91BDJ/xeK5Qik6GOZc8kCgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905021; c=relaxed/simple;
	bh=jAhJIjlVkqx/bO89ffK0f8uYNQbLfXoDzrXdh05hpGA=;
	h=Date:To:From:Subject:Message-Id; b=uHTYsT3iEj4QlHAtqeue4NI6Dcc5UmRupYn5kphG7UhjesMOPfqa5LRd/JreddcOg1sA6nlBGydnKfOCblA6fSg+/rpjsn9yfRoey25P7M0Rv6WqFYiF0REMdcNaz00os+U6cBat4heGpumI9BeR3tXGvDZhI/UmXJfgZNLag/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GJGVeeLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GJGVeeLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CA5C116D0;
	Sun,  1 Feb 2026 00:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905021;
	bh=jAhJIjlVkqx/bO89ffK0f8uYNQbLfXoDzrXdh05hpGA=;
	h=Date:To:From:Subject:From;
	b=GJGVeeLz0vIiBgIqi7C8NnZYNwh5Pn5TjuPejqRavXm6ti/gNCMUoAbF7CWCfWney
	 OcS3KYYy4cFUy8Q6x/shzQpVUB0Vgy2ZKrT7ipmKvfY2xfUxm3uU6KMyJW/KdZCySU
	 QC4LNEi+Gf1PKlbBJAXSoLzGtB/3f5xgd+Ul8ZH4=
Date: Sat, 31 Jan 2026 16:17:00 -0800
To: mm-commits@vger.kernel.org,zwisler@google.com,stable@vger.kernel.org,sourabhjain@linux.ibm.com,rostedt@goodmis.org,ribalda@chromium.org,prudo@redhat.com,graf@amazon.com,ebiggers@kernel.org,bhe@redhat.com,me@linux.beauty,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-derive-purgatory-entry-from-symbol.patch removed from -mm tree
Message-Id: <20260201001701.34CA5C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: derive purgatory entry from symbol
has been removed from the -mm tree.  Its filename was
     kexec-derive-purgatory-entry-from-symbol.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Chen <me@linux.beauty>
Subject: kexec: derive purgatory entry from symbol
Date: Tue, 20 Jan 2026 20:40:04 +0800

kexec_load_purgatory() derives image->start by locating e_entry inside an
SHF_EXECINSTR section.  If the purgatory object contains multiple
executable sections with overlapping sh_addr, the entrypoint check can
match more than once and trigger a WARN.

Derive the entry section from the purgatory_start symbol when present and
compute image->start from its final placement.  Keep the existing e_entry
fallback for purgatories that do not expose the symbol.

WARNING: kernel/kexec_file.c:1009 at kexec_load_purgatory+0x395/0x3c0, CPU#10: kexec/1784
Call Trace:
 <TASK>
 bzImage64_load+0x133/0xa00
 __do_sys_kexec_file_load+0x2b3/0x5c0
 do_syscall_64+0x81/0x610
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

[me@linux.beauty: move helper to avoid forward declaration, per Baoquan]
  Link: https://lkml.kernel.org/r/20260128043511.316860-1-me@linux.beauty
Link: https://lkml.kernel.org/r/20260120124005.148381-1-me@linux.beauty
Fixes: 8652d44f466a ("kexec: support purgatories with .text.hot sections")
Signed-off-by: Li Chen <me@linux.beauty>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Li Chen <me@linux.beauty>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Ricardo Ribalda Delgado <ribalda@chromium.org>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |  131 +++++++++++++++++++++++-------------------
 1 file changed, 74 insertions(+), 57 deletions(-)

--- a/kernel/kexec_file.c~kexec-derive-purgatory-entry-from-symbol
+++ a/kernel/kexec_file.c
@@ -883,6 +883,60 @@ out_free_sha_regions:
 
 #ifdef CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY
 /*
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
+/*
  * kexec_purgatory_setup_kbuf - prepare buffer to load purgatory.
  * @pi:		Purgatory to be loaded.
  * @kbuf:	Buffer to setup.
@@ -960,6 +1014,10 @@ static int kexec_purgatory_setup_sechdrs
 	unsigned long offset;
 	size_t sechdrs_size;
 	Elf_Shdr *sechdrs;
+	const Elf_Sym *entry_sym;
+	u16 entry_shndx = 0;
+	unsigned long entry_off = 0;
+	bool start_fixed = false;
 	int i;
 
 	/*
@@ -977,6 +1035,12 @@ static int kexec_purgatory_setup_sechdrs
 	bss_addr = kbuf->mem + kbuf->bufsz;
 	kbuf->image->start = pi->ehdr->e_entry;
 
+	entry_sym = kexec_purgatory_find_symbol(pi, "purgatory_start");
+	if (entry_sym) {
+		entry_shndx = entry_sym->st_shndx;
+		entry_off = entry_sym->st_value;
+	}
+
 	for (i = 0; i < pi->ehdr->e_shnum; i++) {
 		unsigned long align;
 		void *src, *dst;
@@ -994,6 +1058,13 @@ static int kexec_purgatory_setup_sechdrs
 
 		offset = ALIGN(offset, align);
 
+		if (!start_fixed && entry_sym && i == entry_shndx &&
+		    (sechdrs[i].sh_flags & SHF_EXECINSTR) &&
+		    entry_off < sechdrs[i].sh_size) {
+			kbuf->image->start = kbuf->mem + offset + entry_off;
+			start_fixed = true;
+		}
+
 		/*
 		 * Check if the segment contains the entry point, if so,
 		 * calculate the value of image->start based on it.
@@ -1004,13 +1075,14 @@ static int kexec_purgatory_setup_sechdrs
 		 * is not set to the initial value, and warn the user so they
 		 * have a chance to fix their purgatory's linker script.
 		 */
-		if (sechdrs[i].sh_flags & SHF_EXECINSTR &&
+		if (!start_fixed && sechdrs[i].sh_flags & SHF_EXECINSTR &&
 		    pi->ehdr->e_entry >= sechdrs[i].sh_addr &&
 		    pi->ehdr->e_entry < (sechdrs[i].sh_addr
 					 + sechdrs[i].sh_size) &&
-		    !WARN_ON(kbuf->image->start != pi->ehdr->e_entry)) {
+		    kbuf->image->start == pi->ehdr->e_entry) {
 			kbuf->image->start -= sechdrs[i].sh_addr;
 			kbuf->image->start += kbuf->mem + offset;
+			start_fixed = true;
 		}
 
 		src = (void *)pi->ehdr + sechdrs[i].sh_offset;
@@ -1128,61 +1200,6 @@ out_free_kbuf:
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

