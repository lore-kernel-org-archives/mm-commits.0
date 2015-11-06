From: akpm@linux-foundation.org
Subject: [merged] mm-vmacache-inline-vmacache_valid_mm.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:15:58 -0800
Message-ID: <563d0a7e.ThB7SDPg/MjbSSEN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033430AbbKFUP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:15:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmacache: inline vmacache_valid_mm()
has been removed from the -mm tree.  Its filename was
     mm-vmacache-inline-vmacache_valid_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/vmacache: inline vmacache_valid_mm()

This function incurs in very hot paths and merely does a few loads for
validity check.  Lets inline it, such that we can save the function call
overhead.

(akpm: this is cosmetic - the compiler already inlines vmacache_valid_mm())

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmacache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmacache.c~mm-vmacache-inline-vmacache_valid_mm mm/vmacache.c
--- a/mm/vmacache.c~mm-vmacache-inline-vmacache_valid_mm
+++ a/mm/vmacache.c
@@ -52,7 +52,7 @@ void vmacache_flush_all(struct mm_struct
  * Also handle the case where a kernel thread has adopted this mm via use_mm().
  * That kernel thread's vmacache is not applicable to this mm.
  */
-static bool vmacache_valid_mm(struct mm_struct *mm)
+static inline bool vmacache_valid_mm(struct mm_struct *mm)
 {
 	return current->mm == mm && !(current->flags & PF_KTHREAD);
 }
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipcmsg-drop-dst-nil-validation-in-copy_msg.patch

