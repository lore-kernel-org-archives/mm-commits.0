From: akpm@linux-foundation.org
Subject: + init-fix-building-bug-and-potential-buffer-overflow.patch added to -mm tree
Date: Thu, 15 May 2008 10:58:22 -0700
Message-ID: <200805151758.m4FHwM74002839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764316AbYEOR64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 13:58:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, geert@linux-m68k.org


The patch titled
     init: fix build and potential buffer overflow
has been added to the -mm tree.  Its filename is
     init-fix-building-bug-and-potential-buffer-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init: fix build and potential buffer overflow
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch fixes a build bug on m68k which does not have strncat in a
straight way.

What is more important - my previous patch

commit e662e1cfd434aa234b72fbc781f1d70211cb785b
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Mon May 12 14:02:22 2008 -0700

    init: don't lose initcall return values

Has introduced potential buffer overflow by wrong calculation of string
accumulator size.

Many thanks Andreas Schwab and Geert Uytterhoeven for helping
to catch and fix the bug.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN init/main.c~init-fix-building-bug-and-potential-buffer-overflow init/main.c
--- a/init/main.c~init-fix-building-bug-and-potential-buffer-overflow
+++ a/init/main.c
@@ -702,7 +702,7 @@ static void __init do_initcalls(void)
 
 	for (call = __initcall_start; call < __initcall_end; call++) {
 		ktime_t t0, t1, delta;
-		char msgbuf[40];
+		char msgbuf[64];
 		int result;
 
 		if (initcall_debug) {
@@ -729,11 +729,11 @@ static void __init do_initcalls(void)
 			sprintf(msgbuf, "error code %d ", result);
 
 		if (preempt_count() != count) {
-			strncat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
+			strcat(msgbuf, "preemption imbalance ");
 			preempt_count() = count;
 		}
 		if (irqs_disabled()) {
-			strncat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
+			strcat(msgbuf, "disabled interrupts ");
 			local_irq_enable();
 		}
 		if (msgbuf[0]) {
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
init-fix-building-bug-and-potential-buffer-overflow.patch
module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch

