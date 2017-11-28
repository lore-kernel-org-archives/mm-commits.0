From: akpm@linux-foundation.org
Subject: + mm-do-not-stall-register_shrinker-fix.patch added to -mm tree
Date: Mon, 27 Nov 2017 16:33:04 -0800
Message-ID: <5a1caec0.kkRcRSUa92XRWzqr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753113AbdK1AdF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 19:33:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, khandual@linux.vnet.ibm.com, mhocko@suse.com, minchan@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, shakeelb@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-do-not-stall-register_shrinker-fix
has been added to the -mm tree.  Its filename is
     mm-do-not-stall-register_shrinker-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-stall-register_shrinker-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-stall-register_shrinker-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-do-not-stall-register_shrinker-fix

tweak code comment

Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-do-not-stall-register_shrinker-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-do-not-stall-register_shrinker-fix
+++ a/mm/vmscan.c
@@ -487,8 +487,9 @@ static unsigned long shrink_slab(gfp_t g
 
 		freed += do_shrink_slab(&sc, shrinker, priority);
 		/*
-		 * bail out if someone want to register a new shrinker to
-		 * prevent long time stall by parallel ongoing shrinking.
+		 * Bail out if someone want to register a new shrinker to
+		 * prevent the regsitration from being stalled for long periods
+		 * by parallel ongoing shrinking.
 		 */
 		if (rwsem_is_contended(&shrinker_rwsem)) {
 			freed = freed ? : 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-introduce-get_user_pages_longterm-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-do-not-stall-register_shrinker-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

