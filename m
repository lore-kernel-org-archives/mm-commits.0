From: akpm@linux-foundation.org
Subject: - mn10300-tighten-up-the-code-using-case-ranges.patch removed from -mm tree
Date: Mon, 01 Dec 2008 11:49:30 -0800
Message-ID: <200812011949.mB1JnUQN025324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690AbYLATuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 14:50:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: tighten up the code using case ranges
has been removed from the -mm tree.  Its filename was
     mn10300-tighten-up-the-code-using-case-ranges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

