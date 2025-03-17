Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C853E140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189496; cv=none; b=uCzpUmpC4OKpZzeANT2enmibAG/e18VbywSG8ECeRpJ+KwrSoPO3StcXOmoxDyA9693ox/oNAK6fo/75WEmVf85du8vcJTZ6kGF7IPNUjMfVutS7f3ut8r62kANXwF3TJgdhaxxxn4zoUNznU4tmqLfX1st2JTnekLZBh2clFdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189496; c=relaxed/simple;
	bh=cUYzZ22oLa7j5SdNKcvOg+KqYv7TzwzxnYOePsrCvYI=;
	h=Date:To:From:Subject:Message-Id; b=f3JFvfotyX4KNSL4/6norH8iEKgE0ed+vODp71e7BgsIMHBBJ79wk+0C0uOOg/DW9T7YqFPJkxzm2X4jAKQO7Ym21Xqv/ApaCGUUTPyhlff/6Fji2p9pqivKgvo04ALxa0qYarFzNZ67oZfjmYomTa1STnx7fJQZAVe/8z3Z05M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xiCiAAl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xiCiAAl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3C0C4CEEC;
	Mon, 17 Mar 2025 05:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189496;
	bh=cUYzZ22oLa7j5SdNKcvOg+KqYv7TzwzxnYOePsrCvYI=;
	h=Date:To:From:Subject:From;
	b=xiCiAAl0BcFD8HAdJF/DejYRH7wdg6patDEDixe58adjvb/NrVKZqM+lMj2DJdNVX
	 DcAWzoX9DxijD2M60fFAJOALPlmBP3lVnBLHPL6+vwwcpi4+Xk5iq/daiVWBEU/YZd
	 cUt1rHomuhioYURJoo6NeOwDZhIE45czaSrO/CMw=
Date: Sun, 16 Mar 2025 22:31:36 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] powerpc-crash-preserve-user-specified-memory-limit.patch removed from -mm tree
Message-Id: <20250317053136.9C3C0C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/crash: preserve user-specified memory limit
has been removed from the -mm tree.  Its filename was
     powerpc-crash-preserve-user-specified-memory-limit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


