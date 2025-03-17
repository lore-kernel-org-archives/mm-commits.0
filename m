Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AF6140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189492; cv=none; b=iJt+ggYReGG1T0Gjbh81sGjXtn73OyjDKh98OrNtldE35PuGX5dRu0olhtVpB/0c1soeM5gd/Kov2QQLz6Cj/oojbKrDOV2m0jijUaTBiH1B31l1crgJFQZeMDCaaC6zXwoqHOxJxs5aPDJIJDP1+MAyEjoBdk5vyQDbVPtchd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189492; c=relaxed/simple;
	bh=S8u0Y10MbJ88CkprnFteoUM59/Uq9BxkeElBWGd0nto=;
	h=Date:To:From:Subject:Message-Id; b=D5hIGMQO3tW+4PHZai/OhO+1bX4qRkYomNNFbWdgY1cbWNCV7tvf5MWtlEMtbgBI9T0wdc/KW05L5nq3YMRRumvh2TeI/zPXOr+RpUS3zINZsGJz/YTJEqJrFFoVYQ7fy68V807vujUOKUdHNkGY3bNwotqWpaLHGx34wLh16gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OrM6etDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OrM6etDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30918C4CEEC;
	Mon, 17 Mar 2025 05:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189492;
	bh=S8u0Y10MbJ88CkprnFteoUM59/Uq9BxkeElBWGd0nto=;
	h=Date:To:From:Subject:From;
	b=OrM6etDMdD74hvVgsbl91n/sWn15WuCYzckH3Ie73QZA+4Vw4h9GPsUYeFGAGZBdD
	 D9NVX8vk2jitMpcXvFzuEPB1A6Ny6syNNGMXMRbIn/qHGTmv1GHelQKHHj4/7wbGYV
	 6u4Yb/JZ4gSbT8hWOIXylcIleLyWJSufe51V8cTM=
Date: Sun, 16 Mar 2025 22:31:31 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-initialize-elf-lowest-address-to-ulong_max.patch removed from -mm tree
Message-Id: <20250317053132.30918C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: initialize ELF lowest address to ULONG_MAX
has been removed from the -mm tree.  Its filename was
     kexec-initialize-elf-lowest-address-to-ulong_max.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


