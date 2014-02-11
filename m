From: akpm@linux-foundation.org
Subject: + jffs2-remove-wait-queue-after-schedule.patch added to -mm tree
Date: Tue, 11 Feb 2014 15:56:28 -0800
Message-ID: <52fab8ac.8jy3j+ObwmvnBkev%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaBKX43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 18:56:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, dwmw2@infradead.org, lizefan@huawei.com

Subject: + jffs2-remove-wait-queue-after-schedule.patch added to -mm tree
To: lizefan@huawei.com,dwmw2@infradead.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 15:56:28 -0800


The patch titled
     Subject: jffs2: remove wait queue after schedule()
has been added to the -mm tree.  Its filename is
     jffs2-remove-wait-queue-after-schedule.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jffs2-remove-wait-queue-after-schedule.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jffs2-remove-wait-queue-after-schedule.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: jffs2: remove wait queue after schedule()

@wait is a local variable, so if we don't remove it from the wait queue
list, later wake_up() may end up accessing invalid memory.

This was spotted by eyes.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
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

jffs2-fix-unbalanced-locking.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix.patch
jffs2-remove-wait-queue-after-schedule.patch
linux-next.patch

