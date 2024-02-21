Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F61EC5
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559092; cv=none; b=H6arw0z8SEzSDshv46Tu3tT3BKwbdRFvBsIiga6eXX9ypgHgbb9BIa/44PlgcrkPpWGuzj9qvSwkh46FPPHJu9TuOCaXKyf7N74tDkRtCFS4X9+T3eJ7MDEPo9OtU9YknP8vs4T1aqNsS6LV9BevLnHfAYr+Wb09GUoifA0mZ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559092; c=relaxed/simple;
	bh=rbjyLCnDMNxFAejbILWfSFY2VJfk0kb7XFuWMAF44pI=;
	h=Date:To:From:Subject:Message-Id; b=FhH+Q0jZN7ah77vsAeidCwphtE+kOwmFFmUvl/v7qc6DRaYsU6qXskBWPH6+qfUViswSW7u82gKFhartcu/oCuQA2i0eko1CORQxRNnwWlYD5RVb9OKvvxy3DCDBPy7ftdZOYM8cthwrw3iP+FfBAZgts8cFFh1UYAZNYTS1Opk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=axviFEqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="axviFEqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE92C433F1;
	Wed, 21 Feb 2024 23:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708559091;
	bh=rbjyLCnDMNxFAejbILWfSFY2VJfk0kb7XFuWMAF44pI=;
	h=Date:To:From:Subject:From;
	b=axviFEqEBqf7Yb9zMFTcEqLHIcBWNdrkc3y//gxOf3RjqUFcZrw+2RR28V3PP4O1g
	 mA/RSt/pAduHh1U0QQPcMzGQL6QkT7jzURPXc3EP71W1RyGWS0/4q+ZSj/zFoTlIw7
	 ZzuOSaYuOLET8uAeyCThXw+Cpf3FBf0reEAa4L/c=
Date: Wed, 21 Feb 2024 15:44:51 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tranmanphong@gmail.com,tglx@linutronix.de,svens@linux.ibm.com,steven.price@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,hpa@zytor.com,hca@linux.ibm.com,greg@kroah.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch removed from -mm tree
Message-Id: <20240221234451.9FE92C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-ptdump-have-ptdump_check_wx-return-bool-fix
has been removed from the -mm tree.  Its filename was
     mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch

This patch was dropped because it was folded into mm-ptdump-have-ptdump_check_wx-return-bool.patch

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

mm-ptdump-have-ptdump_check_wx-return-bool.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

