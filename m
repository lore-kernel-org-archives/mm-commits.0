From: akpm@linux-foundation.org
Subject: + parisc-remove-gratuitous-cpu_online_map-declaration.patch added to -mm tree
Date: Sat, 06 Dec 2008 23:10:49 -0800
Message-ID: <200812070710.mB77AnVM015897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbYLGHLu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 02:11:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, deller@gmx.de, grundler@parisc-linux.org, kyle@mcmartin.ca


The patch titled
     parisc: remove gratuitous cpu_online_map declaration
has been added to the -mm tree.  Its filename is
     parisc-remove-gratuitous-cpu_online_map-declaration.patch

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
Subject: parisc: remove gratuitous cpu_online_map declaration
From: Rusty Russell <rusty@rustcorp.com.au>

This is defined in linux/cpumask.h (included in this file already),
and this will break when the definition changes (in a following patch).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/smp.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/parisc/include/asm/smp.h~parisc-remove-gratuitous-cpu_online_map-declaration arch/parisc/include/asm/smp.h
--- a/arch/parisc/include/asm/smp.h~parisc-remove-gratuitous-cpu_online_map-declaration
+++ a/arch/parisc/include/asm/smp.h
@@ -16,8 +16,6 @@
 #include <linux/cpumask.h>
 typedef unsigned long address_t;
 
-extern cpumask_t cpu_online_map;
