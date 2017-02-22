From: akpm@linux-foundation.org
Subject: [patch 013/142] scripts/checkstack.pl: add support for nios2
Date: Wed, 22 Feb 2017 15:40:23 -0800
Message-ID: <58ae2167.LoMPTpNkz+KnB1QC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934169AbdBVXlz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:41:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tklauser@distanz.ch, lftan@altera.com

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
