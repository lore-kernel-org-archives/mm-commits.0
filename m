From: akpm@linux-foundation.org
Subject: - mm-make-config_migration-available-w-o-config_numa-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:19:33 -0700
Message-ID: <200807232332.m6NNWAh7017865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYGWXeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, gerald.schaefer@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fix build error caused by !NUMA migration
has been removed from the -mm tree.  Its filename was
     mm-make-config_migration-available-w-o-config_numa-fix.patch

This patch was dropped because it was folded into mm-make-config_migration-available-w-o-config_numa.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix build error caused by !NUMA migration


Patch title: mm-make-config_migration-available-w-o-config_numa-fix.patch
Against: mmotm Jul 14
Applies after: mm-make-config_migration-available-w-o-config_numa.patch

"Make CONFIG_MIGRATION available w/o CONFIG_NUMA" patch add pagemap.h inclusion.

Unfortunately, mempolicy.h is userland exported header, but pagemap.h isn't.
then it cause build error on IA64 && CONFIG_DISCONTIGMEM environment.

    CHECK   include/linux (342 files)
      linux-2.6.26-rc9-mmotm-0714/usr/include/linux/mempolicy.h:5: included file 'linux/pagemap.h' is not exported
      make[3]: *** [linux-2.6.26-rc9-mmotm-0714/usr/include/linux/.check] Error 1

Signed-off-by: KOSAKI Motorhiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mempolicy.h~mm-make-config_migration-available-w-o-config_numa-fix include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-make-config_migration-available-w-o-config_numa-fix
+++ a/include/linux/mempolicy.h
@@ -2,7 +2,6 @@
 #define _LINUX_MEMPOLICY_H 1
 
 #include <linux/errno.h>
-#include <linux/pagemap.h>
 
 /*
  * NUMA memory policies for Linux.
@@ -60,6 +59,7 @@ enum {
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
 #include <linux/nodemask.h>
+#include <linux/pagemap.h>
 
 struct mm_struct;
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
mm-create-sys-kernel-mm.patch
mm-make-config_migration-available-w-o-config_numa.patch
mm-make-config_migration-available-w-o-config_numa-fix.patch
mm-fix-ever-decreasing-swap-priority.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch

