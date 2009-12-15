From: akpm@linux-foundation.org
Subject: [merged] dev-mem-make-size_inside_page-logic-straight.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:33 -0800
Message-ID: <200912152150.nBFLoX89014967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761089AbZLOVwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ak@linux.intel.com, avi@qumranet.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de, johannes@sipsolutions.net, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     /dev/mem: make size_inside_page() logic straight
has been removed from the -mm tree.  Its filename was
     dev-mem-make-size_inside_page-logic-straight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /dev/mem: make size_inside_page() logic straight
From: Wu Fengguang <fengguang.wu@intel.com>

Also convert more size_inside_page() users.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-make-size_inside_page-logic-straight drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-make-size_inside_page-logic-straight
+++ a/drivers/char/mem.c
@@ -39,12 +39,9 @@ static inline unsigned long size_inside_
 {
 	unsigned long sz;
 
-	if (-start & (PAGE_SIZE - 1))
-		sz = -start & (PAGE_SIZE - 1);
-	else
-		sz = PAGE_SIZE;
+	sz = PAGE_SIZE - (start & (PAGE_SIZE - 1));
 
-	return min_t(unsigned long, sz, size);
+	return min(sz, size);
 }
 
 /*
@@ -139,9 +136,7 @@ static ssize_t read_mem(struct file * fi
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
 	if (p < PAGE_SIZE) {
-		sz = PAGE_SIZE - p;
-		if (sz > count) 
-			sz = count; 
+		sz = size_inside_page(p, count);
 		if (sz > 0) {
 			if (clear_user(buf, sz))
 				return -EFAULT;
@@ -201,9 +196,7 @@ static ssize_t write_mem(struct file * f
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
 	if (p < PAGE_SIZE) {
-		unsigned long sz = PAGE_SIZE - p;
-		if (sz > count)
-			sz = count;
+		sz = size_inside_page(p, count);
 		/* Hmm. Do something? */
 		buf += sz;
 		p += sz;
@@ -412,15 +405,14 @@ static ssize_t read_kmem(struct file *fi
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 		/* we don't have page 0 mapped on sparc and m68k.. */
 		if (p < PAGE_SIZE && low_count > 0) {
-			size_t tmp = PAGE_SIZE - p;
-			if (tmp > low_count) tmp = low_count;
-			if (clear_user(buf, tmp))
+			sz = size_inside_page(p, low_count);
+			if (clear_user(buf, sz))
 				return -EFAULT;
-			buf += tmp;
-			p += tmp;
-			read += tmp;
-			low_count -= tmp;
-			count -= tmp;
+			buf += sz;
+			p += sz;
+			read += sz;
+			low_count -= sz;
+			count -= sz;
 		}
 #endif
 		while (low_count > 0) {
@@ -480,9 +472,7 @@ do_write_kmem(void *p, unsigned long rea
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
 	if (realp < PAGE_SIZE) {
-		unsigned long sz = PAGE_SIZE - realp;
-		if (sz > count)
-			sz = count;
+		sz = size_inside_page(realp, count);
 		/* Hmm. Do something? */
 		buf += sz;
 		p += sz;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch

