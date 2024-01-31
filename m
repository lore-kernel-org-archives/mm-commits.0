Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A5421341
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 06:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706683026; cv=none; b=BdvNMpqNH9uRtbpdcKW1WOaefzie3DGYkHUU3dR1EC7e06aQiHY8DvBNHFNaVs3dDIR6NkF2KzQYtDIylFl3BKwBkBnz++TGLSJOliADSWcGZqNMatKY0o1ILKHEKuWNk1xYhSht2KiB1A1kns94erQC6Zr5SA9fhs/80CkVjmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706683026; c=relaxed/simple;
	bh=H90GyVJoUN/6DTewREsFXzOSP4zBx18JRUfM6TA61vM=;
	h=Date:To:From:Subject:Message-Id; b=kRpYz2WolNbs/lsLG3CbBvAmjX3xZod6Uf5k+qFGnzj30DYmlE0/CpGtFlDV2fiNDUihJhXHGTjjLVWRymV8OQtsO+VUWBe0DkWw4M72WVTv6Inxb3AszRpy90OXmvfaCDQeD6GKSLPDriFE6PZHPwUrQWfzElMA87hKx+/C4DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F0vMkzPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F0vMkzPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84259C433C7;
	Wed, 31 Jan 2024 06:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706683026;
	bh=H90GyVJoUN/6DTewREsFXzOSP4zBx18JRUfM6TA61vM=;
	h=Date:To:From:Subject:From;
	b=F0vMkzPwdv5T/M/uKZ7C2DL40DvRIzMoVIUBkE4yHsEXJRV36j+MVAIpwzW4Jkazb
	 z0Py8vdFBg1Zyp8tbZ+NGTWHWo1JgFwETrmr3cEhN66X1h7W0Lpn4T4VUI9gPPchyh
	 3pbpf5K1FFhlBkJp0Mqhk2J2cOncVxMveHjE0Q0M=
Date: Tue, 30 Jan 2024 22:36:51 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tranmanphong@gmail.com,tglx@linutronix.de,svens@linux.ibm.com,steven.price@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,hpa@zytor.com,hca@linux.ibm.com,greg@kroah.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpcs390-ptdump-define-ptdump_check_wx-regardless-of-config_debug_wx.patch added to mm-unstable branch
Message-Id: <20240131063703.84259C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc,s390: ptdump: define ptdump_check_wx() regardless of CONFIG_DEBUG_WX
has been added to the -mm mm-unstable branch.  Its filename is
     powerpcs390-ptdump-define-ptdump_check_wx-regardless-of-config_debug_wx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpcs390-ptdump-define-ptdump_check_wx-regardless-of-config_debug_wx.patch

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
Subject: powerpc,s390: ptdump: define ptdump_check_wx() regardless of CONFIG_DEBUG_WX
Date: Tue, 30 Jan 2024 11:34:34 +0100

Following patch will use ptdump_check_wx() regardless of CONFIG_DEBUG_WX,
so define it at all times on powerpc and s390 just like other
architectures.  Though keep the WARN_ON_ONCE() only when CONFIG_DEBUG_WX
is set.

Link: https://lkml.kernel.org/r/07bfb04c7fec58e84413e91d2533581be357a696.1706610398.git.christophe.leroy@csgroup.eu
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

 arch/powerpc/mm/ptdump/ptdump.c |    7 +++----
 arch/s390/mm/dump_pagetables.c  |    7 ++-----
 2 files changed, 5 insertions(+), 9 deletions(-)

--- a/arch/powerpc/mm/ptdump/ptdump.c~powerpcs390-ptdump-define-ptdump_check_wx-regardless-of-config_debug_wx
+++ a/arch/powerpc/mm/ptdump/ptdump.c
@@ -184,13 +184,14 @@ static void note_prot_wx(struct pg_state
 {
 	pte_t pte = __pte(st->current_flags);
 
-	if (!IS_ENABLED(CONFIG_DEBUG_WX) || !st->check_wx)
+	if (!st->check_wx)
 		return;
 
 	if (!pte_write(pte) || !pte_exec(pte))
 		return;
 
-	WARN_ONCE(1, "powerpc/mm: Found insecure W+X mapping at address %p/%pS\n",
+	WARN_ONCE(IS_ENABLED(CONFIG_DEBUG_WX),
+		  "powerpc/mm: Found insecure W+X mapping at address %p/%pS\n",
 		  (void *)st->start_address, (void *)st->start_address);
 
 	st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
@@ -326,7 +327,6 @@ static void __init build_pgtable_complet
 				pg_level[i].mask |= pg_level[i].flag[j].mask;
 }
 
-#ifdef CONFIG_DEBUG_WX
 void ptdump_check_wx(void)
 {
 	struct pg_state st = {
@@ -354,7 +354,6 @@ void ptdump_check_wx(void)
 	else
 		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
 }
-#endif
 
 static int __init ptdump_init(void)
 {
--- a/arch/s390/mm/dump_pagetables.c~powerpcs390-ptdump-define-ptdump_check_wx-regardless-of-config_debug_wx
+++ a/arch/s390/mm/dump_pagetables.c
@@ -121,7 +121,6 @@ static void print_prot(struct seq_file *
 
 static void note_prot_wx(struct pg_state *st, unsigned long addr)
 {
-#ifdef CONFIG_DEBUG_WX
 	if (!st->check_wx)
 		return;
 	if (st->current_prot & _PAGE_INVALID)
@@ -138,10 +137,10 @@ static void note_prot_wx(struct pg_state
 	 */
 	if (addr == PAGE_SIZE && (nospec_uses_trampoline() || !static_key_enabled(&cpu_has_bear)))
 		return;
-	WARN_ONCE(1, "s390/mm: Found insecure W+X mapping at address %pS\n",
+	WARN_ONCE(IS_ENABLED(CONFIG_DEBUG_WX),
+		  "s390/mm: Found insecure W+X mapping at address %pS\n",
 		  (void *)st->start_address);
 	st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
-#endif /* CONFIG_DEBUG_WX */
 }
 
 static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level, u64 val)
@@ -193,7 +192,6 @@ static void note_page(struct ptdump_stat
 	}
 }
 
-#ifdef CONFIG_DEBUG_WX
 void ptdump_check_wx(void)
 {
 	struct pg_state st = {
@@ -226,7 +224,6 @@ void ptdump_check_wx(void)
 			(nospec_uses_trampoline() || !static_key_enabled(&cpu_has_bear)) ?
 			"unexpected " : "");
 }
-#endif /* CONFIG_DEBUG_WX */
 
 #ifdef CONFIG_PTDUMP_DEBUGFS
 static int ptdump_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

arm-ptdump-rename-config_debug_wx-to-config_arm_debug_wx.patch
arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx.patch
powerpcs390-ptdump-define-ptdump_check_wx-regardless-of-config_debug_wx.patch
mm-ptdump-have-ptdump_check_wx-return-bool.patch
mm-ptdump-add-check_wx_pages-debugfs-attribute.patch

