From: akpm@linux-foundation.org
Subject: [merged] uml-linec-avoid-null-pointer-dereference.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:22 -0800
Message-ID: <201003091905.o29J5Ml8031118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867Ab0CITGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:06:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: line.c: avoid NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     uml-linec-avoid-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: line.c: avoid NULL pointer dereference
From: Alexander Beregalov <a.beregalov@gmail.com>

Assign tty only if line is not NULL.

[akpm@linux-foundation.org: simplification]
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/line.c~uml-linec-avoid-null-pointer-dereference arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-linec-avoid-null-pointer-dereference
+++ a/arch/um/drivers/line.c
@@ -18,10 +18,10 @@ static irqreturn_t line_interrupt(int ir
 {
 	struct chan *chan = data;
 	struct line *line = chan->line;
-	struct tty_struct *tty = line->tty;
+	struct tty_struct *tty;
 
 	if (line)
-		chan_interrupt(&line->chan_list, &line->task, tty, irq);
+		chan_interrupt(&line->chan_list, &line->task, line->tty, irq);
 	return IRQ_HANDLED;
 }
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch

