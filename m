From: akpm@linux-foundation.org
Subject: +
 mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch
 added to -mm tree
Date: Wed, 29 Apr 2020 18:09:47 -0700
Message-ID: <20200430010947.ADT4hH_4f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbgD3BJs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 21:09:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, lkp@intel.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix
has been added to the -mm tree.  Its filename is
     mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
