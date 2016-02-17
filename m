From: akpm@linux-foundation.org
Subject: + mm-compaction-introduce-kcompactd-fix-2.patch added to -mm tree
Date: Wed, 17 Feb 2016 13:46:34 -0800
Message-ID: <56c4ea3a.zaT5gIPg6D7AjEZm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423221AbcBQVqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Feb 2016 16:46:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.gortmaker@windriver.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: don't use modular references for non modular code
has been added to the -mm tree.  Its filename is
     mm-compaction-introduce-kcompactd-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-introduce-kcompactd-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-introduce-kcompactd-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
