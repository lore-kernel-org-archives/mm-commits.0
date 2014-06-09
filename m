From: akpm@linux-foundation.org
Subject: [merged] mm-kmemleak-testc-use-pr_fmt-for-logging.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:41:21 -0700
Message-ID: <53960de1.R0gAFYpUgj4JhIZj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFITlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, fabf@skynet.be

Subject: [merged] mm-kmemleak-testc-use-pr_fmt-for-logging.patch removed from -mm tree
To: fabf@skynet.be,catalin.marinas@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:41:21 -0700


The patch titled
     Subject: mm/kmemleak-test.c: use pr_fmt for logging
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-testc-use-pr_fmt-for-logging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/kmemleak-test.c: use pr_fmt for logging

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak-test.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff -puN mm/kmemleak-test.c~mm-kmemleak-testc-use-pr_fmt-for-logging mm/kmemleak-test.c
--- a/mm/kmemleak-test.c~mm-kmemleak-testc-use-pr_fmt-for-logging
+++ a/mm/kmemleak-test.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) "kmemleak: " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -50,25 +52,25 @@ static int __init kmemleak_test_init(voi
 	printk(KERN_INFO "Kmemleak testing\n");
 
 	/* make some orphan objects */
-	pr_info("kmemleak: kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
 #ifndef CONFIG_MODULES
-	pr_info("kmemleak: kmem_cache_alloc(files_cachep) = %p\n",
+	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
 		kmem_cache_alloc(files_cachep, GFP_KERNEL));
-	pr_info("kmemleak: kmem_cache_alloc(files_cachep) = %p\n",
+	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
 		kmem_cache_alloc(files_cachep, GFP_KERNEL));
 #endif
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
 
 	/*
 	 * Add elements to a list. They should only appear as orphan
@@ -76,7 +78,7 @@ static int __init kmemleak_test_init(voi
 	 */
 	for (i = 0; i < 10; i++) {
 		elem = kzalloc(sizeof(*elem), GFP_KERNEL);
-		pr_info("kmemleak: kzalloc(sizeof(*elem)) = %p\n", elem);
+		pr_info("kzalloc(sizeof(*elem)) = %p\n", elem);
 		if (!elem)
 			return -ENOMEM;
 		INIT_LIST_HEAD(&elem->list);
@@ -85,7 +87,7 @@ static int __init kmemleak_test_init(voi
 
 	for_each_possible_cpu(i) {
 		per_cpu(kmemleak_test_pointer, i) = kmalloc(129, GFP_KERNEL);
-		pr_info("kmemleak: kmalloc(129) = %p\n",
+		pr_info("kmalloc(129) = %p\n",
 			per_cpu(kmemleak_test_pointer, i));
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

