Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A6B29CFB
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246984; cv=none; b=UQTCwln9uqSJoQ55hQa5FP384NyC9EnxEHg5Ad+Lfn/l09i4tTV3SXb2diQaVCc0nox2MewjNt33HPYv0kD4jxTYXg0oS7OUTEQG19X2h3hdOpvQWQ4Yl+85jxyrMFPbi41TCZl2TwW/Py+E1P1gRq5RZAPPKlOroXGcz20ucyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246984; c=relaxed/simple;
	bh=7IIYwokxku1yEd6LfdgZXA81+cuOLCSxR2IV6oLnJnU=;
	h=Date:To:From:Subject:Message-Id; b=fDBpc9bA2oRu/dHZED5+jxTRwo1iSV/1kDs1QnAQN+jmyMtj0MHueRvQBc+XupImYPwrZZpopHclvIw/yB1JJKjiQIsPK6xsjQko9WD1UrFJM4v0vogeXzZhPQeD2H3STymSGfthkZOEP5AEYme/6DC6gnKfxJMveoDHL9DQKYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a33TT+Za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a33TT+Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3100C4CEC3;
	Mon,  2 Sep 2024 03:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246984;
	bh=7IIYwokxku1yEd6LfdgZXA81+cuOLCSxR2IV6oLnJnU=;
	h=Date:To:From:Subject:From;
	b=a33TT+ZaqMJeOMu+h0IZ+h+W5WgZI0gaOHPB7gOS0vrBVx4d8YrFVKoY4vnCZ+LEO
	 hxU1pQo4JFK18+ruExBFdG+j+ouTG2wE3J93m54byVzPKwy7ElCXw0pJISzlB/1f95
	 30AM5LJlwEbCXhX5UMw1VuGKKiXceSt6v27duHAw=
Date: Sun, 01 Sep 2024 20:16:23 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,torvalds@linux-foundation.org,rob@landley.net,richard@nod.at,pedro.falcato@gmail.com,npiggin@gmail.com,nathan@kernel.org,mpe@ellerman.id.au,Liam.Howlett@oracle.com,johannes@sipsolutions.net,jeffxu@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,dinguyen@kernel.org,dalias@libc.org,christophe.leroy@csgroup.eu,bcain@quicinc.com,anton.ivanov@cambridgegreys.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20240902031623.E3100C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-remove-legacy-install_special_mapping-code-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-remove-legacy-install_special_mapping-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-legacy-install_special_mapping-code-checkpatch-fixes
Date: Tue Aug 20 06:23:03 PM PDT 2024

WARNING: nested (un)?likely() calls, IS_ERR already uses unlikely() internally
#83: FILE: arch/csky/kernel/vdso.c:81:
+	if (unlikely(IS_ERR(vma))) {

WARNING: nested (un)?likely() calls, IS_ERR already uses unlikely() internally
#97: FILE: arch/csky/kernel/vdso.c:92:
+	if (unlikely(IS_ERR(vma))) {

WARNING: nested (un)?likely() calls, IS_ERR already uses unlikely() internally
#213: FILE: arch/sh/kernel/vsyscall/vsyscall.c:84:
+	if (unlikely(IS_ERR(vma)))

total: 0 errors, 3 warnings, 249 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-remove-legacy-install_special_mapping-code.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Rob Landley <rob@landley.net>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/kernel/vdso.c            |    4 ++--
 arch/sh/kernel/vsyscall/vsyscall.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/csky/kernel/vdso.c~mm-remove-legacy-install_special_mapping-code-checkpatch-fixes
+++ a/arch/csky/kernel/vdso.c
@@ -78,7 +78,7 @@ int arch_setup_additional_pages(struct l
 		(VM_READ | VM_EXEC | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC),
 		&vdso_mapping);
 
-	if (unlikely(IS_ERR(vma))) {
+	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		mm->context.vdso = NULL;
 		goto end;
@@ -89,7 +89,7 @@ int arch_setup_additional_pages(struct l
 	vma = _install_special_mapping(mm, vdso_base, PAGE_SIZE,
 		(VM_READ | VM_MAYREAD), &vvar_mapping);
 
-	if (unlikely(IS_ERR(vma))) {
+	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		mm->context.vdso = NULL;
 		goto end;
--- a/arch/sh/kernel/vsyscall/vsyscall.c~mm-remove-legacy-install_special_mapping-code-checkpatch-fixes
+++ a/arch/sh/kernel/vsyscall/vsyscall.c
@@ -81,7 +81,7 @@ int arch_setup_additional_pages(struct l
 				      VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC,
 				      &vdso_mapping);
 	ret = PTR_ERR(vma);
-	if (unlikely(IS_ERR(vma)))
+	if (IS_ERR(vma))
 		goto up_fail;
 
 	current->mm->context.vdso = (void *)addr;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code.patch
mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
lib-maple_treec-remove-unused-functions.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

