Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457067493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sSRed+Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF0BC433C8;
	Mon, 11 Dec 2023 01:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257829;
	bh=2sLooo5c4ch3BCJ+RSKysIFc+EiFdkmUJedIh6kAzgU=;
	h=Date:To:From:Subject:From;
	b=sSRed+Cyo76SwmeKU86o56XrV4JLCZHqSA6LGxOrqbr6Y2DOjvAgj72ZoN+EKBZEZ
	 cfC9w0Rair69SmbRdG5BMLx/8cMUHepohfbFP7RoPDHD8+CpebY0XkawsFNbz4BGBt
	 1bfyRQClxBmf/C1OvvmVLYzkSj148JHKoot3Gtpo=
Date: Sun, 10 Dec 2023 17:23:48 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-hide-conditionally-unused-functions.patch removed from -mm tree
Message-Id: <20231211012349.0EF0BC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: hide conditionally unused functions
has been removed from the -mm tree.  Its filename was
     mips-hide-conditionally-unused-functions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: hide conditionally unused functions
Date: Mon, 4 Dec 2023 12:57:08 +0100

A couple of functions are defined unconditionally but have a conditional
declaration:

arch/mips/mm/tlb-r4k.c:461:12: error: no previous prototype for 'add_temporary_entry' [-Werror=missing-prototypes]
arch/mips/mm/pgtable-64.c:92:7: error: no previous prototype for 'mk_pmd' [-Werror=missing-prototypes]
arch/mips/mm/pgtable-64.c:101:6: error: no previous prototype for 'set_pmd_at' [-Werror=missing-prototypes]

Since there are no callers in these configurations, add the same #ifdef
checks around the definitions.

Link: https://lkml.kernel.org/r/20231204115710.2247097-19-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/pgtable-64.c |    2 ++
 arch/mips/mm/tlb-r4k.c    |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/mips/mm/pgtable-64.c~mips-hide-conditionally-unused-functions
+++ a/arch/mips/mm/pgtable-64.c
@@ -89,6 +89,7 @@ void pud_init(void *addr)
 }
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 pmd_t mk_pmd(struct page *page, pgprot_t prot)
 {
 	pmd_t pmd;
@@ -103,6 +104,7 @@ void set_pmd_at(struct mm_struct *mm, un
 {
 	*pmdp = pmd;
 }
+#endif
 
 void __init pagetable_init(void)
 {
--- a/arch/mips/mm/tlb-r4k.c~mips-hide-conditionally-unused-functions
+++ a/arch/mips/mm/tlb-r4k.c
@@ -458,6 +458,7 @@ EXPORT_SYMBOL(has_transparent_hugepage);
 
 int temp_tlb_entry;
 
+#ifndef CONFIG_64BIT
 __init int add_temporary_entry(unsigned long entrylo0, unsigned long entrylo1,
 			       unsigned long entryhi, unsigned long pagemask)
 {
@@ -496,6 +497,7 @@ out:
 	local_irq_restore(flags);
 	return ret;
 }
+#endif
 
 static int ntlb;
 static int __init set_ntlb(char *str)
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

