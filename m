From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch
 removed from -mm tree
Date: Tue, 05 May 2020 12:54:31 -0700
Message-ID: <20200505195431.Ot5IQjHRp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgEETyc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 15:54:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, lkp@intel.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch

This patch was dropped because it was folded into mm-memcg-decouple-elowmin-state-mutations-from-protection-checks.patch

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix

CONFIG_MEMCG=n build fixes

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix
+++ a/include/linux/memcontrol.h
@@ -847,17 +847,12 @@ static inline void memcg_memory_event_mm
 {
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
-						  bool in_low_reclaim)
-{
-
