From: akpm@linux-foundation.org
Subject: [patch 106/114] mtd: nand: nandsim: convert to
 memalloc_noreclaim_*()
Date: Mon, 08 May 2017 15:59:57 -0700
Message-ID: <20170508225957.tildzER9n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47668 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbdEHW76 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@intel.com, akpm@linux-foundation.org, aryabinin@virtuozzo.com, boris.brezillon@free-electrons.com, cleech@redhat.com, davem@davemloft.net, edumazet@google.com, hannes@cmpxchg.org, jbacik@fb.com, lduncan@suse.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, richard@nod.at, torvalds@linux-foundation.org, vbabka@suse.cz

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mtd: nand: nandsim: convert to memalloc_noreclaim_*()

Nandsim has own functions set_memalloc() and clear_memalloc() for robust
setting and clearing of PF_MEMALLOC.  Replace them by the new generic
helpers.  No functional change.

Link: http://lkml.kernel.org/r/20170405074700.29871-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nandsim.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff -puN drivers/mtd/nand/nandsim.c~mtd-nand-nandsim-convert-to-memalloc_noreclaim_ drivers/mtd/nand/nandsim.c
--- a/drivers/mtd/nand/nandsim.c~mtd-nand-nandsim-convert-to-memalloc_noreclaim_
+++ a/drivers/mtd/nand/nandsim.c
@@ -40,6 +40,7 @@
 #include <linux/list.h>
 #include <linux/random.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/seq_file.h>
@@ -1368,31 +1369,18 @@ static int get_pages(struct nandsim *ns,
 	return 0;
 }
 
-static int set_memalloc(void)
-{
-	if (current->flags & PF_MEMALLOC)
-		return 0;
-	current->flags |= PF_MEMALLOC;
-	return 1;
-}
-
-static void clear_memalloc(int memalloc)
-{
-	if (memalloc)
-		current->flags &= ~PF_MEMALLOC;
-}
-
 static ssize_t read_file(struct nandsim *ns, struct file *file, void *buf, size_t count, loff_t pos)
 {
 	ssize_t tx;
-	int err, memalloc;
+	int err;
+	unsigned int noreclaim_flag;
 
 	err = get_pages(ns, file, count, pos);
 	if (err)
 		return err;
-	memalloc = set_memalloc();
+	noreclaim_flag = memalloc_noreclaim_save();
 	tx = kernel_read(file, pos, buf, count);
-	clear_memalloc(memalloc);
+	memalloc_noreclaim_restore(noreclaim_flag);
 	put_pages(ns);
 	return tx;
 }
@@ -1400,14 +1388,15 @@ static ssize_t read_file(struct nandsim
 static ssize_t write_file(struct nandsim *ns, struct file *file, void *buf, size_t count, loff_t pos)
 {
 	ssize_t tx;
-	int err, memalloc;
+	int err;
+	unsigned int noreclaim_flag;
 
 	err = get_pages(ns, file, count, pos);
 	if (err)
 		return err;
-	memalloc = set_memalloc();
+	noreclaim_flag = memalloc_noreclaim_save();
 	tx = kernel_write(file, buf, count, pos);
-	clear_memalloc(memalloc);
+	memalloc_noreclaim_restore(noreclaim_flag);
 	put_pages(ns);
 	return tx;
 }
_
