From: akpm@linux-foundation.org
Subject: - introduce-u16_max-and-u32_max.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:42:01 -0700
Message-ID: <200708250342.l7P3g1t1028691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56158 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbXHYDmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:42:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Introduce U16_MAX and U32_MAX
has been removed from the -mm tree.  Its filename was
     introduce-u16_max-and-u32_max.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: Introduce U16_MAX and U32_MAX
From: Satyam Sharma <satyam@infradead.org>

... in kernel.h and clean up home-grown macros elsewhere in the tree.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netconsole.c    |    7 +++----
 include/linux/kernel.h      |    3 +++
 include/linux/reiserfs_fs.h |    2 --
 net/ipv4/tcp_illinois.c     |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/net/netconsole.c~introduce-u16_max-and-u32_max drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~introduce-u16_max-and-u32_max
+++ a/drivers/net/netconsole.c
@@ -34,6 +34,7 @@
  *
  ****************************************************************/
 
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -389,7 +390,6 @@ static ssize_t store_local_port(struct n
 				size_t count)
 {
 	long local_port;
-#define __U16_MAX	((__u16) ~0U)
 
 	if (nt->enabled) {
 		printk(KERN_ERR "netconsole: target (%s) is enabled, "
@@ -398,7 +398,7 @@ static ssize_t store_local_port(struct n
 		return -EINVAL;
 	}
 
-	local_port = strtol10_check_range(buf, 0, __U16_MAX);
+	local_port = strtol10_check_range(buf, 0, U16_MAX);
 	if (local_port < 0)
 		return local_port;
 
@@ -412,7 +412,6 @@ static ssize_t store_remote_port(struct 
 				 size_t count)
 {
 	long remote_port;
-#define __U16_MAX	((__u16) ~0U)
 
 	if (nt->enabled) {
 		printk(KERN_ERR "netconsole: target (%s) is enabled, "
@@ -421,7 +420,7 @@ static ssize_t store_remote_port(struct 
 		return -EINVAL;
 	}
 
-	remote_port = strtol10_check_range(buf, 0, __U16_MAX);
+	remote_port = strtol10_check_range(buf, 0, U16_MAX);
 	if (remote_port < 0)
 		return remote_port;
 
diff -puN include/linux/kernel.h~introduce-u16_max-and-u32_max include/linux/kernel.h
--- a/include/linux/kernel.h~introduce-u16_max-and-u32_max
+++ a/include/linux/kernel.h
@@ -30,6 +30,9 @@ extern const char linux_proc_banner[];
 #define LLONG_MIN	(-LLONG_MAX - 1)
 #define ULLONG_MAX	(~0ULL)
 
+#define U16_MAX		(~(__u16)0)
+#define U32_MAX		(~(__u32)0)
+
 #define STACK_MAGIC	0xdeadbeef
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
diff -puN include/linux/reiserfs_fs.h~introduce-u16_max-and-u32_max include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~introduce-u16_max-and-u32_max
+++ a/include/linux/reiserfs_fs.h
@@ -1225,8 +1225,6 @@ struct treepath var = {.path_length = IL
 #define MAX_US_INT 0xffff
 
 // reiserfs version 2 has max offset 60 bits. Version 1 - 32 bit offset
-#define U32_MAX (~(__u32)0)
-
 static inline loff_t max_reiserfs_offset(struct inode *inode)
 {
 	if (get_inode_item_key_version(inode) == KEY_FORMAT_3_5)
diff -puN net/ipv4/tcp_illinois.c~introduce-u16_max-and-u32_max net/ipv4/tcp_illinois.c
--- a/net/ipv4/tcp_illinois.c~introduce-u16_max-and-u32_max
+++ a/net/ipv4/tcp_illinois.c
@@ -12,6 +12,7 @@
  * Copyright (C) 2007 Stephen Hemminger <shemminger@linux-foundation.org>
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/inet_diag.h>
@@ -23,7 +24,6 @@
 #define ALPHA_MIN	((3*ALPHA_SCALE)/10)	/* ~0.3 */
 #define ALPHA_MAX	(10*ALPHA_SCALE)	/* 10.0 */
 #define ALPHA_BASE	ALPHA_SCALE		/* 1.0 */
-#define U32_MAX		((u32)~0U)
 #define RTT_MAX		(U32_MAX / ALPHA_MAX)	/* 3.3 secs */
 
 #define BETA_SHIFT	6
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
hwmon-coretemp-remove-bogus-__cpuinitdata-etc-cleanup.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
git-net.patch
git-s390.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
