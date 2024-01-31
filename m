Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1602766B25
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 09:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706693383; cv=none; b=s6uBlt+SY+DPujBDhbzMwGb8vogg+tKj3C5torohIW4A9CjtcP9ACt8p1ZGIqyXZBSvXz1mXUesCFuUaw/kwPGI1wZEQshiYDjQEwNSun66t19hzSPzQsIiV9v66kKGtucRhuLHMDOjgoq3Br6e0qlCFgKVFlYw/12lZBBjjO4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706693383; c=relaxed/simple;
	bh=GnuFCWB+8QqRIh7iOPCj0ZcvNbu9ToXbz+K8qBSw6Bc=;
	h=Date:To:From:Subject:Message-Id; b=uKfmXfGh0Fojr3hpwvc3S7wZnO4Bajoxt7MDFA+cgejUajSGHF3zlsJGOiW/z2SdV8aKF8FM4qQ0U9/A1piyjnKicS/8XWHGe5R/5Qt7cpR0ZBDwun6TlILfROZFUXekq3Ees98SPM6fSGDZ6pcprHJ6qZhhHuH4iGGeAJB/8kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J7LBpCFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J7LBpCFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F529C433C7;
	Wed, 31 Jan 2024 09:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706693382;
	bh=GnuFCWB+8QqRIh7iOPCj0ZcvNbu9ToXbz+K8qBSw6Bc=;
	h=Date:To:From:Subject:From;
	b=J7LBpCFl5RgevecCE3wxiBvZtzApTzc4wV/7JoWjdOEgG0e3rT7+WQHjBGcPD4aw/
	 FqYUREgdhk9AuHlI8lg9Cyw75EA/mEOMeaEqb70k8pW30FJ16rd2uP0nleSq9aWVQX
	 mUr2xwmdC4US628HWKPxExoF3Q+LltXh3NgS+pSY=
Date: Wed, 31 Jan 2024 01:29:28 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tranmanphong@gmail.com,tglx@linutronix.de,svens@linux.ibm.com,steven.price@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,hpa@zytor.com,hca@linux.ibm.com,greg@kroah.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch added to mm-unstable branch
Message-Id: <20240131092941.3F529C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-ptdump-have-ptdump_check_wx-return-bool-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-ptdump-have-ptdump_check_wx-return-bool-fix
Date: Wed Jan 31 01:13:01 AM PST 2024

fix a couple of build issues (x86_64 allmodconfig)

Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
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

 arch/x86/mm/dump_pagetables.c |    6 +++---
 include/linux/ptdump.h        |    3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/dump_pagetables.c~mm-ptdump-have-ptdump_check_wx-return-bool-fix
+++ a/arch/x86/mm/dump_pagetables.c
@@ -362,9 +362,9 @@ static void note_page(struct ptdump_stat
 	}
 }
 
-bool void ptdump_walk_pgd_level_core(struct seq_file *m,
-				       struct mm_struct *mm, pgd_t *pgd,
-				       bool checkwx, bool dmesg)
+bool ptdump_walk_pgd_level_core(struct seq_file *m,
+				struct mm_struct *mm, pgd_t *pgd,
+				bool checkwx, bool dmesg)
 {
 	const struct ptdump_range ptdump_ranges[] = {
 #ifdef CONFIG_X86_64
--- a/include/linux/ptdump.h~mm-ptdump-have-ptdump_check_wx-return-bool-fix
+++ a/include/linux/ptdump.h
@@ -18,6 +18,9 @@ struct ptdump_state {
 	const struct ptdump_range *range;
 };
 
+bool ptdump_walk_pgd_level_core(struct seq_file *m,
+				struct mm_struct *mm, pgd_t *pgd,
+				bool checkwx, bool dmesg);
 void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd);
 bool ptdump_check_wx(void);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch

