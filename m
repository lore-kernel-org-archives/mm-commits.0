From: akpm@linux-foundation.org
Subject: + mm-clarify-__gfp_nofail-deprecation-status.patch added to -mm
 tree
Date: Mon, 02 Mar 2015 16:17:02 -0800
Message-ID: <54f4fd7e.QlsF4TpJtEpC5qoD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbbCCARE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 19:17:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, davem@davemloft.net, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tytso@mit.edu, vipul@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify __GFP_NOFAIL deprecation status
has been added to the -mm tree.  Its filename is
     mm-clarify-__gfp_nofail-deprecation-status.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clarify-__gfp_nofail-deprecation-status.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clarify-__gfp_nofail-deprecation-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: clarify __GFP_NOFAIL deprecation status

__GFP_NOFAIL is documented as a deprecated flag since 478352e789f5 (mm:
add comment about deprecation of __GFP_NOFAIL).  This has discouraged
people from using it but in some cases an opencoded endless loop around
allocator has been used instead.  So the allocator is not aware of the de
facto __GFP_NOFAIL allocation because this information was not
communicated properly.

Let's make clear that if the allocation context really cannot effort
failure because there is no good failure policy then using __GFP_NOFAIL is
preferable to opencoding the loop outside of the allocator.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Vipul Pandya <vipul@chelsio.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-clarify-__gfp_nofail-deprecation-status include/linux/gfp.h
--- a/include/linux/gfp.h~mm-clarify-__gfp_nofail-deprecation-status
+++ a/include/linux/gfp.h
@@ -57,8 +57,10 @@ struct vm_area_struct;
  * _might_ fail.  This depends upon the particular VM implementation.
  *
  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
- * cannot handle allocation failures.  This modifier is deprecated and no new
- * users should be added.
+ * cannot handle allocation failures. New users should be evaluated carefuly
+ * (and the flag should be used only when there is no reasonable failure policy)
+ * but it is definitely preferable to use the flag rather than opencode endless
+ * loop around allocator.
  *
  * __GFP_NORETRY: The VM implementation must not retry indefinitely.
  *
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-oom-do-not-fail-__gfp_nofail-allocation-if-oom-killer-is-disbaled.patch
mm-memcontrol-update-copyright-notice.patch
mm-cma-release-trigger-fixpatch.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
fork-report-pid-reservation-failure-properly.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
sparc-clarify-__gfp_nofail-allocation.patch
cxgb4-drop-__gfp_nofail-allocation.patch

