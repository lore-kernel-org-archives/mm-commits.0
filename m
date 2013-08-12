From: akpm@linux-foundation.org
Subject: + pagemap-fix-buffer-overflow-in-add_page_map.patch added to -mm
 tree
Date: Mon, 12 Aug 2013 16:05:45 -0700
Message-ID: <52096a49.AzwTzCQLKgs7/bAw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3HLXFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Aug 2013 19:05:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younghua.zheng@gmail.com

Subject: + pagemap-fix-buffer-overflow-in-add_page_map.patch added to -mm tree
To: younghua.zheng@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 12 Aug 2013 16:05:45 -0700


The patch titled
     Subject: fs/proc/task_mmu.c: fix buffer overflow in add_page_map()
has been added to the -mm tree.  Its filename is
     pagemap-fix-buffer-overflow-in-add_page_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagemap-fix-buffer-overflow-in-add_page_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagemap-fix-buffer-overflow-in-add_page_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Yonghua Zheng <younghua.zheng@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-fix-buffer-overflow-in-add_page_map fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-fix-buffer-overflow-in-add_page_map
+++ a/fs/proc/task_mmu.c
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

pagemap-fix-buffer-overflow-in-add_page_map.patch
pagemap-fix-buffer-overflow-in-add_page_map-fix.patch

