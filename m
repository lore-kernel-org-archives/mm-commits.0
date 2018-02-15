From: akpm@linux-foundation.org
Subject: + mm-re-use-define_show_attribute-macro.patch added to -mm tree
Date: Wed, 14 Feb 2018 16:23:33 -0800
Message-ID: <5a84d305.3vFDeL/NYbGvf5ql%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46320 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032127AbeBOAXf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Feb 2018 19:23:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org, cl@linux.com, dennisszhou@gmail.com, mawilcox@microsoft.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reuse DEFINE_SHOW_ATTRIBUTE() macro
has been added to the -mm tree.  Its filename is
     mm-re-use-define_show_attribute-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-re-use-define_show_attribute-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-re-use-define_show_attribute-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: mm: reuse DEFINE_SHOW_ATTRIBUTE() macro

...instead of open coding file operations followed by custom ->open()
callbacks per each attribute.

Link: http://lkml.kernel.org/r/20180214154644.54505-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennisszhou@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c  |   12 +-----------
 mm/memblock.c     |   12 +-----------
 mm/percpu-stats.c |   12 +-----------
 mm/zsmalloc.c     |   12 +-----------
 4 files changed, 4 insertions(+), 44 deletions(-)

diff -puN mm/backing-dev.c~mm-re-use-define_show_attribute-macro mm/backing-dev.c
--- a/mm/backing-dev.c~mm-re-use-define_show_attribute-macro
+++ a/mm/backing-dev.c
@@ -101,17 +101,7 @@ static int bdi_debug_stats_show(struct s
 	return 0;
 }
 
-static int bdi_debug_stats_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, bdi_debug_stats_show, inode->i_private);
-}
-
-static const struct file_operations bdi_debug_stats_fops = {
-	.open		= bdi_debug_stats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(bdi_debug_stats);
 
 static int bdi_debug_register(struct backing_dev_info *bdi, const char *name)
 {
diff -puN mm/memblock.c~mm-re-use-define_show_attribute-macro mm/memblock.c
--- a/mm/memblock.c~mm-re-use-define_show_attribute-macro
+++ a/mm/memblock.c
@@ -1824,17 +1824,7 @@ static int memblock_debug_show(struct se
 	return 0;
 }
 
-static int memblock_debug_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, memblock_debug_show, inode->i_private);
-}
-
-static const struct file_operations memblock_debug_fops = {
-	.open = memblock_debug_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(memblock_debug);
 
 static int __init memblock_init_debugfs(void)
 {
diff -puN mm/percpu-stats.c~mm-re-use-define_show_attribute-macro mm/percpu-stats.c
--- a/mm/percpu-stats.c~mm-re-use-define_show_attribute-macro
+++ a/mm/percpu-stats.c
@@ -224,17 +224,7 @@ alloc_buffer:
 	return 0;
 }
 
-static int percpu_stats_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, percpu_stats_show, NULL);
-}
-
-static const struct file_operations percpu_stats_fops = {
-	.open		= percpu_stats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(percpu_stats);
 
 static int __init init_percpu_stats_debugfs(void)
 {
diff -puN mm/zsmalloc.c~mm-re-use-define_show_attribute-macro mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-re-use-define_show_attribute-macro
+++ a/mm/zsmalloc.c
@@ -642,17 +642,7 @@ static int zs_stats_size_show(struct seq
 	return 0;
 }
 
-static int zs_stats_size_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, zs_stats_size_show, inode->i_private);
-}
