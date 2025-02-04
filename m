Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A9E1F949
	for <mm-commits@vger.kernel.org>; Tue,  4 Feb 2025 00:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738630552; cv=none; b=PtRyvbgq1f3el70dU4r7D4k76/7bJ3EFpi/ZY/kf8bT2ydFg1cjuU/4Jz9zK7Dqm3S3MW1EgAs1dKwkL4cb/+TmFSd5foKqRzrnF+i3f6kTpvrJ/iqweQdVNSUZWWyHTJjneJoZnuFuv6AvZLxZA9sWRaJkBIzq4B91qc3TDWPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738630552; c=relaxed/simple;
	bh=C9O/0mrr/AgUXrrYaKHk4myUhDtq5i7Nne5FufoeyJs=;
	h=Date:To:From:Subject:Message-Id; b=YoOJU+3vMskK0wqHdrLrwfZ/foAv3zck8Uey/ad2kt+upAW4buwnqBz7ut1dO9WPIEgGT0xeHV5d6cemBlyZS1Z3qGXbQr8zD/yvp4VHyXELKT086miumpzoJPuCxbZYufDUoX5GI0JcrB05A/bZcTAjrITHCA+W9zV6lpMVf2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LQbrijAk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LQbrijAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E496AC4CEE0;
	Tue,  4 Feb 2025 00:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738630552;
	bh=C9O/0mrr/AgUXrrYaKHk4myUhDtq5i7Nne5FufoeyJs=;
	h=Date:To:From:Subject:From;
	b=LQbrijAkRBfXi60iAVSLToEOXpvukfb5y+bhxlcVh5H/pOYIklSWUxfxguBbwsxgE
	 nGOtVcjB1Nh3KG+9oHqAemHBvD3njE8pZe/7uyZc/DpYz/eqhtjfZBlQYtQv3sYhmm
	 pfh6ZmfWjqmMniFekrj9WSiK3gebQJmeJZZI5D60=
Date: Mon, 03 Feb 2025 16:55:51 -0800
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-crash-preserve-user-specified-memory-limit.patch added to mm-nonmm-unstable branch
Message-Id: <20250204005551.E496AC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/crash: preserve user-specified memory limit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     powerpc-crash-preserve-user-specified-memory-limit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-crash-preserve-user-specified-memory-limit.patch

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
Subject: powerpc/crash: preserve user-specified memory limit
Date: Fri, 31 Jan 2025 17:08:28 +0530

Commit 59d58189f3d9 ("crash: fix crash memory reserve exceed system memory
bug") fails crashkernel parsing if the crash size is found to be higher
than system RAM, which makes the memory_limit adjustment code ineffective
due to an early exit from reserve_crashkernel().

Regardless lets not violate the user-specified memory limit by adjusting
it.  Remove this adjustment to ensure all reservations stay within the
limit.  Commit f94f5ac07983 ("powerpc/fadump: Don't update the
user-specified memory limit") did the same for fadump.

Link: https://lkml.kernel.org/r/20250131113830.925179-6-sourabhjain@linux.ibm.com
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kexec/core.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/powerpc/kexec/core.c~powerpc-crash-preserve-user-specified-memory-limit
+++ a/arch/powerpc/kexec/core.c
@@ -128,14 +128,6 @@ void __init reserve_crashkernel(void)
 		return;
 	}
 
-	/* Crash kernel trumps memory limit */
-	if (memory_limit && memory_limit <= crashk_res.end) {
-		memory_limit = crashk_res.end + 1;
-		total_mem_sz = memory_limit;
-		printk("Adjusted memory limit for crashkernel, now 0x%llx\n",
-		       memory_limit);
-	}
-
 	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
 			"for crashkernel (System RAM: %ldMB)\n",
 			(unsigned long)(crash_size >> 20),
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are

kexec-initialize-elf-lowest-address-to-ulong_max.patch
crash-remove-an-unused-argument-from-reserve_crashkernel_generic.patch
crash-let-arch-decide-usable-memory-range-in-reserved-area.patch
powerpc-crash-use-generic-apis-to-locate-memory-hole-for-kdump.patch
powerpc-crash-preserve-user-specified-memory-limit.patch
powerpc-insert-system-ram-resource-to-prevent-crashkernel-conflict.patch
powerpc-crash-use-generic-crashkernel-reservation.patch

