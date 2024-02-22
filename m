Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F945320B
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560147; cv=none; b=EcJbNVc6iPYKm6sdTpz9jNyCBIzHrKtGQhVHD8kdunBqQB4ZIyLDT6C50vsDVEAl/HF6+jSsXccYxlnh8SbxOEx2DLp7nk4/e9GR+0x4I8hI9pAAdQ+x1DDehuy0jsgRnpAjdSCQE9o6Vji75M1lqvMllyW+f/Y2a1TbrGsrUqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560147; c=relaxed/simple;
	bh=ESn8YDNaVDvmMptfEj9xgp14AC0s3wEyDdgMO0V1KQI=;
	h=Date:To:From:Subject:Message-Id; b=PpOA4WMxgRYmD2EN2ZGg1pczNoBeXuqyQRZcaKLQ6Av9tkTG77PSyiBwfc6uKfERUQ4M1H2rGoYtB2BkU1v83IPUyfLR29h7n7m32qPBJw/ciM9+/tewRbqaD1ncMEOUHDEJtxi4STmIV9K9aFIETZNGddDtl14xccaMAJnbBxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tLzz5FSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tLzz5FSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16693C433F1;
	Thu, 22 Feb 2024 00:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560147;
	bh=ESn8YDNaVDvmMptfEj9xgp14AC0s3wEyDdgMO0V1KQI=;
	h=Date:To:From:Subject:From;
	b=tLzz5FSFRcoWtqS8s0znU052/UlNHy9vcNMkvtxVwUmLVKfEIHM5jxG4oh+1wsZ3r
	 waMwuP1w/+ZwUX5yv886tPVXHLjSRpa+bktVA9HtU08lhNNlvbb0+EleZrD8djIlFq
	 ye7xePCW3kJdcOMZXqY40dj6k/b+rBhzVDnllCJY=
Date: Wed, 21 Feb 2024 16:02:26 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tranmanphong@gmail.com,tglx@linutronix.de,svens@linux.ibm.com,steven.price@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,hpa@zytor.com,hca@linux.ibm.com,greg@kroah.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ptdump-have-ptdump_check_wx-return-bool.patch removed from -mm tree
Message-Id: <20240222000227.16693C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: ptdump: have ptdump_check_wx() return bool
has been removed from the -mm tree.  Its filename was
     mm-ptdump-have-ptdump_check_wx-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: ptdump: have ptdump_check_wx() return bool
Date: Tue, 30 Jan 2024 11:34:35 +0100

Have ptdump_check_wx() return true when the check is successful or false
otherwise.

[akpm@linux-foundation.org: fix a couple of build issues (x86_64 allmodconfig)]
Link: https://lkml.kernel.org/r/7943149fe955458cb7b57cd483bf41a3aad94684.1706610398.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Phong Tran <tranmanphong@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Steven Price <steven.price@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/ptdump.c          |   11 ++++++++---
 arch/powerpc/mm/ptdump/ptdump.c |   13 +++++++++----
 arch/riscv/mm/ptdump.c          |   11 ++++++++---
 arch/s390/mm/dump_pagetables.c  |   13 +++++++++----
 arch/x86/include/asm/pgtable.h  |    2 +-
 arch/x86/mm/dump_pagetables.c   |   23 ++++++++++++++---------
 include/linux/ptdump.h          |    5 ++++-
 7 files changed, 53 insertions(+), 25 deletions(-)

--- a/arch/arm64/mm/ptdump.c~mm-ptdump-have-ptdump_check_wx-return-bool
+++ a/arch/arm64/mm/ptdump.c
@@ -345,7 +345,7 @@ static struct ptdump_info kernel_ptdump_
 	.base_addr	= PAGE_OFFSET,
 };
 
-void ptdump_check_wx(void)
+bool ptdump_check_wx(void)
 {
 	struct pg_state st = {
 		.seq = NULL,
@@ -366,11 +366,16 @@ void ptdump_check_wx(void)
 
 	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
 
-	if (st.wx_pages || st.uxn_pages)
+	if (st.wx_pages || st.uxn_pages) {
 		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found, %lu non-UXN pages found\n",
 			st.wx_pages, st.uxn_pages);
-	else
+
+		return false;
+	} else {
 		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
+
+		return true;
+	}
 }
 
 static int __init ptdump_init(void)
--- a/arch/powerpc/mm/ptdump/ptdump.c~mm-ptdump-have-ptdump_check_wx-return-bool
+++ a/arch/powerpc/mm/ptdump/ptdump.c
@@ -327,7 +327,7 @@ static void __init build_pgtable_complet
 				pg_level[i].mask |= pg_level[i].flag[j].mask;
 }
 
-void ptdump_check_wx(void)
+bool ptdump_check_wx(void)
 {
 	struct pg_state st = {
 		.seq = NULL,
@@ -344,15 +344,20 @@ void ptdump_check_wx(void)
 	};
 
 	if (IS_ENABLED(CONFIG_PPC_BOOK3S_64) && !mmu_has_feature(MMU_FTR_KERNEL_RO))
-		return;
+		return true;
 
 	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
 
-	if (st.wx_pages)
+	if (st.wx_pages) {
 		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found\n",
 			st.wx_pages);
-	else
+
+		return false;
+	} else {
 		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
+
+		return true;
+	}
 }
 
 static int __init ptdump_init(void)
--- a/arch/riscv/mm/ptdump.c~mm-ptdump-have-ptdump_check_wx-return-bool
+++ a/arch/riscv/mm/ptdump.c
@@ -335,7 +335,7 @@ static void ptdump_walk(struct seq_file
 	ptdump_walk_pgd(&st.ptdump, pinfo->mm, NULL);
 }
 
-void ptdump_check_wx(void)
+bool ptdump_check_wx(void)
 {
 	struct pg_state st = {
 		.seq = NULL,
@@ -356,11 +356,16 @@ void ptdump_check_wx(void)
 
 	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
 
-	if (st.wx_pages)
+	if (st.wx_pages) {
 		pr_warn("Checked W+X mappings: failed, %lu W+X pages found\n",
 			st.wx_pages);
-	else
+
+		return false;
+	} else {
 		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
+
+		return true;
+	}
 }
 
 static int ptdump_show(struct seq_file *m, void *v)
--- a/arch/s390/mm/dump_pagetables.c~mm-ptdump-have-ptdump_check_wx-return-bool
+++ a/arch/s390/mm/dump_pagetables.c
@@ -192,7 +192,7 @@ static void note_page(struct ptdump_stat
 	}
 }
 
-void ptdump_check_wx(void)
+bool ptdump_check_wx(void)
 {
 	struct pg_state st = {
 		.ptdump = {
@@ -215,14 +215,19 @@ void ptdump_check_wx(void)
 	};
 
 	if (!MACHINE_HAS_NX)
-		return;
+		return true;
 	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
-	if (st.wx_pages)
+	if (st.wx_pages) {
 		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found\n", st.wx_pages);
-	else
+
+		return false;
+	} else {
 		pr_info("Checked W+X mappings: passed, no %sW+X pages found\n",
 			(nospec_uses_trampoline() || !static_key_enabled(&cpu_has_bear)) ?
 			"unexpected " : "");
+
+		return true;
+	}
 }
 
 #ifdef CONFIG_PTDUMP_DEBUGFS
--- a/arch/x86/include/asm/pgtable.h~mm-ptdump-have-ptdump_check_wx-return-bool
+++ a/arch/x86/include/asm/pgtable.h
@@ -31,7 +31,7 @@ struct seq_file;
 void ptdump_walk_pgd_level(struct seq_file *m, struct mm_struct *mm);
 void ptdump_walk_pgd_level_debugfs(struct seq_file *m, struct mm_struct *mm,
 				   bool user);
-void ptdump_walk_pgd_level_checkwx(void);
+bool ptdump_walk_pgd_level_checkwx(void);
 #define ptdump_check_wx ptdump_walk_pgd_level_checkwx
 void ptdump_walk_user_pgd_level_checkwx(void);
 
--- a/arch/x86/mm/dump_pagetables.c~mm-ptdump-have-ptdump_check_wx-return-bool
+++ a/arch/x86/mm/dump_pagetables.c
@@ -362,9 +362,9 @@ static void note_page(struct ptdump_stat
 	}
 }
 
-static void ptdump_walk_pgd_level_core(struct seq_file *m,
-				       struct mm_struct *mm, pgd_t *pgd,
-				       bool checkwx, bool dmesg)
+bool ptdump_walk_pgd_level_core(struct seq_file *m,
+				struct mm_struct *mm, pgd_t *pgd,
+				bool checkwx, bool dmesg)
 {
 	const struct ptdump_range ptdump_ranges[] = {
 #ifdef CONFIG_X86_64
@@ -391,12 +391,17 @@ static void ptdump_walk_pgd_level_core(s
 	ptdump_walk_pgd(&st.ptdump, mm, pgd);
 
 	if (!checkwx)
-		return;
-	if (st.wx_pages)
+		return true;
+	if (st.wx_pages) {
 		pr_info("x86/mm: Checked W+X mappings: FAILED, %lu W+X pages found.\n",
 			st.wx_pages);
-	else
+
+		return false;
+	} else {
 		pr_info("x86/mm: Checked W+X mappings: passed, no W+X pages found.\n");
+
+		return true;
+	}
 }
 
 void ptdump_walk_pgd_level(struct seq_file *m, struct mm_struct *mm)
@@ -431,12 +436,12 @@ void ptdump_walk_user_pgd_level_checkwx(
 #endif
 }
 
-void ptdump_walk_pgd_level_checkwx(void)
+bool ptdump_walk_pgd_level_checkwx(void)
 {
 	if (!(__supported_pte_mask & _PAGE_NX))
-		return;
+		return true;
 
-	ptdump_walk_pgd_level_core(NULL, &init_mm, INIT_PGD, true, false);
+	return ptdump_walk_pgd_level_core(NULL, &init_mm, INIT_PGD, true, false);
 }
 
 static int __init pt_dump_init(void)
--- a/include/linux/ptdump.h~mm-ptdump-have-ptdump_check_wx-return-bool
+++ a/include/linux/ptdump.h
@@ -18,8 +18,11 @@ struct ptdump_state {
 	const struct ptdump_range *range;
 };
 
+bool ptdump_walk_pgd_level_core(struct seq_file *m,
+				struct mm_struct *mm, pgd_t *pgd,
+				bool checkwx, bool dmesg);
 void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd);
-void ptdump_check_wx(void);
+bool ptdump_check_wx(void);
 
 static inline void debug_checkwx(void)
 {
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


