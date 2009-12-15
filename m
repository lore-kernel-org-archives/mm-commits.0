From: akpm@linux-foundation.org
Subject: [merged] dev-mem-remove-redundant-parameter-from-do_write_kmem.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:39 -0800
Message-ID: <200912152150.nBFLodJI014973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761160AbZLOVwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ak@linux.intel.com, avi@qumranet.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de, johannes@sipsolutions.net, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     /dev/mem: remove redundant parameter from do_write_kmem()
has been removed from the -mm tree.  Its filename was
     dev-mem-remove-redundant-parameter-from-do_write_kmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /dev/mem: remove redundant parameter from do_write_kmem()
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-remove-redundant-parameter-from-do_write_kmem drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-remove-redundant-parameter-from-do_write_kmem
+++ a/drivers/char/mem.c
@@ -461,7 +461,7 @@ static ssize_t read_kmem(struct file *fi
 
 
 static inline ssize_t
-do_write_kmem(void *p, unsigned long realp, const char __user * buf,
+do_write_kmem(unsigned long p, const char __user *buf,
 	      size_t count, loff_t *ppos)
 {
 	ssize_t written, sz;
@@ -470,12 +470,11 @@ do_write_kmem(void *p, unsigned long rea
 	written = 0;
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
-	if (realp < PAGE_SIZE) {
-		sz = size_inside_page(realp, count);
+	if (p < PAGE_SIZE) {
+		sz = size_inside_page(p, count);
 		/* Hmm. Do something? */
 		buf += sz;
 		p += sz;
-		realp += sz;
 		count -= sz;
 		written += sz;
 	}
@@ -484,14 +483,14 @@ do_write_kmem(void *p, unsigned long rea
 	while (count > 0) {
 		char *ptr;
 
-		sz = size_inside_page(realp, count);
+		sz = size_inside_page(p, count);
 
 		/*
 		 * On ia64 if a page has been mapped somewhere as
 		 * uncached, then it must also be accessed uncached
 		 * by the kernel or data corruption may occur
 		 */
-		ptr = xlate_dev_kmem_ptr(p);
+		ptr = xlate_dev_kmem_ptr((char *)p);
 
 		copied = copy_from_user(ptr, buf, sz);
 		if (copied) {
@@ -502,7 +501,6 @@ do_write_kmem(void *p, unsigned long rea
 		}
 		buf += sz;
 		p += sz;
-		realp += sz;
 		count -= sz;
 		written += sz;
 	}
@@ -526,7 +524,7 @@ static ssize_t write_kmem(struct file * 
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
 					       (unsigned long)high_memory - p);
-		wrote = do_write_kmem((void *)p, p, buf, to_write, ppos);
+		wrote = do_write_kmem(p, buf, to_write, ppos);
 		if (wrote != to_write)
 			return wrote;
 		p += wrote;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch

