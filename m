From: akpm@linux-foundation.org
Subject: - parisc-remove-gratuitous-cpu_online_map-declaration.patch removed from -mm tree
Date: Mon, 08 Dec 2008 15:24:29 -0800
Message-ID: <200812082324.mB8NOTbN007038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442AbYLHXfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 18:35:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, deller@gmx.de, grundler@parisc-linux.org, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     parisc: remove gratuitous cpu_online_map declaration
has been removed from the -mm tree.  Its filename was
     parisc-remove-gratuitous-cpu_online_map-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
