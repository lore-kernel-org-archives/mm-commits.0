From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:45 -0800
Message-ID: <548d0d4d.N1IORoFU676w71fa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaLNEIh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, opensource.ganesh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: fix zs_init cpu notifier error handling
has been removed from the -mm tree.  Its filename was
     zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: fix zs_init cpu notifier error handling

Mahendran Ganesh reported that zpool-enabled zsmalloc should not call
zpool_unregister_driver() from zs_init() if cpu notifier registration has
failed, because error handling is performed before we register the driver
via zpool_register_driver() call.

Factor out cpu notifier registration and unregistration code and fix
zs_init() error handling.

link: http://lkml.iu.edu//hypermail/linux/kernel/1411.1/04156.html
[akpm@linux-foundation.org: squash bogus gcc warning]
[akpm@linux-foundation.org: use __init and __exit]
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-fix-zs_init-cpu-notifier-error-handling mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-fix-zs_init-cpu-notifier-error-handling
+++ a/mm/zsmalloc.c
@@ -881,14 +881,10 @@ static struct notifier_block zs_cpu_nb =
 	.notifier_call = zs_cpu_notifier
 };
 
-static void zs_exit(void)
+static void zs_unregister_cpu_notifier(void)
 {
 	int cpu;
 
-#ifdef CONFIG_ZPOOL
-	zpool_unregister_driver(&zs_zpool_driver);
-#endif
-
 	cpu_notifier_register_begin();
 
 	for_each_online_cpu(cpu)
@@ -898,31 +894,44 @@ static void zs_exit(void)
 	cpu_notifier_register_done();
 }
 
-static int zs_init(void)
+static int zs_register_cpu_notifier(void)
 {
-	int cpu, ret;
+	int cpu, uninitialized_var(ret);
 
 	cpu_notifier_register_begin();
 
 	__register_cpu_notifier(&zs_cpu_nb);
 	for_each_online_cpu(cpu) {
 		ret = zs_cpu_notifier(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
-		if (notifier_to_errno(ret)) {
-			cpu_notifier_register_done();
-			goto fail;
-		}
+		if (notifier_to_errno(ret))
+			break;
 	}
 
 	cpu_notifier_register_done();
+	return notifier_to_errno(ret);
+}
 
+static void __exit zs_exit(void)
+{
 #ifdef CONFIG_ZPOOL
-	zpool_register_driver(&zs_zpool_driver);
+	zpool_unregister_driver(&zs_zpool_driver);
 #endif
+	zs_unregister_cpu_notifier();
+}
+
+static int __init zs_init(void)
+{
+	int ret = zs_register_cpu_notifier();
+
+	if (ret) {
+		zs_unregister_cpu_notifier();
+		return ret;
+	}
 
+#ifdef CONFIG_ZPOOL
+	zpool_register_driver(&zs_zpool_driver);
+#endif
 	return 0;
-fail:
-	zs_exit();
-	return notifier_to_errno(ret);
 }
 
 static unsigned int get_maxobj_per_zspage(int size, int pages_per_zspage)
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

