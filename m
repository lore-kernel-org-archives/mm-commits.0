From: akpm@linux-foundation.org
Subject: + andi-you-broke-my-laptop.patch added to -mm tree
Date: Wed, 09 May 2007 20:19:44 -0700
Message-ID: <200705100319.l4A3JiJL010924@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbXEJDUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 23:20:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zaitcev@redhat.com, ak@suse.de, joerg.roedel@amd.com


The patch titled
     Andi, you broke my laptop :-)
has been added to the -mm tree.  Its filename is
     andi-you-broke-my-laptop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
andi-you-broke-my-laptop.patch
