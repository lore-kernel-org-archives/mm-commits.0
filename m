Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B10C4687
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 01:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724203591; cv=none; b=rF00HfcwIznbAmHSBX4vAM34arIsdfBi9VVgwfYMfevSLpEmF/EFHrOG6hzJHd00YJY1JAKkpnX2C4CEdVPczH7xTBUwmkH6zN7N9sk87vtE10WX7GwD4NJDDyN/8+ePPsw4nZ2phMoR63LZgV+Nkh4tVXFVg8KT7J7G1SYq4Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724203591; c=relaxed/simple;
	bh=VZdvMB6niqlyJ0WomhmxzPqsZNB5f36JMQsXmG7Aq4s=;
	h=Date:To:From:Subject:Message-Id; b=cH2REV9qJvQqvfbO4Jq1H/NxvAVr1R7fVQIfUAJJpSbAWqCMs/tWGwmNerGCnCBTjtzIjqhRSy7fzphQfrfNVYyfsjwnh2B5GMRw0yqh9uL8jTnYr7Eo5wAyL0Q2t36HUmI0w1A4y6OzLWz4/NTRqHdBguvk8zXJHNaCTB3ftl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GR02K7K7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GR02K7K7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DA0C4AF0F;
	Wed, 21 Aug 2024 01:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724203590;
	bh=VZdvMB6niqlyJ0WomhmxzPqsZNB5f36JMQsXmG7Aq4s=;
	h=Date:To:From:Subject:From;
	b=GR02K7K7ov6B7crHL99TSgPH2ZCOvC01QLEOEUvdaWK9QnU+1KkSqf8H5slEiLosY
	 qfd6nuHYIOjyp8Ofy6QJlrV5cNMCR883zuFH/DcykuNJcuSkuGeClK4PzO2n+D7lFp
	 2o4UAIyYGPT4kbd5I/M/mctz9nu0/1pJMuLpdlT8=
Date: Tue, 20 Aug 2024 18:26:30 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,torvalds@linux-foundation.org,rob@landley.net,richard@nod.at,pedro.falcato@gmail.com,npiggin@gmail.com,nathan@kernel.org,mpe@ellerman.id.au,Liam.Howlett@oracle.com,johannes@sipsolutions.net,jeffxu@google.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,dinguyen@kernel.org,dalias@libc.org,christophe.leroy@csgroup.eu,bcain@quicinc.com,anton.ivanov@cambridgegreys.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20240821012630.90DA0C4AF0F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-remove-legacy-install_special_mapping-code-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch

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
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

