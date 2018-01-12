From: akpm@linux-foundation.org
Subject: +
 score-setup-combine-two-seq_printf-calls-into-one-call-in-show_cpuinfo.patch added to -mm tree
Date: Fri, 12 Jan 2018 15:41:32 -0800
Message-ID: <5a5947ac.FrJOPrrHqXCZ5Vlt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965331AbeALXld (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 18:41:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, lennox.wu@gmail.com, liqin.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/score/kernel/setup.c: combine two seq_printf() calls into one call in show_cpuinfo()
has been added to the -mm tree.  Its filename is
     score-setup-combine-two-seq_printf-calls-into-one-call-in-show_cpuinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/score-setup-combine-two-seq_printf-calls-into-one-call-in-show_cpuinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/score-setup-combine-two-seq_printf-calls-into-one-call-in-show_cpuinfo.patch

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
Subject: arch/score/kernel/setup.c: combine two seq_printf() calls into one call in show_cpuinfo()

Some data were printed into a sequence by two separate function calls.
Print the same data by a single function call instead.

This issue was detected by using the Coccinelle software.

Link: http://lkml.kernel.org/r/ddcfff3a-9502-6ce0-b08a-365eb55ce958@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/kernel/setup.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/score/kernel/setup.c~score-setup-combine-two-seq_printf-calls-into-one-call-in-show_cpuinfo arch/score/kernel/setup.c
--- a/arch/score/kernel/setup.c~score-setup-combine-two-seq_printf-calls-into-one-call-in-show_cpuinfo
+++ a/arch/score/kernel/setup.c
@@ -124,9 +124,7 @@ static int show_cpuinfo(struct seq_file
 {
 	unsigned long n = (unsigned long) v - 1;
 
-	seq_printf(m, "processor\t\t: %ld\n", n);
-	seq_printf(m, "\n");
