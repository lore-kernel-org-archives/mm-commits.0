From: akpm@linux-foundation.org
Subject: [merged] smp-add-missing-inith-include.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:41:27 -0700
Message-ID: <201103232045.p2NKj3Ns029157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756000Ab1CWUzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, amwang@redhat.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/smp.h: add missing init.h include
has been removed from the -mm tree.  Its filename was
     smp-add-missing-inith-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/smp.h: add missing init.h include
From: Heiko Carstens <heiko.carstens@de.ibm.com>

34db18a05 ("smp: move smp setup functions to kernel/smp.c") causes this build
error on s390 because of a missing init.h include:

CC      arch/s390/kernel/asm-offsets.s
In file included from /home2/heicarst/linux-2.6/arch/s390/include/asm/spinlock.h:14:0,
from include/linux/spinlock.h:87,
from include/linux/seqlock.h:29,
from include/linux/time.h:8,
from include/linux/timex.h:56,
from include/linux/sched.h:57,
from arch/s390/kernel/asm-offsets.c:10:
include/linux/smp.h:117:20: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'setup_nr_cpu_ids'
include/linux/smp.h:118:20: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'smp_init'

Fix it by adding the include statement.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/smp.h~smp-add-missing-inith-include include/linux/smp.h
--- a/include/linux/smp.h~smp-add-missing-inith-include
+++ a/include/linux/smp.h
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/cpumask.h>
+#include <linux/init.h>
 
 extern void cpu_idle(void);
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
s390-introduce-little-endian-bitops.patch
s390-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch
linux-next.patch

