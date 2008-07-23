From: akpm@linux-foundation.org
Subject: - mm-create-sys-kernel-mm-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:01:37 -0700
Message-ID: <200807232314.m6NNEEZa016973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbYGWXPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:15:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, nacc@us.ibm.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm-create-sys-kernel-mm fix
has been removed from the -mm tree.  Its filename was
     mm-create-sys-kernel-mm-fix.patch

This patch was dropped because it was folded into mm-create-sys-kernel-mm.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-create-sys-kernel-mm fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Recently, Nishanth Aravamudan introduce /sys/kernel/mm and add
EXPORT_SYMBOL_GPL() to mm_init.c.  then module.h should be included.

otherwise following warning happend.

  mm/mm_init.c:140: warning: data definition has no type or storage class
  mm/mm_init.c:140: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
  mm/mm_init.c:140: warning: parameter names (without types) in function declaration

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mm_init.c~mm-create-sys-kernel-mm-fix mm/mm_init.c
--- a/mm/mm_init.c~mm-create-sys-kernel-mm-fix
+++ a/mm/mm_init.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/kobject.h>
+#include <linux/module.h>
 #include "internal.h"
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
mm-create-sys-kernel-mm.patch
mm-create-sys-kernel-mm-fix.patch
mm-make-config_migration-available-w-o-config_numa-fix.patch
mm-fix-ever-decreasing-swap-priority.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch

