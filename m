From: akpm@linux-foundation.org
Subject: [merged] dev-mem-remove-the-written-variable-in-write_kmem.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:36 -0800
Message-ID: <200912152150.nBFLoa1e014970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760759AbZLOVwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ak@linux.intel.com, avi@qumranet.com, broonie@opensource.wolfsonmicro.com, gregkh@suse.de, johannes@sipsolutions.net, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     /dev/mem: remove the "written" variable in write_kmem()
has been removed from the -mm tree.  Its filename was
     dev-mem-remove-the-written-variable-in-write_kmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /dev/mem: remove the "written" variable in write_kmem()
From: Wu Fengguang <fengguang.wu@intel.com>

Also rename "len" to "sz". No behavior change.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   49 +++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-remove-the-written-variable-in-write_kmem drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-remove-the-written-variable-in-write_kmem
+++ a/drivers/char/mem.c
@@ -440,19 +440,18 @@ static ssize_t read_kmem(struct file *fi
 		if (!kbuf)
 			return -ENOMEM;
 		while (count > 0) {
-			int len = size_inside_page(p, count);
-
-			len = vread(kbuf, (char *)p, len);
-			if (!len)
+			sz = size_inside_page(p, count);
+			sz = vread(kbuf, (char *)p, sz);
+			if (!sz)
 				break;
-			if (copy_to_user(buf, kbuf, len)) {
+			if (copy_to_user(buf, kbuf, sz)) {
 				free_page((unsigned long)kbuf);
 				return -EFAULT;
 			}
-			count -= len;
-			buf += len;
-			read += len;
-			p += len;
+			count -= sz;
+			buf += sz;
+			read += sz;
+			p += sz;
 		}
 		free_page((unsigned long)kbuf);
 	}
@@ -522,19 +521,14 @@ static ssize_t write_kmem(struct file * 
 	unsigned long p = *ppos;
 	ssize_t wrote = 0;
 	ssize_t virtr = 0;
-	ssize_t written;
 	char * kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
 
 	if (p < (unsigned long) high_memory) {
-
-		wrote = count;
-		if (count > (unsigned long) high_memory - p)
-			wrote = (unsigned long) high_memory - p;
-
-		written = do_write_kmem((void*)p, p, buf, wrote, ppos);
-		if (written != wrote)
-			return written;
-		wrote = written;
+		unsigned long to_write = min_t(unsigned long, count,
+					       (unsigned long)high_memory - p);
+		wrote = do_write_kmem((void *)p, p, buf, to_write, ppos);
+		if (wrote != to_write)
+			return wrote;
 		p += wrote;
 		buf += wrote;
 		count -= wrote;
@@ -545,20 +539,21 @@ static ssize_t write_kmem(struct file * 
 		if (!kbuf)
 			return wrote ? wrote : -ENOMEM;
 		while (count > 0) {
-			int len = size_inside_page(p, count);
+			unsigned long sz = size_inside_page(p, count);
+			unsigned long n;
 
-			written = copy_from_user(kbuf, buf, len);
-			if (written) {
+			n = copy_from_user(kbuf, buf, sz);
+			if (n) {
 				if (wrote + virtr)
 					break;
 				free_page((unsigned long)kbuf);
 				return -EFAULT;
 			}
-			len = vwrite(kbuf, (char *)p, len);
-			count -= len;
-			buf += len;
-			virtr += len;
-			p += len;
+			sz = vwrite(kbuf, (char *)p, sz);
+			count -= sz;
+			buf += sz;
+			virtr += sz;
+			p += sz;
 		}
 		free_page((unsigned long)kbuf);
 	}
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch

