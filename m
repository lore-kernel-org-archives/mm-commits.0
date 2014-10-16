From: akpm@linux-foundation.org
Subject: + mm-memcontrol-lockless-page-counters-fix-2.patch added to -mm
 tree
Date: Thu, 16 Oct 2014 12:16:26 -0700
Message-ID: <5440198a.dSSuA/+lGrWn9e5s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaJPTQ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Oct 2014 15:16:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: lockless page counters fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-lockless-page-counters-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-lockless-page-counters-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-lockless-page-counters-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: lockless page counters fix

include/linux/page_counter.h:19:27: error: 'LONG_MAX' undeclared (first use in this function)
include/linux/page_counter.h:19:38: error: 'PAGE_SIZE' undeclared (first use in this function)

Include <linux/kernel.h> for LONG_MAX and <asm/page.h> for PAGE_SIZE.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/page_counter.h~mm-memcontrol-lockless-page-counters-fix-2 include/linux/page_counter.h
--- a/include/linux/page_counter.h~mm-memcontrol-lockless-page-counters-fix-2
+++ a/include/linux/page_counter.h
@@ -2,6 +2,8 @@
 #define _LINUX_PAGE_COUNTER_H
 
 #include <linux/atomic.h>
+#include <linux/kernel.h>
+#include <asm/page.h>
 
 struct page_counter {
 	atomic_long_t count;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-memcontrol-lockless-page-counters-fix-2.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-vmscan-count-only-dirty-pages-as-congested.patch
debugging-keep-track-of-page-owners.patch

