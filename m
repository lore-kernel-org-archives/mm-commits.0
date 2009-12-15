From: akpm@linux-foundation.org
Subject: [merged] dev-mem-introduce-size_inside_page.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:27 -0800
Message-ID: <200912152150.nBFLoRs1014961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761123AbZLOVwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ak@linux.intel.com, avi@qumranet.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de, johannes@sipsolutions.net, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     /dev/mem: introduce size_inside_page()
has been removed from the -mm tree.  Its filename was
     dev-mem-introduce-size_inside_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /dev/mem: introduce size_inside_page()
From: Wu Fengguang <fengguang.wu@intel.com>

Introduce size_inside_page() to replace duplicate /dev/mem code.

Also apply it to /dev/kmem, whose alignment logic was buggy.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   60 +++++++++++++------------------------------
 1 file changed, 19 insertions(+), 41 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-introduce-size_inside_page drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-introduce-size_inside_page
+++ a/drivers/char/mem.c
@@ -34,6 +34,19 @@
 # include <linux/efi.h>
 #endif
 
+static inline unsigned long size_inside_page(unsigned long start,
+					     unsigned long size)
+{
+	unsigned long sz;
+
+	if (-start & (PAGE_SIZE - 1))
+		sz = -start & (PAGE_SIZE - 1);
+	else
+		sz = PAGE_SIZE;
+
+	return min_t(unsigned long, sz, size);
+}
+
 /*
  * Architectures vary in how they handle caching for addresses
  * outside of main memory.
@@ -141,15 +154,7 @@ static ssize_t read_mem(struct file * fi
 #endif
 
 	while (count > 0) {
-		/*
-		 * Handle first page in case it's not aligned
-		 */
-		if (-p & (PAGE_SIZE - 1))
-			sz = -p & (PAGE_SIZE - 1);
-		else
-			sz = PAGE_SIZE;
-
-		sz = min_t(unsigned long, sz, count);
+		sz = size_inside_page(p, count);
 
 		if (!range_is_allowed(p >> PAGE_SHIFT, count))
 			return -EPERM;
@@ -208,15 +213,7 @@ static ssize_t write_mem(struct file * f
 #endif
 
 	while (count > 0) {
-		/*
-		 * Handle first page in case it's not aligned
-		 */
-		if (-p & (PAGE_SIZE - 1))
-			sz = -p & (PAGE_SIZE - 1);
-		else
-			sz = PAGE_SIZE;
-
-		sz = min_t(unsigned long, sz, count);
+		sz = size_inside_page(p, count);
 
 		if (!range_is_allowed(p >> PAGE_SHIFT, sz))
 			return -EPERM;
@@ -429,15 +426,7 @@ static ssize_t read_kmem(struct file *fi
 		}
 #endif
 		while (low_count > 0) {
-			/*
-			 * Handle first page in case it's not aligned
-			 */
-			if (-p & (PAGE_SIZE - 1))
-				sz = -p & (PAGE_SIZE - 1);
-			else
-				sz = PAGE_SIZE;
-
-			sz = min_t(unsigned long, sz, low_count);
+			sz = size_inside_page(p, low_count);
 
 			/*
 			 * On ia64 if a page has been mapped somewhere as
@@ -461,10 +450,8 @@ static ssize_t read_kmem(struct file *fi
 		if (!kbuf)
 			return -ENOMEM;
 		while (count > 0) {
-			int len = count;
+			int len = size_inside_page(p, count);
 
-			if (len > PAGE_SIZE)
-				len = PAGE_SIZE;
 			len = vread(kbuf, (char *)p, len);
 			if (!len)
 				break;
@@ -509,15 +496,8 @@ do_write_kmem(void *p, unsigned long rea
 
 	while (count > 0) {
 		char *ptr;
-		/*
-		 * Handle first page in case it's not aligned
-		 */
-		if (-realp & (PAGE_SIZE - 1))
-			sz = -realp & (PAGE_SIZE - 1);
-		else
-			sz = PAGE_SIZE;
 
-		sz = min_t(unsigned long, sz, count);
+		sz = size_inside_page(realp, count);
 
 		/*
 		 * On ia64 if a page has been mapped somewhere as
@@ -577,10 +557,8 @@ static ssize_t write_kmem(struct file * 
 		if (!kbuf)
 			return wrote ? wrote : -ENOMEM;
 		while (count > 0) {
-			int len = count;
+			int len = size_inside_page(p, count);
 
-			if (len > PAGE_SIZE)
-				len = PAGE_SIZE;
 			written = copy_from_user(kbuf, buf, len);
 			if (written) {
 				if (wrote + virtr)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch

