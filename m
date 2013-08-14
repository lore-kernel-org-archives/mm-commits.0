From: akpm@linux-foundation.org
Subject: [merged] pagemap-fix-buffer-overflow-in-add_page_map.patch
 removed from -mm tree
Date: Wed, 14 Aug 2013 12:35:50 -0700
Message-ID: <520bdc16.aa9yGO8AaPu4+MGo%akpm__28405.5359931246$1376508967$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab3HNTfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 15:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, younghua.zheng@gmail.com

Subject: [merged] pagemap-fix-buffer-overflow-in-add_page_map.patch removed from -mm tree
To: younghua.zheng@gmail.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 12:35:50 -0700


The patch titled
     Subject: fs/proc/task_mmu.c: fix buffer overflow in add_page_map()
has been removed from the -mm tree.  Its filename was
     pagemap-fix-buffer-overflow-in-add_page_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: yonghua zheng <younghua.zheng@gmail.com>
Subject: fs/proc/task_mmu.c: fix buffer overflow in add_page_map()

Recently we met quite a lot of random kernel panic issues after enabling
CONFIG_PROC_PAGE_MONITOR.  After debuggind we found this has something to
do with following bug in pagemap:

In struct pagemapread:

struct pagemapread {
    int pos, len;
    pagemap_entry_t *buffer;
    bool v2;
};

pos is number of PM_ENTRY_BYTES in buffer, but len is the size of buffer,
it is a mistake to compare pos and len in add_page_map() for checking
buffer is full or not, and this can lead to buffer overflow and random
kernel panic issue.

Correct len to be total number of PM_ENTRY_BYTES in buffer.

[akpm@linux-foundation.org: document pagemapread.pos and .len units, fix PM_ENTRY_BYTES definition]
Signed-off-by: Yonghua Zheng <younghua.zheng@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-fix-buffer-overflow-in-add_page_map fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-fix-buffer-overflow-in-add_page_map
+++ a/fs/proc/task_mmu.c
@@ -868,7 +868,7 @@ typedef struct {
 } pagemap_entry_t;
 
 struct pagemapread {
-	int pos, len;
+	int pos, len;		/* units: PM_ENTRY_BYTES, not bytes */
 	pagemap_entry_t *buffer;
 	bool v2;
 };
@@ -876,7 +876,7 @@ struct pagemapread {
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
 #define PAGEMAP_WALK_MASK	(PMD_MASK)
 
-#define PM_ENTRY_BYTES      sizeof(u64)
+#define PM_ENTRY_BYTES      sizeof(pagemap_entry_t)
 #define PM_STATUS_BITS      3
 #define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
 #define PM_STATUS_MASK      (((1LL << PM_STATUS_BITS) - 1) << PM_STATUS_OFFSET)
@@ -1127,8 +1127,8 @@ static ssize_t pagemap_read(struct file
 		goto out_task;
 
 	pm.v2 = soft_dirty_cleared;
-	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
-	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
+	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
+	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
 	ret = -ENOMEM;
 	if (!pm.buffer)
 		goto out_task;
_

Patches currently in -mm which might be from younghua.zheng@gmail.com are

origin.patch

