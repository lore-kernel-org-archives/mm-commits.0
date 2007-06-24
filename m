From: akpm@linux-foundation.org
Subject: - alpha-fix-alignment-problem-in-csum_ipv6_magic-fix.patch removed from -mm tree
Date: Sat, 23 Jun 2007 17:14:28 -0700
Message-ID: <200706240014.l5O0ESQL030727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbXFXAOr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 20:14:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, jailbird@alcatraz.fdf.net, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha-fix-alignment-problem-in-csum_ipv6_magic fix
has been removed from the -mm tree.  Its filename was
     alpha-fix-alignment-problem-in-csum_ipv6_magic-fix.patch

This patch was dropped because it was folded into alpha-fix-alignment-problem-in-csum_ipv6_magic.patch

------------------------------------------------------
Subject: alpha-fix-alignment-problem-in-csum_ipv6_magic fix
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

On Thu, Jun 21, 2007 at 04:35:01PM -0700, Andrew Morton wrote:
> In http://bugzilla.kernel.org/show_bug.cgi?id=8659, Dustin is reporting
> that this patch broke tcp-on-ipv6.

Oops. Two instructions operating on the 'len' arg ($18) got swapped...
This should fix ev6 version, ev5 one seems to be ok.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Dustin Marquess <jailbird@alcatraz.fdf.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/ev6-csum_ipv6_magic.S |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/alpha/lib/ev6-csum_ipv6_magic.S~alpha-fix-alignment-problem-in-csum_ipv6_magic-fix arch/alpha/lib/ev6-csum_ipv6_magic.S
--- a/arch/alpha/lib/ev6-csum_ipv6_magic.S~alpha-fix-alignment-problem-in-csum_ipv6_magic-fix
+++ a/arch/alpha/lib/ev6-csum_ipv6_magic.S
@@ -76,18 +76,18 @@ csum_ipv6_magic:
 
 	cmoveq	$6,$31,$22	# E : src aligned?
 	ldq_u	$23,15($17)	# L : Latency: 3
-	or	$18,$4,$18	# E : 000000CCDDAABBCC
-	extql	$1,$6,$1	# U : U L L U :
+	inswl	$18,3,$18	# U : 000000CCDD000000
+	addl	$19,$7,$19	# E : U L U L : <sign bits>bbaabb00
 
 	or	$0,$22,$0	# E : 1st src word complete
-	extqh	$5,$6,$5	# U :
-	addl	$19,$7,$19	# E : <sign bits>bbaabb00
-	and	$17,7,$6	# E : L U L U : dst misalignment
+	extql	$1,$6,$1	# U :
+	or	$18,$4,$18	# E : 000000CCDDAABBCC
+	extqh	$5,$6,$5	# U : L U L U
 
-	inswl	$18,3,$18	# U : 000000CCDD000000
-	or	$1,$5,$1	# E : 2nd src word complete
+	and	$17,7,$6	# E : dst misalignment
 	extql	$2,$6,$2	# U :
-	extqh	$3,$6,$22	# U : U L U U :
+	or	$1,$5,$1	# E : 2nd src word complete
+	extqh	$3,$6,$22	# U : L U L U :
 
 	cmoveq	$6,$31,$22	# E : dst aligned?
 	extql	$3,$6,$3	# U :
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

alpha-fix-alignment-problem-in-csum_ipv6_magic.patch
alpha-fix-alignment-problem-in-csum_ipv6_magic-fix.patch
alpha-fix-trivial-section-mismatch-warnings.patch
make-sure-nobodys-leaking-resources.patch
