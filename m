From: akpm@linux-foundation.org
Subject: [merged]
 kernel-remove-config_use_generic_smp_helpers-cleanly.patch removed from -mm tree
Date: Fri, 22 Nov 2013 13:21:51 -0800
Message-ID: <528fcaef.wF2D7N6QeLYUCZot%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3KVVVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:21:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hch@infradead.org, yuanhan.liu@linux.intel.com

Subject: [merged] kernel-remove-config_use_generic_smp_helpers-cleanly.patch removed from -mm tree
To: yuanhan.liu@linux.intel.com,hch@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:21:51 -0800


The patch titled
     Subject: kernel: remove CONFIG_USE_GENERIC_SMP_HELPERS cleanly
has been removed from the -mm tree.  Its filename was
     kernel-remove-config_use_generic_smp_helpers-cleanly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: kernel: remove CONFIG_USE_GENERIC_SMP_HELPERS cleanly

Remove CONFIG_USE_GENERIC_SMP_HELPERS left by commit
0a06ff06 ("kernel: remove CONFIG_USE_GENERIC_SMP_HELPERS").

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/null_blk.c |    8 ++++----
 net/Kconfig              |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/block/null_blk.c~kernel-remove-config_use_generic_smp_helpers-cleanly drivers/block/null_blk.c
--- a/drivers/block/null_blk.c~kernel-remove-config_use_generic_smp_helpers-cleanly
+++ a/drivers/block/null_blk.c
@@ -223,7 +223,7 @@ static void null_softirq_done_fn(struct
 	blk_end_request_all(rq, 0);
 }
 
-#if defined(CONFIG_SMP) && defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#ifdef CONFIG_SMP
 
 static void null_ipi_cmd_end_io(void *data)
 {
@@ -260,7 +260,7 @@ static void null_cmd_end_ipi(struct null
 	put_cpu();
 }
 
-#endif /* CONFIG_SMP && CONFIG_USE_GENERIC_SMP_HELPERS */
+#endif /* CONFIG_SMP */
 
 static inline void null_handle_cmd(struct nullb_cmd *cmd)
 {
@@ -270,7 +270,7 @@ static inline void null_handle_cmd(struc
 		end_cmd(cmd);
 		break;
 	case NULL_IRQ_SOFTIRQ:
-#if defined(CONFIG_SMP) && defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#ifdef CONFIG_SMP
 		null_cmd_end_ipi(cmd);
 #else
 		end_cmd(cmd);
@@ -571,7 +571,7 @@ static int __init null_init(void)
 {
 	unsigned int i;
 
-#if !defined(CONFIG_SMP) || !defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#if !defined(CONFIG_SMP)
 	if (irqmode == NULL_IRQ_SOFTIRQ) {
 		pr_warn("null_blk: softirq completions not available.\n");
 		pr_warn("null_blk: using direct completions.\n");
diff -puN net/Kconfig~kernel-remove-config_use_generic_smp_helpers-cleanly net/Kconfig
--- a/net/Kconfig~kernel-remove-config_use_generic_smp_helpers-cleanly
+++ a/net/Kconfig
@@ -224,7 +224,7 @@ source "net/hsr/Kconfig"
 
 config RPS
 	boolean
-	depends on SMP && SYSFS && USE_GENERIC_SMP_HELPERS
+	depends on SMP && SYSFS
 	default y
 
 config RFS_ACCEL
@@ -235,7 +235,7 @@ config RFS_ACCEL
 
 config XPS
 	boolean
-	depends on SMP && USE_GENERIC_SMP_HELPERS
+	depends on SMP
 	default y
 
 config NETPRIO_CGROUP
_

Patches currently in -mm which might be from yuanhan.liu@linux.intel.com are

origin.patch

