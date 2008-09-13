From: akpm@linux-foundation.org
Subject: - dyn_array-fix-typo.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:46:06 -0700
Message-ID: <200809130746.m8D7k6wG026825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496AbYIMHqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     dyn_array: fix typo
has been removed from the -mm tree.  Its filename was
     dyn_array-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dyn_array: fix typo
From: Yinghai Lu <yhlu.kernel@gmail.com>

Andrew found the typo could break some platforms

also fix one checkpatch warning

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/dyn_array.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN init/dyn_array.c~dyn_array-fix-typo init/dyn_array.c
--- a/init/dyn_array.c~dyn_array-fix-typo
+++ a/init/dyn_array.c
@@ -52,7 +52,7 @@ void __init pre_alloc_dyn_array(void)
 			da->init_work(da);
 	}
 #else
-#ifdef CONFIF_GENERIC_HARDIRQS
+#ifdef CONFIG_GENERIC_HARDIRQS
 	unsigned int i;
 
 	for (i = 0; i < NR_IRQS; i++)
@@ -113,9 +113,8 @@ void __init per_cpu_alloc_dyn_array(int 
 
 		phys += size;
 
-		if (da->init_work) {
+		if (da->init_work)
 			da->init_work(da);
-		}
 	}
 #endif
 }
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

linux-next.patch
apci-dump-slit.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol.patch
net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch

