From: akpm@linux-foundation.org
Subject: + scripts-checkstackpl-add-support-for-nios2.patch added to -mm
 tree
Date: Tue, 17 Jan 2017 15:10:43 -0800
Message-ID: <587ea473.zXmG1PmJGWT18SEQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49492 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdAQXML (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 18:12:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, lftan@altera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/checkstack.pl: add support for nios2
has been added to the -mm tree.  Its filename is
     scripts-checkstackpl-add-support-for-nios2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-checkstackpl-add-support-for-nios2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-checkstackpl-add-support-for-nios2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: scripts/checkstack.pl: add support for nios2

Adjust checkstack.pl for the nios2 architecture.

Link: http://lkml.kernel.org/r/20170116113052.15034-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Ley Foon Tan <lftan@altera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/checkstack.pl~scripts-checkstackpl-add-support-for-nios2 scripts/checkstack.pl
--- a/scripts/checkstack.pl~scripts-checkstackpl-add-support-for-nios2
+++ a/scripts/checkstack.pl
@@ -78,6 +78,9 @@ my (@stack, $re, $dre, $x, $xs, $funcre)
 	} elsif ($arch eq 'mips') {
 		#88003254:       27bdffe0        addiu   sp,sp,-32
 		$re = qr/.*addiu.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+	} elsif ($arch eq 'nios2') {
+		#25a8:	defffb04 	addi	sp,sp,-20
+		$re = qr/.*addi.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
 	} elsif ($arch eq 'parisc' || $arch eq 'parisc64') {
 		$re = qr/.*ldo ($x{1,8})\(sp\),sp/o;
 	} elsif ($arch eq 'ppc') {
_

Patches currently in -mm which might be from tklauser@distanz.ch are

scripts-checkstackpl-add-support-for-nios2.patch

