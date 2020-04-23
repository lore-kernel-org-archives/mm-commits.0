From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-return-eintr-when-gup-is-interrupted-by-fatal-signals.patch removed
 from -mm tree
Date: Thu, 23 Apr 2020 12:51:39 -0700
Message-ID: <20200423195139.Tn1oU5HKH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728122AbgDWTvk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 15:51:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org, peterx@redhat.com, torvalds@linux-foundation.org


The patch titled
     Subject: mm, gup: return EINTR when gup is interrupted by fatal signals
has been removed from the -mm tree.  Its filename was
     mm-gup-return-eintr-when-gup-is-interrupted-by-fatal-signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, gup: return EINTR when gup is interrupted by fatal signals

EINTR is the usual error code which other killable interfaces return. 
This is the case for the other fatal_signal_pending break out from the
same function.  Make the code consistent.

ERESTARTSYS is also quite confusing because the signal is fatal and so no
restart will happen before returning to the userspace.

Link: http://lkml.kernel.org/r/20200409071133.31734-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-return-eintr-when-gup-is-interrupted-by-fatal-signals
+++ a/mm/gup.c
@@ -1088,7 +1088,7 @@ retry:
 		 * potentially allocating memory.
 		 */
 		if (fatal_signal_pending(current)) {
-			ret = -ERESTARTSYS;
+			ret = -EINTR;
 			goto out;
 		}
 		cond_resched();
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-clarify-__gfp_memalloc-usage.patch
