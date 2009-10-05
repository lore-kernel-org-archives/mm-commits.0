From: akpm@linux-foundation.org
Subject: [merged] x86-fix-csum_ipv6_magic-asm-memory-clobber.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:38:17 -0700
Message-ID: <200910051838.n95IcHms016619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbZJESlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:41:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, andi@firstfloor.org, davem@davemloft.net, hpa@zytor.com, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: fix csum_ipv6_magic asm memory clobber
has been removed from the -mm tree.  Its filename was
     x86-fix-csum_ipv6_magic-asm-memory-clobber.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix csum_ipv6_magic asm memory clobber
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Just like ip_fast_csum, the assembly snippet in csum_ipv6_magic needs a
memory clobber, as it is only passed the address of the buffer, not a
memory reference to the buffer itself.

This caused failures in Hurd's pfinetv4 when we tried to compile it with
gcc-4.3 (bogus checksums).

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: "David S. Miller" <davem@davemloft.net>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/checksum_32.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/checksum_32.h~x86-fix-csum_ipv6_magic-asm-memory-clobber arch/x86/include/asm/checksum_32.h
--- a/arch/x86/include/asm/checksum_32.h~x86-fix-csum_ipv6_magic-asm-memory-clobber
+++ a/arch/x86/include/asm/checksum_32.h
@@ -161,7 +161,8 @@ static inline __sum16 csum_ipv6_magic(co
 	    "adcl $0, %0	;\n"
 	    : "=&r" (sum)
 	    : "r" (saddr), "r" (daddr),
-	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum));
+	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum)
+	    : "memory");
 
 	return csum_fold(sum);
 }
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

linux-next.patch

