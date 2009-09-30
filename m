From: akpm@linux-foundation.org
Subject: + x86-fix-csum_ipv6_magic-asm-memory-clobber.patch added to -mm tree
Date: Wed, 30 Sep 2009 15:40:49 -0700
Message-ID: <200909302240.n8UMeneJ027840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410AbZI3WmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 18:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, andi@firstfloor.org, davem@davemloft.net, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fix csum_ipv6_magic asm memory clobber
has been added to the -mm tree.  Its filename is
     x86-fix-csum_ipv6_magic-asm-memory-clobber.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix csum_ipv6_magic asm memory clobber
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Just like ip_fast_csum, the assembly snippet in csum_ipv6_magic needs a
memory clobber, as it is only passed the address of the buffer, not a
memory reference to the buffer itself.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andi Kleen <andi@firstfloor.org>
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

x86-fix-csum_ipv6_magic-asm-memory-clobber.patch

