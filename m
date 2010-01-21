From: akpm@linux-foundation.org
Subject: + uml-linec-avoid-null-pointer-dereference.patch added to -mm tree
Date: Thu, 21 Jan 2010 15:47:39 -0800
Message-ID: <201001212347.o0LNldT3004535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322Ab0AUXsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 18:48:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, jdike@addtoit.com


The patch titled
     uml: line.c: avoid NULL pointer dereference
has been added to the -mm tree.  Its filename is
     uml-linec-avoid-null-pointer-dereference.patch

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
Subject: uml: line.c: avoid NULL pointer dereference
From: Alexander Beregalov <a.beregalov@gmail.com>

Assign tty only if line is not NULL.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/line.c~uml-linec-avoid-null-pointer-dereference arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-linec-avoid-null-pointer-dereference
+++ a/arch/um/drivers/line.c
@@ -18,10 +18,12 @@ static irqreturn_t line_interrupt(int ir
 {
 	struct chan *chan = data;
 	struct line *line = chan->line;
-	struct tty_struct *tty = line->tty;
+	struct tty_struct *tty;
 
-	if (line)
+	if (line) {
+		tty = line->tty;
 		chan_interrupt(&line->chan_list, &line->task, tty, irq);
+	}
 	return IRQ_HANDLED;
 }
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
linux-next.patch
uml-linec-avoid-null-pointer-dereference.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
rtc-mxc-fix-memory-leak.patch

