From: akpm@linux-foundation.org
Subject: [merged]
 mm-writeback-prevent-race-when-calculating-dirty-limits.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:05:59 -0700
Message-ID: <53e3dc27.qJK53S+8HjpLeQ2R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:36606 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaHGUGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:00 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1176033pdj.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, writeback: prevent race when calculating dirty limits
has been removed from the -mm tree.  Its filename was
     mm-writeback-prevent-race-when-calculating-dirty-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, writeback: prevent race when calculating dirty limits

Setting vm_dirty_bytes and dirty_background_bytes is not protected by any
serialization.

Therefore, it's possible for either variable to change value after the
test in global_dirty_limits() to determine whether available_memory needs
to be initialized or not.

Always ensure that available_memory is properly initialized.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/page-writeback.c~mm-writeback-prevent-race-when-calculating-dirty-limits mm/page-writeback.c
--- a/mm/page-writeback.c~mm-writeback-prevent-race-when-calculating-dirty-limits
+++ a/mm/page-writeback.c
@@ -261,14 +261,11 @@ static unsigned long global_dirtyable_me
  */
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 {
+	const unsigned long available_memory = global_dirtyable_memory();
 	unsigned long background;
 	unsigned long dirty;
-	unsigned long uninitialized_var(available_memory);
 	struct task_struct *tsk;
 
-	if (!vm_dirty_bytes || !dirty_background_bytes)
-		available_memory = global_dirtyable_memory();
