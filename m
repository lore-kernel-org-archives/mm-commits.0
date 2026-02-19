Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41D8279792
	for <mm-commits@vger.kernel.org>; Thu, 19 Feb 2026 22:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771539528; cv=none; b=Byz87bFzqye7MyDBDheYRMD4Xxl1EvbABQx7GnmFtc9OGL6dCTMUnxOKIjy0TcWflOd7IDfXB+sE/Jfqc7/zEen+KeRm3Dbymbi/IRT/0pysYKcX6jWwCqnV4q8wUg/dpuvAHKycOIoWCtlPnZx5VQ8IFW1ZjLnPGO2grN507XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771539528; c=relaxed/simple;
	bh=U6rwxF/usR1/Nv2w/XN+V4eh5VIjuYHi02rZAnErwuM=;
	h=Date:To:From:Subject:Message-Id; b=RyEk2zDjIsIQJYkjGML5/PLNLF5dyqTYMPpNvBJvH5RC/MyH0UvN93FWhZbX2ULUKXjt1T9TYxPCNfWYXb+4JgBb/+I6DU/ke+htCvaNL9fTFI8I+8NIaxmoj5uiDWVdFQhrdUf5IZo87u6P+ozIfcTwfdTUTs6x1uKb5eF6UEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtRWp9VX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtRWp9VX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E43C4CEF7;
	Thu, 19 Feb 2026 22:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771539528;
	bh=U6rwxF/usR1/Nv2w/XN+V4eh5VIjuYHi02rZAnErwuM=;
	h=Date:To:From:Subject:From;
	b=rtRWp9VXdoUFH2GtdtdyyK5t6nwDrzOPRG3vQd9Uqe9tTJKXJc8rgeewaDa10ZbDG
	 q59LDm0iGXXXE94c/L1T68DINxq22vrSHDfxQeXiyaMhQ3jfN0GcjJB1he3pnI1Ktn
	 8OJm2+vBnQyHNy9BITa8ULY5UPnQK94TAwuyo2FY=
Date: Thu, 19 Feb 2026 14:18:47 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,mpe@ellerman.id.au,mingo@redhat.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,catalin.marinas@arm.com,bp@alien8.de,sgsu.park@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access.patch added to mm-new branch
Message-Id: <20260219221848.62E43C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/pkeys: remove unused tsk parameter from arch_set_user_pkey_access()
has been added to the -mm mm-new branch.  Its filename is
     mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Seongsu Park <sgsu.park@samsung.com>
Subject: mm/pkeys: remove unused tsk parameter from arch_set_user_pkey_access()
Date: Thu, 19 Feb 2026 15:35:06 +0900

The tsk parameter in arch_set_user_pkey_access() is never used in the
function implementations across all architectures (arm64, powerpc, x86).

Link: https://lkml.kernel.org/r/20260219063506.545148-1-sgsu.park@samsung.com
Signed-off-by: Seongsu Park <sgsu.park@samsung.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pkeys.h   |    3 +--
 arch/arm64/mm/mmu.c              |    2 +-
 arch/powerpc/include/asm/pkeys.h |    8 +++-----
 arch/powerpc/mm/book3s64/pkeys.c |    3 +--
 arch/x86/include/asm/pkeys.h     |    3 +--
 arch/x86/kernel/fpu/xstate.c     |    3 +--
 arch/x86/mm/pkeys.c              |    3 +--
 mm/mprotect.c                    |    2 +-
 8 files changed, 10 insertions(+), 17 deletions(-)

--- a/arch/arm64/include/asm/pkeys.h~mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access
+++ a/arch/arm64/include/asm/pkeys.h
@@ -12,8 +12,7 @@
 
 #define arch_max_pkey() 8
 
-int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-		unsigned long init_val);
+int arch_set_user_pkey_access(int pkey, unsigned long init_val);
 
 static inline bool arch_pkeys_enabled(void)
 {
--- a/arch/arm64/mm/mmu.c~mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access
+++ a/arch/arm64/mm/mmu.c
@@ -2206,7 +2206,7 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bo
 }
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
-int arch_set_user_pkey_access(struct task_struct *tsk, int pkey, unsigned long init_val)
+int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
 	u64 new_por;
 	u64 old_por;
--- a/arch/powerpc/include/asm/pkeys.h~mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access
+++ a/arch/powerpc/include/asm/pkeys.h
@@ -143,10 +143,8 @@ static inline int arch_override_mprotect
 	return __arch_override_mprotect_pkey(vma, prot, pkey);
 }
 
-extern int __arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-				       unsigned long init_val);
-static inline int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-					    unsigned long init_val)
+extern int __arch_set_user_pkey_access(int pkey, unsigned long init_val);
+static inline int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
 	if (!mmu_has_feature(MMU_FTR_PKEY))
 		return -EINVAL;
@@ -160,7 +158,7 @@ static inline int arch_set_user_pkey_acc
 	if (pkey == 0)
 		return init_val ? -EINVAL : 0;
 
-	return __arch_set_user_pkey_access(tsk, pkey, init_val);
+	return __arch_set_user_pkey_access(pkey, init_val);
 }
 
 static inline bool arch_pkeys_enabled(void)
--- a/arch/powerpc/mm/book3s64/pkeys.c~mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access
+++ a/arch/powerpc/mm/book3s64/pkeys.c
@@ -335,8 +335,7 @@ static inline void init_iamr(int pkey, u
  * Set the access rights in AMR IAMR and UAMOR registers for @pkey to that
  * specified in @init_val.
  */
-int __arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-				unsigned long init_val)
+int __arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
 	u64 new_amr_bits = 0x0ul;
 	u64 new_iamr_bits = 0x0ul;
--- a/arch/x86/include/asm/pkeys.h~mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access
+++ a/arch/x86/include/asm/pkeys.h
@@ -9,8 +9,7 @@
  */
 #define arch_max_pkey() (cpu_feature_enabled(X86_FEATURE_OSPKE) ? 16 : 1)
 
-extern int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-		unsigned long init_val);
+extern int arch_set_user_pkey_access(int pkey, unsigned long init_val);
 
 static inline bool arch_pkeys_enabled(void)
 {
--- a/arch/x86/kernel/fpu/xstate.c~mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access
+++ a/arch/x86/kernel/fpu/xstate.c
@@ -1080,8 +1080,7 @@ void __user *get_xsave_addr_user(struct
  * This will go out and modify PKRU register to set the access
  * rights for @pkey to @init_val.
  */
-int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-			      unsigned long init_val)
+int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
 	u32 old_pkru, new_pkru_bits = 0;
 	int pkey_shift;
--- a/arch/x86/mm/pkeys.c~mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access
+++ a/arch/x86/mm/pkeys.c
@@ -42,8 +42,7 @@ int __execute_only_pkey(struct mm_struct
 	 * Set up PKRU so that it denies access for everything
 	 * other than execution.
 	 */
-	ret = arch_set_user_pkey_access(current, execute_only_pkey,
-			PKEY_DISABLE_ACCESS);
+	ret = arch_set_user_pkey_access(execute_only_pkey, PKEY_DISABLE_ACCESS);
 	/*
 	 * If the PKRU-set operation failed somehow, just return
 	 * 0 and effectively disable execute-only support.
--- a/mm/mprotect.c~mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access
+++ a/mm/mprotect.c
@@ -978,7 +978,7 @@ SYSCALL_DEFINE2(pkey_alloc, unsigned lon
 	if (pkey == -1)
 		goto out;
 
-	ret = arch_set_user_pkey_access(current, pkey, init_val);
+	ret = arch_set_user_pkey_access(pkey, init_val);
 	if (ret) {
 		mm_pkey_free(current->mm, pkey);
 		goto out;
_

Patches currently in -mm which might be from sgsu.park@samsung.com are

mm-pkeys-remove-unused-tsk-parameter-from-arch_set_user_pkey_access.patch

