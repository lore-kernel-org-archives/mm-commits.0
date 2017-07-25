From: akpm@linux-foundation.org
Subject: + lib-interval_tree-fast-overlap-detection-fix.patch added to -mm tree
Date: Tue, 25 Jul 2017 13:03:48 -0700
Message-ID: <5977a424.bmBGU0JRhyPNM0/q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42728 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753561AbdGYUDt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 16:03:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-interval_tree-fast-overlap-detection-fix
has been added to the -mm tree.  Its filename is
     lib-interval_tree-fast-overlap-detection-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-interval_tree-fast-overlap-detection-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-interval_tree-fast-overlap-detection-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib-interval_tree-fast-overlap-detection-fix

Hi Andrew, while going through the code some more I found the following
braino; could you please fold this in? The reason why it wasn't detected
and nothing exploded was that the drm_mm kselftest module does not really
exercise the right path.

Link: http://lkml.kernel.org/r/20170725165401.GA5701@linux-80c1.suse

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_mm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/drm_mm.c~lib-interval_tree-fast-overlap-detection-fix drivers/gpu/drm/drm_mm.c
--- a/drivers/gpu/drm/drm_mm.c~lib-interval_tree-fast-overlap-detection-fix
+++ a/drivers/gpu/drm/drm_mm.c
@@ -212,7 +212,7 @@ static void drm_mm_interval_tree_add_nod
 			link = &parent->rb.rb_left;
 		else {
 			link = &parent->rb.rb_right;
-			leftmost = true;
+			leftmost = false;
 		}
 	}
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

rbtree-cache-leftmost-node-internally.patch
sched-fair-replace-cfs_rq-rb_leftmost.patch
sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch
locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch
block-cfq-replace-cfq_rb_root-leftmost-caching.patch
lib-interval_tree-fast-overlap-detection.patch
lib-interval_tree-fast-overlap-detection-fix.patch
lib-interval-tree-correct-comment-wrt-generic-flavor.patch
procfs-use-faster-rb_first_cached.patch
fs-epoll-use-faster-rb_first_cached.patch

