From: akpm@linux-foundation.org
Subject: +
 mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix-2.patch added to -mm tree
Date: Wed, 19 Jun 2013 00:09:25 -0700
Message-ID: <51c15925.CQ3uqatHqFybAsJ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3FSHJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jun 2013 03:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, hannes@cmpxchg.org, gang.chen@asianux.com

Subject: + mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix-2.patch added to -mm tree
To: gang.chen@asianux.com,hannes@cmpxchg.org,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 19 Jun 2013 00:09:23 -0700


The patch titled
     Subject: mm/vmscan.c: 'lru' may be used without initialized after the patch "3abf380..." in next-20130607 tree
has been added to the -mm tree.  Its filename is
     mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: mm/vmscan.c: 'lru' may be used without initialized after the patch "3abf380..." in next-20130607 tree

'lru' may be used without initialized, so need regressing part of the
related patch.

The related patch:
  "3abf380 mm: remove lru parameter from __lru_cache_add and lru_cache_add_lru"

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmscan.c~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix-2 mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix-2
+++ a/mm/vmscan.c
@@ -560,6 +560,7 @@ redo:
 		 * unevictable page on [in]active list.
 		 * We know how to handle that.
 		 */
+		lru = !!TestClearPageActive(page) + page_lru_base_type(page);
 		lru_cache_add(page);
 	} else {
 		/*
_

Patches currently in -mm which might be from gang.chen@asianux.com are

linux-next.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix-2.patch
mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch
mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch
arch-frv-kernel-trapsc-using-vsnprintf-instead-of-vsprintf.patch
arch-frv-kernel-setupc-use-strncmp-instead-of-memcmp.patch

