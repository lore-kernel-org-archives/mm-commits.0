From: akpm@linux-foundation.org
Subject: + ia64-fix-csum_ipv6_magic.patch added to -mm tree
Date: Tue, 01 Sep 2009 12:56:53 -0700
Message-ID: <200909011956.n81JurZx000647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbZIAT47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 15:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbohac@suse.cz, fenghua.yu@intel.com, tony.luck@intel.com


The patch titled
     ia64: fix csum_ipv6_magic()
has been added to the -mm tree.  Its filename is
     ia64-fix-csum_ipv6_magic.patch

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
Subject: ia64: fix csum_ipv6_magic()
From: Jiri Bohac <jbohac@suse.cz>

The 32-bit parameters (len and csum) of csum_ipv6_magic() are passed in
64-bit registers in3 and in4.  The high order 32 bits of the registers
were never cleared, and garbage was sometimes calculated into the
checksum.

Fix this by clearing the high order 32 bits of the registers.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/lib/ip_fast_csum.S |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/ia64/lib/ip_fast_csum.S~ia64-fix-csum_ipv6_magic arch/ia64/lib/ip_fast_csum.S
--- a/arch/ia64/lib/ip_fast_csum.S~ia64-fix-csum_ipv6_magic
+++ a/arch/ia64/lib/ip_fast_csum.S
@@ -96,20 +96,22 @@ END(ip_fast_csum)
 GLOBAL_ENTRY(csum_ipv6_magic)
 	ld4	r20=[in0],4
 	ld4	r21=[in1],4
-	dep	r15=in3,in2,32,16
+	zxt4	in3=in3
 	;;
 	ld4	r22=[in0],4
 	ld4	r23=[in1],4
-	mux1	r15=r15,@rev
+	dep	r15=in3,in2,32,16
 	;;
 	ld4	r24=[in0],4
 	ld4	r25=[in1],4
-	shr.u	r15=r15,16
+	mux1	r15=r15,@rev
 	add	r16=r20,r21
 	add	r17=r22,r23
+	zxt4	in4=in4
 	;;
 	ld4	r26=[in0],4
 	ld4	r27=[in1],4
+	shr.u	r15=r15,16
 	add	r18=r24,r25
 	add	r8=r16,r17
 	;;
_

Patches currently in -mm which might be from jbohac@suse.cz are

ia64-fix-csum_ipv6_magic.patch

