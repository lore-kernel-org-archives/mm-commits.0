From: akpm@linux-foundation.org
Subject: [merged] jffs2-remove-wait-queue-after-schedule.patch removed
 from -mm tree
Date: Thu, 27 Feb 2014 12:24:08 -0800
Message-ID: <530f9ee8.os8YhZA2tL8ahQgD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaB0UYJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 15:24:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, dwmw2@infradead.org, computersforpeace@gmail.com, artem.bityutskiy@linux.intel.com, lizefan@huawei.com

Subject: [merged] jffs2-remove-wait-queue-after-schedule.patch removed from -mm tree
To: lizefan@huawei.com,artem.bityutskiy@linux.intel.com,computersforpeace@gmail.com,dwmw2@infradead.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 12:24:08 -0800


The patch titled
     Subject: jffs2: remove wait queue after schedule()
has been removed from the -mm tree.  Its filename was
     jffs2-remove-wait-queue-after-schedule.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: jffs2: remove wait queue after schedule()

@wait is a local variable, so if we don't remove it from the wait queue
list, later wake_up() may end up accessing invalid memory.

This was spotted by eyes.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/nodemgmt.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/jffs2/nodemgmt.c~jffs2-remove-wait-queue-after-schedule fs/jffs2/nodemgmt.c
--- a/fs/jffs2/nodemgmt.c~jffs2-remove-wait-queue-after-schedule
+++ a/fs/jffs2/nodemgmt.c
@@ -179,6 +179,7 @@ int jffs2_reserve_space(struct jffs2_sb_
 					spin_unlock(&c->erase_completion_lock);
 
 					schedule();
+					remove_wait_queue(&c->erase_wait, &wait);
 				} else
 					spin_unlock(&c->erase_completion_lock);
 			} else if (ret)
_

Patches currently in -mm which might be from lizefan@huawei.com are

linux-next.patch

