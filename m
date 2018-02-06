From: akpm@linux-foundation.org
Subject: [patch 084/114] arch/score/kernel/setup.c: combine two
 seq_printf() calls into one call in show_cpuinfo()
Date: Tue, 06 Feb 2018 15:40:56 -0800
Message-ID: <20180206234056.6_bJ5LZ6J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBFXk5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:40:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, elfring@users.sourceforge.net, lennox.wu@gmail.com, liqin.linux@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
