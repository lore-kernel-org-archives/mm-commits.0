From: akpm@linux-foundation.org
Subject: [folded-merged] mm-do-not-stall-register_shrinker-fix.patch
 removed from -mm tree
Date: Wed, 31 Jan 2018 15:50:33 -0800
Message-ID: <5a725649.ks6+8dgklN3Mr99v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56206 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753756AbeAaXue (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:50:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, khandual@linux.vnet.ibm.com, mhocko@suse.com, minchan@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, shakeelb@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-do-not-stall-register_shrinker-fix
has been removed from the -mm tree.  Its filename was
     mm-do-not-stall-register_shrinker-fix.patch

This patch was dropped because it was folded into mm-do-not-stall-register_shrinker.patch

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
@@ -497,8 +497,9 @@ static unsigned long shrink_slab(gfp_t g
 
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

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-do-not-stall-register_shrinker.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
tools-vm-new-option-to-specify-kpageflags-file-fix.patch

