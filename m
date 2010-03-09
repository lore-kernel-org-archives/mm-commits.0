From: akpm@linux-foundation.org
Subject: [merged] init-mainc-make-setup_max_cpus-static-for-smp.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:01 -0800
Message-ID: <201003091906.o29J61H6031151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755293Ab0CITWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, mm-commits@vger.kernel.org


The patch titled
     init/main.c: make setup_max_cpus static for !SMP
has been removed from the -mm tree.  Its filename was
     init-mainc-make-setup_max_cpus-static-for-smp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/main.c: make setup_max_cpus static for !SMP
From: H Hartley Sweeten <hartleys@visionengravers.com>

init/main.c: make setup_max_cpus static for !SMP

The only in tree external users of the symbol setup_max_cpus are in
arch/x86/.  The files ./kernel/alternative.c, ./kernel/visws_quirks.c, and
./mm/kmemcheck/kmemcheck.c are all guarded by CONFIG_SMP being defined. 
For this case the symbol is an unsigned int and declared as an extern in
include/linux/smp.h.

When CONFIG_SMP is not defined the symbol setup_max_cpus is
a constant value that is only used in init/main.c.  Make the symbol
static for this case.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~init-mainc-make-setup_max_cpus-static-for-smp init/main.c
--- a/init/main.c~init-mainc-make-setup_max_cpus-static-for-smp
+++ a/init/main.c
@@ -174,7 +174,7 @@ static int __init maxcpus(char *str)
 
 early_param("maxcpus", maxcpus);
 #else
-const unsigned int setup_max_cpus = NR_CPUS;
+static const unsigned int setup_max_cpus = NR_CPUS;
 #endif
 
 /*
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
scsi-sdc-quiet-all-sparse-noise.patch

