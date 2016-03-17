From: akpm@linux-foundation.org
Subject: [folded-merged] mm-compaction-introduce-kcompactd-fix-2.patch
 removed from -mm tree
Date: Thu, 17 Mar 2016 13:51:11 -0700
Message-ID: <56eb18bf.Ihl9IBInBhKkBiuF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030342AbcCQUvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:51:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.gortmaker@windriver.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: don't use modular references for non modular code
has been removed from the -mm tree.  Its filename was
     mm-compaction-introduce-kcompactd-fix-2.patch

This patch was dropped because it was folded into mm-compaction-introduce-kcompactd.patch

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: mm/compaction: don't use modular references for non modular code

replace module_init with subsys_initcall ; which will be two
levels earlier, but mm smells like a subsystem to me.

Compile tested only.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-introduce-kcompactd-fix-2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-introduce-kcompactd-fix-2
+++ a/mm/compaction.c
@@ -20,7 +20,6 @@
 #include <linux/kasan.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
-#include <linux/module.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -1954,7 +1953,6 @@ static int __init kcompactd_init(void)
 	hotcpu_notifier(cpu_callback, 0);
 	return 0;
 }
