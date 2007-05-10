From: akpm@linux-foundation.org
Subject: - andi-you-broke-my-laptop.patch removed from -mm tree
Date: Thu, 10 May 2007 11:57:38 -0700
Message-ID: <200705101857.l4AIvcfO027728@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754842AbXEJS55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 14:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zaitcev@redhat.com, ak@suse.de, joerg.roedel@amd.com, mm-commits@vger.kernel.org


The patch titled
     Andi, you broke my laptop :-)
has been removed from the -mm tree.  Its filename was
     andi-you-broke-my-laptop.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Andi, you broke my laptop :-)
From: Pete Zaitcev <zaitcev@redhat.com>

The attached patch (actually, git show output) makes my Dell 1501 to hang
on boot. Sorry, I have no clue why... The culprit is found with git bisect.
But yes, it's an AMD MK-36. I use an x86_64 kernel. It is 100% reproducible.

Cheers,
-- Pete

commit c5bcb5635a03da3158f121ae20ccbbf72b4fc62a
Author: Andi Kleen <ak@suse.de>
Date:   Wed May 2 19:27:21 2007 +0200

    [PATCH] x86: Use RDTSCP for synchronous get_cycles if possible

    RDTSCP is already synchronous and doesn't need an explicit CPUID.
    This is a little faster and more importantly avoids VMEXITs on Hypervisors.

    Original patch from Joerg Roedel, but reworked by AK
    Also includes miscompilation fix by Eric Biederman

    Cc: "Joerg Roedel" <joerg.roedel@amd.com>

    Signed-off-by: Andi Kleen <ak@suse.de>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/tsc.h |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN include/asm-i386/tsc.h~andi-you-broke-my-laptop include/asm-i386/tsc.h
--- a/include/asm-i386/tsc.h~andi-you-broke-my-laptop
+++ a/include/asm-i386/tsc.h
@@ -38,15 +38,6 @@ static __always_inline cycles_t get_cycl
 	unsigned eax;
 
 	/*
-  	 * Use RDTSCP if possible; it is guaranteed to be synchronous
- 	 * and doesn't cause a VMEXIT on Hypervisors
-	 */
-	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
-			 	 "=A" (ret), "0" (0ULL) : "ecx", "memory");
-	if (ret)
-		return ret;
-
-	/*
 	 * Don't do an additional sync on CPUs where we know
 	 * RDTSC is already synchronous:
 	 */
_

Patches currently in -mm which might be from zaitcev@redhat.com are

origin.patch
i386-work-around-miscompilation-of-alternatives-code.patch
andi-you-broke-my-laptop.patch
