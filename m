From: akpm@linux-foundation.org
Subject: [patch 027/114] fs/proc/consoles.c: use seq_putc() in
 show_console_dev()
Date: Tue, 06 Feb 2018 15:37:34 -0800
Message-ID: <20180206233734.pkXIfyKDG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeBFXhg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Markus Elfring <elfring@users.sourceforge.net>
Subject: fs/proc/consoles.c: use seq_putc() in show_console_dev()

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
