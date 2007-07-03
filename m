From: akpm@linux-foundation.org
Subject: + mtrr-fix-race-causing-set_mtrr-to-go-into-infinite-loop.patch added to -mm tree
Date: Mon, 02 Jul 2007 21:05:57 -0700
Message-ID: <200707030405.l6345vJk030430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729AbXGCEGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 00:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: loic@myri.com, ak@suse.de


The patch titled
     MTRR: Fix race causing set_mtrr to go into infinite loop
has been added to the -mm tree.  Its filename is
     mtrr-fix-race-causing-set_mtrr-to-go-into-infinite-loop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MTRR: Fix race causing set_mtrr to go into infinite loop
From: Loic Prylli <loic@myri.com>

Processors synchronization in set_mtrr requires the .gate field to be set
after .count field is properly initialized.  Without an explicit barrier,
the compiler was reordering those memory stores.  That was sometimes
causing a processor (in ipi_handler) to see the .gate change and decrement
.count before the latter is set by set_mtrr() (which then hangs in a
infinite loop with irqs disabled).

Signed-off-by: Loic Prylli <loic@myri.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/i386/kernel/cpu/mtrr/main.c~mtrr-fix-race-causing-set_mtrr-to-go-into-infinite-loop arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~mtrr-fix-race-causing-set_mtrr-to-go-into-infinite-loop
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -229,6 +229,8 @@ static void set_mtrr(unsigned int reg, u
 	data.smp_size = size;
 	data.smp_type = type;
 	atomic_set(&data.count, num_booting_cpus() - 1);
+	/* make sure data.count is visible before unleashing other CPUs */
+	smp_wmb();
 	atomic_set(&data.gate,0);
 
 	/*  Start the ball rolling on other CPUs  */
@@ -242,6 +244,7 @@ static void set_mtrr(unsigned int reg, u
 
 	/* ok, reset count and toggle gate */
 	atomic_set(&data.count, num_booting_cpus() - 1);
+	smp_wmb();
 	atomic_set(&data.gate,1);
 
 	/* do our MTRR business */
@@ -260,6 +263,7 @@ static void set_mtrr(unsigned int reg, u
 		cpu_relax();
 
 	atomic_set(&data.count, num_booting_cpus() - 1);
+	smp_wmb();
 	atomic_set(&data.gate,0);
 
 	/*
_

Patches currently in -mm which might be from loic@myri.com are

mtrr-fix-race-causing-set_mtrr-to-go-into-infinite-loop.patch
