From: akpm@linux-foundation.org
Subject: [merged] dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:30 -0800
Message-ID: <200912152150.nBFLoUAY014964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934024AbZLOWVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:21:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ak@linux.intel.com, avi@qumranet.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de, johannes@sipsolutions.net, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     /dev/mem: cleanup unxlate_dev_mem_ptr() calls
has been removed from the -mm tree.  Its filename was
     dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /dev/mem: cleanup unxlate_dev_mem_ptr() calls
From: Wu Fengguang <fengguang.wu@intel.com>

No behaviour change.

[akpm@linux-foundation.org: cleanuplets]
[akpm@linux-foundation.org: remove unused `ret']
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-cleanup-unxlate_dev_mem_ptr-calls drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-cleanup-unxlate_dev_mem_ptr-calls
+++ a/drivers/char/mem.c
@@ -154,6 +154,8 @@ static ssize_t read_mem(struct file * fi
 #endif
 
 	while (count > 0) {
+		unsigned long remaining;
+
 		sz = size_inside_page(p, count);
 
 		if (!range_is_allowed(p >> PAGE_SHIFT, count))
@@ -168,12 +170,10 @@ static ssize_t read_mem(struct file * fi
 		if (!ptr)
 			return -EFAULT;
 
-		if (copy_to_user(buf, ptr, sz)) {
-			unxlate_dev_mem_ptr(p, ptr);
-			return -EFAULT;
-		}
-
+		remaining = copy_to_user(buf, ptr, sz);
 		unxlate_dev_mem_ptr(p, ptr);
+		if (remaining)
+			return -EFAULT;
 
 		buf += sz;
 		p += sz;
@@ -231,16 +231,14 @@ static ssize_t write_mem(struct file * f
 		}
 
 		copied = copy_from_user(ptr, buf, sz);
+		unxlate_dev_mem_ptr(p, ptr);
 		if (copied) {
 			written += sz - copied;
-			unxlate_dev_mem_ptr(p, ptr);
 			if (written)
 				break;
 			return -EFAULT;
 		}
 
-		unxlate_dev_mem_ptr(p, ptr);
