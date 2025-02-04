Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C9825A642
	for <mm-commits@vger.kernel.org>; Tue,  4 Feb 2025 00:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738630542; cv=none; b=qJkgzHdRzNnmCDLssUWulbR74tNOFbRiya4V3W4WS8y7YCVK2yxc139XcuTvGCuodsLe1gnOlgjUF2yypQvIBf/btihWcu+aBWrfl74okWvkCiPIJaV+icjt8y4LE6kE+AAuqFYBSOi5NEKDA234QEVOA/urkGA3KX/EqG48bOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738630542; c=relaxed/simple;
	bh=BJR96WeL76Tj13QlDnI8mDFTy4IvVfpRGfLSlkpX5H0=;
	h=Date:To:From:Subject:Message-Id; b=WnX5bzYz4XPBWZpc34jUc/Z+ybtMfwqq7+KAeiMI/Y0vmd0nga+4hTVG8XuVrq6wjBf9doy97NMxSYeaNnOxNDfniB2usPFtUxJ3XYlXiEsojBqlAQDM6A6tuH2R3NC9Y/Tl7cwdvJUwr0NxHqBZVN73I5ddWwemRlEPmiqwKL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tvX+b542; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tvX+b542"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077FCC4CEE0;
	Tue,  4 Feb 2025 00:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738630541;
	bh=BJR96WeL76Tj13QlDnI8mDFTy4IvVfpRGfLSlkpX5H0=;
	h=Date:To:From:Subject:From;
	b=tvX+b5420ZF4XeTkZXbSf/L5qRoZpkYLvDToDH8vctC8XBMfspixqfVHl+I6fxTn/
	 lY9Q5RLjXNtKcjAqREAiQWnyW2zhbKkbyxGpKx0f+258AThvQrClbXHjf9/ml9y4da
	 NByOW2pY4b/ibW+87yIxOScwCVbeB1uyMc6lJpi4=
Date: Mon, 03 Feb 2025 16:55:40 -0800
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-initialize-elf-lowest-address-to-ulong_max.patch added to mm-nonmm-unstable branch
Message-Id: <20250204005541.077FCC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: initialize ELF lowest address to ULONG_MAX
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-initialize-elf-lowest-address-to-ulong_max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-initialize-elf-lowest-address-to-ulong_max.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: kexec: initialize ELF lowest address to ULONG_MAX
Date: Fri, 31 Jan 2025 17:08:24 +0530

Patch series "powerpc/crash: use generic crashkernel reservation", v3.

Commit 0ab97169aa05 ("crash_core: add generic function to do reservation")
added a generic function to reserve crashkernel memory.  So let's use the
same function on powerpc and remove the architecture-specific code that
essentially does the same thing.

The generic crashkernel reservation also provides a way to split the
crashkernel reservation into high and low memory reservations, which can
be enabled for powerpc in the future.

Additionally move powerpc to use generic APIs to locate memory hole for
kexec segments while loading kdump kernel.


This patch (of 7):

kexec_elf_load() loads an ELF executable and sets the address of the
lowest PT_LOAD section to the address held by the lowest_load_addr
function argument.

To determine the lowest PT_LOAD address, a local variable lowest_addr
(type unsigned long) is initialized to UINT_MAX.  After loading each
PT_LOAD, its address is compared to lowest_addr.  If a loaded PT_LOAD
address is lower, lowest_addr is updated.  However, setting lowest_addr to
UINT_MAX won't work when the kernel image is loaded above 4G, as the
returned lowest PT_LOAD address would be invalid.  This is resolved by
initializing lowest_addr to ULONG_MAX instead.

This issue was discovered while implementing crashkernel high/low
reservation on the PowerPC architecture.

Link: https://lkml.kernel.org/r/20250131113830.925179-1-sourabhjain@linux.ibm.com
Link: https://lkml.kernel.org/r/20250131113830.925179-2-sourabhjain@linux.ibm.com
Fixes: a0458284f062 ("powerpc: Add support code for kexec_file_load()")
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_elf.c~kexec-initialize-elf-lowest-address-to-ulong_max
+++ a/kernel/kexec_elf.c
@@ -390,7 +390,7 @@ int kexec_elf_load(struct kimage *image,
 			 struct kexec_buf *kbuf,
 			 unsigned long *lowest_load_addr)
 {
-	unsigned long lowest_addr = UINT_MAX;
+	unsigned long lowest_addr = ULONG_MAX;
 	int ret;
 	size_t i;
 
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are

kexec-initialize-elf-lowest-address-to-ulong_max.patch
crash-remove-an-unused-argument-from-reserve_crashkernel_generic.patch
crash-let-arch-decide-usable-memory-range-in-reserved-area.patch
powerpc-crash-use-generic-apis-to-locate-memory-hole-for-kdump.patch
powerpc-crash-preserve-user-specified-memory-limit.patch
powerpc-insert-system-ram-resource-to-prevent-crashkernel-conflict.patch
powerpc-crash-use-generic-crashkernel-reservation.patch

