From: akpm@linux-foundation.org
Subject: + mn10300-tighten-up-the-code-using-case-ranges.patch added to -mm tree
Date: Fri, 28 Nov 2008 23:47:55 -0800
Message-ID: <200811290747.mAT7ltgQ030931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbYK2Hsm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 02:48:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, dhowells@redhat.com


The patch titled
     mn10300: tighten up the code using case ranges
has been added to the -mm tree.  Its filename is
     mn10300-tighten-up-the-code-using-case-ranges.patch

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
Subject: mn10300: tighten up the code using case ranges
From: Robert P. J. Day <rpjday@crashcourse.ca>

Compress a set of consecutive switch cases into a case-range.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/gdb-stub.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff -puN arch/mn10300/kernel/gdb-stub.c~mn10300-tighten-up-the-code-using-case-ranges arch/mn10300/kernel/gdb-stub.c
--- a/arch/mn10300/kernel/gdb-stub.c~mn10300-tighten-up-the-code-using-case-ranges
+++ a/arch/mn10300/kernel/gdb-stub.c
@@ -522,17 +522,7 @@ static int gdbstub_single_step(struct pt
 	} else {
 		switch (cur) {
 			/* Bxx (d8,PC) */
-		case 0xc0:
-		case 0xc1:
-		case 0xc2:
-		case 0xc3:
-		case 0xc4:
-		case 0xc5:
-		case 0xc6:
-		case 0xc7:
-		case 0xc8:
-		case 0xc9:
-		case 0xca:
+		case 0xc0 ... 0xca:
 			if (gdbstub_read_byte(pc + 1, (u8 *) &x) < 0)
 				goto fault;
 			if (!__gdbstub_mark_bp(pc + 2, 0))
@@ -543,17 +533,7 @@ static int gdbstub_single_step(struct pt
 			break;
 
 			/* LXX (d8,PC) */
-		case 0xd0:
-		case 0xd1:
-		case 0xd2:
-		case 0xd3:
-		case 0xd4:
-		case 0xd5:
-		case 0xd6:
-		case 0xd7:
-		case 0xd8:
-		case 0xd9:
-		case 0xda:
+		case 0xd0 ... 0xda:
 			if (!__gdbstub_mark_bp(pc + 1, 0))
 				goto fault;
 			if (regs->pc != regs->lar &&
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

mn10300-tighten-up-the-code-using-case-ranges.patch

