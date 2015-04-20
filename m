From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-improve-put_dec_trunc8-slightly.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:16:31 -0700
Message-ID: <5535508f.A7Fa7T6UM7UoYdFa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbDTTKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.p.zijlstra@chello.nl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: improve put_dec_trunc8 slightly
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-improve-put_dec_trunc8-slightly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: improve put_dec_trunc8 slightly

I hadn't had enough coffee when I wrote this. Currently, the final
increment of buf depends on the value loaded from the table, and
causes gcc to emit a cmov immediately before the return. It is smarter
to let it depend on r, since the increment can then be computed in
parallel with the final load/store pair. It also shaves 16 bytes of
.text.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-improve-put_dec_trunc8-slightly lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-improve-put_dec_trunc8-slightly
+++ a/lib/vsprintf.c
@@ -165,9 +165,9 @@ static const u16 decpair[100] = {
 
 /*
  * This will print a single '0' even if r == 0, since we would
- * immediately jump to out_r where two 0s would be written and one of
- * them then discarded. This is needed by ip4_string below. All other
- * callers pass a non-zero value of r.
+ * immediately jump to out_r where two 0s would be written but only
+ * one of them accounted for in buf. This is needed by ip4_string
+ * below. All other callers pass a non-zero value of r.
 */
 static noinline_for_stack
 char *put_dec_trunc8(char *buf, unsigned r)
@@ -206,9 +206,7 @@ out_q:
 out_r:
 	/* 1 <= r < 100 */
 	*((u16 *)buf) = decpair[r];
-	buf += 2;
-	if (buf[-1] == '0')
-		buf--;
+	buf += r < 10 ? 1 : 2;
 	return buf;
 }
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch

