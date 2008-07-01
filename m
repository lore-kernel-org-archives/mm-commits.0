From: akpm@linux-foundation.org
Subject: + alpha-linux-kernel-fails-with-inconsistent-kallsyms-data.patch added to -mm tree
Date: Tue, 01 Jul 2008 16:36:25 -0700
Message-ID: <200807012336.m61NaPYl020766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756118AbYGAXgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 19:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: waldi@debian.org, ink@jurassic.park.msu.ru, max@stro.at, rth@twiddle.net


The patch titled
     Alpha Linux kernel fails with inconsistent kallsyms data
has been added to the -mm tree.  Its filename is
     alpha-linux-kernel-fails-with-inconsistent-kallsyms-data.patch

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
Subject: Alpha Linux kernel fails with inconsistent kallsyms data
From: Bastian Blank <waldi@debian.org>

The build of the Alpha Linux kernel currently fails[1] with inconsistent
kallsyms data.  As I never saw that before, I thought about hardware
problems.  But in fact it is a bug in the Linux kernel.

The end of the rodata section is marked with the "__end_rodata" symbol. 
This symbol have different aligning constraints than the inittext parts
and therefor the start marked "_sinittext".  Because of that the
__end_rodata symbol shifts between < _sinittext and == _sinittext.  The
later variant is seen as a code symbol and recorded in the kallsyms data.

On fix would be to move the exception table a little bit and get some
space between that two areas.

[1]: http://buildd.debian.org/fetch.cgi?pkg=linux-2.6&arch=alpha&ver=2.6.25-5&stamp=1213919009&file=log&as=raw

Cc: maximilian attems <max@stro.at>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/vmlinux.lds.S |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/alpha/kernel/vmlinux.lds.S~alpha-linux-kernel-fails-with-inconsistent-kallsyms-data arch/alpha/kernel/vmlinux.lds.S
--- a/arch/alpha/kernel/vmlinux.lds.S~alpha-linux-kernel-fails-with-inconsistent-kallsyms-data
+++ a/arch/alpha/kernel/vmlinux.lds.S
@@ -25,6 +25,13 @@ SECTIONS
 	} :kernel
 	_etext = .;	/* End of text section */
 
+	NOTES :kernel :note
+	.dummy : {
+		*(.dummy)
+	} :kernel
+
+	RODATA
+
 	/* Exception table */
 	. = ALIGN(16);
 	__ex_table : {
@@ -33,13 +40,6 @@ SECTIONS
 		__stop___ex_table = .;
 	}
 
-	NOTES :kernel :note
-	.dummy : {
-		*(.dummy)
-	} :kernel
-
-	RODATA
