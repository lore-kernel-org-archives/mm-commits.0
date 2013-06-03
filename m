From: akpm@linux-foundation.org
Subject: [merged] drivers-staging-zcache-fix-compile-error.patch removed
 from -mm tree
Date: Mon, 03 Jun 2013 13:29:57 -0700
Message-ID: <51acfcc5.UoQXNzZw+LPrsVuQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3FCU37 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 16:29:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konrad.wilk@oracle.com, greg@kroah.com, fengguang.wu@intel.com, dan.magenheimer@oracle.com, bob.liu@oracle.com, lliubbo@gmail.com

Subject: [merged] drivers-staging-zcache-fix-compile-error.patch removed from -mm tree
To: lliubbo@gmail.com,bob.liu@oracle.com,dan.magenheimer@oracle.com,fengguang.wu@intel.com,greg@kroah.com,konrad.wilk@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 13:29:57 -0700


The patch titled
     Subject: drivers: staging: zcache: fix compile error
has been removed from the -mm tree.  Its filename was
     drivers-staging-zcache-fix-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: drivers: staging: zcache: fix compile error

Fix below compile error:
drivers/built-in.o: In function `zcache_pampd_free':
>> zcache-main.c:(.text+0xb1c8a): undefined reference to `ramster_pampd_free'
>> zcache-main.c:(.text+0xb1cbc): undefined reference to `ramster_count_foreign_pages'
drivers/built-in.o: In function `zcache_pampd_get_data_and_free':
>> zcache-main.c:(.text+0xb1f05): undefined reference to `ramster_count_foreign_pages'
drivers/built-in.o: In function `zcache_cpu_notifier':
>> zcache-main.c:(.text+0xb228d): undefined reference to `ramster_cpu_up'
>> zcache-main.c:(.text+0xb2339): undefined reference to `ramster_cpu_down'
drivers/built-in.o: In function `zcache_pampd_create':
>> (.text+0xb26ce): undefined reference to `ramster_count_foreign_pages'
drivers/built-in.o: In function `zcache_pampd_create':
>> (.text+0xb27ef): undefined reference to `ramster_count_foreign_pages'
drivers/built-in.o: In function `zcache_put_page':
>> (.text+0xb299f): undefined reference to `ramster_do_preload_flnode'
drivers/built-in.o: In function `zcache_flush_page':
>> (.text+0xb2ea3): undefined reference to `ramster_do_preload_flnode'
drivers/built-in.o: In function `zcache_flush_object':
>> (.text+0xb307c): undefined reference to `ramster_do_preload_flnode'
drivers/built-in.o: In function `zcache_init':
>> zcache-main.c:(.text+0xb3629): undefined reference to `ramster_register_pamops'
>> zcache-main.c:(.text+0xb3868): undefined reference to `ramster_init'
>> drivers/built-in.o:(.rodata+0x15058): undefined reference to `ramster_foreign_eph_pages'
>> drivers/built-in.o:(.rodata+0x15078): undefined reference to `ramster_foreign_pers_pages'

Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/ramster.h         |    4 ----
 drivers/staging/zcache/ramster/debug.c   |    2 ++
 drivers/staging/zcache/ramster/ramster.c |    6 ++++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/staging/zcache/ramster.h~drivers-staging-zcache-fix-compile-error drivers/staging/zcache/ramster.h
--- a/drivers/staging/zcache/ramster.h~drivers-staging-zcache-fix-compile-error
+++ a/drivers/staging/zcache/ramster.h
@@ -11,10 +11,6 @@
 #ifndef _ZCACHE_RAMSTER_H_
 #define _ZCACHE_RAMSTER_H_
 
-#ifdef CONFIG_RAMSTER_MODULE
-#define CONFIG_RAMSTER
-#endif
-
 #ifdef CONFIG_RAMSTER
 #include "ramster/ramster.h"
 #else
diff -puN drivers/staging/zcache/ramster/debug.c~drivers-staging-zcache-fix-compile-error drivers/staging/zcache/ramster/debug.c
--- a/drivers/staging/zcache/ramster/debug.c~drivers-staging-zcache-fix-compile-error
+++ a/drivers/staging/zcache/ramster/debug.c
@@ -1,6 +1,8 @@
 #include <linux/atomic.h>
 #include "debug.h"
 
+ssize_t ramster_foreign_eph_pages;
+ssize_t ramster_foreign_pers_pages;
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 
diff -puN drivers/staging/zcache/ramster/ramster.c~drivers-staging-zcache-fix-compile-error drivers/staging/zcache/ramster/ramster.c
--- a/drivers/staging/zcache/ramster/ramster.c~drivers-staging-zcache-fix-compile-error
+++ a/drivers/staging/zcache/ramster/ramster.c
@@ -66,8 +66,6 @@ static int ramster_remote_target_nodenum
 
 /* Used by this code. */
 long ramster_flnodes;
-ssize_t ramster_foreign_eph_pages;
-ssize_t ramster_foreign_pers_pages;
 /* FIXME frontswap selfshrinking knobs in debugfs? */
 
 static LIST_HEAD(ramster_rem_op_list);
@@ -399,14 +397,18 @@ void ramster_count_foreign_pages(bool ep
 			inc_ramster_foreign_eph_pages();
 		} else {
 			dec_ramster_foreign_eph_pages();
+#ifdef CONFIG_RAMSTER_DEBUG
 			WARN_ON_ONCE(ramster_foreign_eph_pages < 0);
+#endif
 		}
 	} else {
 		if (count > 0) {
 			inc_ramster_foreign_pers_pages();
 		} else {
 			dec_ramster_foreign_pers_pages();
+#ifdef CONFIG_RAMSTER_DEBUG
 			WARN_ON_ONCE(ramster_foreign_pers_pages < 0);
+#endif
 		}
 	}
 }
_

Patches currently in -mm which might be from lliubbo@gmail.com are

linux-next.patch
mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

