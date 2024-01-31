Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335922E647
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 06:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706683042; cv=none; b=tosSe/XfirJa8ZYQ5ngb1BgG5H3ZrNVHOhKYCnamS9R3w/797Ex3oLnOv8KAs/edPdVMrZ+HUQ2RW8b3HZYYXtzwnKAmS7008fhjjOeBr8kj3QLkx4M89Bc4aa3eIO6NffaC9/6XEFOuhwpJcQQUdWORG2pWBBQNstKaEsn1F6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706683042; c=relaxed/simple;
	bh=+Sbwp/qemtabOTQNr5Tif6Y1zH/ApV9jSyshIYHxGlk=;
	h=Date:To:From:Subject:Message-Id; b=Kbp96sGsvv1bTeIjn+QANAVS31fFkvbv6g66dnoEXqZMrXSKlKoNScr7txQFQUyg6zY49S9O6ZPFOnRtOJipp0BVRFuK6A8NAhEGRI2oLgL67pluJCw4E3BlEsncjv+5NU1BnMP3y9bsRztpBTZ4IKhRHcZsJ1BDx5uR1yN/zW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wpSj8Pdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wpSj8Pdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA9BC433F1;
	Wed, 31 Jan 2024 06:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706683041;
	bh=+Sbwp/qemtabOTQNr5Tif6Y1zH/ApV9jSyshIYHxGlk=;
	h=Date:To:From:Subject:From;
	b=wpSj8PdjC11+N0BBVtd3GrDPU1SogAw0ev5iuadLP5xC3ewpJi9JAjbbHcuZ202x3
	 Unr/H+A8QyLNkruPRhLGWLIWJsim/nfBTKNBUhF6KU3Z5cGw1wUzN8ku4TnEN8nOBy
	 1WA1YZFOq5KJ6agfZCEBUnL+93/NrjC5Akk9WlYc=
Date: Tue, 30 Jan 2024 22:37:07 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tranmanphong@gmail.com,tglx@linutronix.de,svens@linux.ibm.com,steven.price@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,hpa@zytor.com,hca@linux.ibm.com,greg@kroah.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ptdump-have-ptdump_check_wx-return-bool.patch added to mm-unstable branch
Message-Id: <20240131063719.BCA9BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: ptdump: have ptdump_check_wx() return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ptdump-have-ptdump_check_wx-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ptdump-have-ptdump_check_wx-return-bool.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: ptdump: have ptdump_check_wx() return bool
Date: Tue, 30 Jan 2024 11:34:35 +0100

Have ptdump_check_wx() return true when the check is successful or false
otherwise.

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
 arch/x86/mm/dump_pagetables.c   |   19 ++++++++++++-------
 include/linux/ptdump.h          |    2 +-
 7 files changed, 48 insertions(+), 23 deletions(-)

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
@@ -362,7 +362,7 @@ static void note_page(struct ptdump_stat
 	}
 }
 
-static void ptdump_walk_pgd_level_core(struct seq_file *m,
+bool void ptdump_walk_pgd_level_core(struct seq_file *m,
 				       struct mm_struct *mm, pgd_t *pgd,
 				       bool checkwx, bool dmesg)
 {
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
@@ -19,7 +19,7 @@ struct ptdump_state {
 };
 
 void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd);
-void ptdump_check_wx(void);
+bool ptdump_check_wx(void);
 
 static inline void debug_checkwx(void)
 {
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

arm-ptdump-rename-config_debug_wx-to-config_arm_debug_wx.patch
arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx.patch
powerpcs390-ptdump-define-ptdump_check_wx-regardless-of-config_debug_wx.patch
mm-ptdump-have-ptdump_check_wx-return-bool.patch
mm-ptdump-add-check_wx_pages-debugfs-attribute.patch

