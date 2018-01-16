From: akpm@linux-foundation.org
Subject: + fs-proc-use-seq_putc-in-show_console_dev.patch added to -mm
 tree
Date: Tue, 16 Jan 2018 14:19:43 -0800
Message-ID: <5a5e7a7f.8egZWaGdXHkltgEd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbeAPWTo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jan 2018 17:19:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/consoles.c: use seq_putc() in show_console_dev()
has been added to the -mm tree.  Its filename is
     fs-proc-use-seq_putc-in-show_console_dev.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-use-seq_putc-in-show_console_dev.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-use-seq_putc-in-show_console_dev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: fs/proc/consoles.c: use seq_putc() in show_console_dev()
Date: Sat, 13 Jan 2018 17:17:59 +0100

A single character (line break) should be put into a sequence.  Thus use
the corresponding function "seq_putc".

This issue was detected by using the Coccinelle software.

Link: http://lkml.kernel.org/r/04fb69fe-d820-9141-820f-07e9a48f4635@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/consoles.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/consoles.c~fs-proc-use-seq_putc-in-show_console_dev fs/proc/consoles.c
--- a/fs/proc/consoles.c~fs-proc-use-seq_putc-in-show_console_dev
+++ a/fs/proc/consoles.c
@@ -55,8 +55,7 @@ static int show_console_dev(struct seq_f
 	if (dev)
 		seq_printf(m, " %4d:%d", MAJOR(dev), MINOR(dev));
 
-	seq_printf(m, "\n");
