From: akpm@linux-foundation.org
Subject: + dyn_array-fix-typo.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:59:59 -0700
Message-ID: <200809022259.m82Mxxmx017222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158AbYIBXAP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 19:00:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, mingo@elte.hu


The patch titled
     dyn_array: fix typo
has been added to the -mm tree.  Its filename is
     dyn_array-fix-typo.patch

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

origin.patch
linux-next.patch
dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol.patch
dyn_array-fix-typo.patch
forcedeth-fix-kexec-regression.patch

