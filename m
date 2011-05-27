From: akpm@linux-foundation.org
Subject: + mm-remove-khugepaged-double-thp-vmstat-update-with-config_numa=n.patch added to -mm tree
Date: Fri, 27 May 2011 13:13:15 -0700
Message-ID: <201105272013.p4RKDF0o018562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab1E0UNq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:13:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, jweiner@redhat.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: remove khugepaged double thp vmstat update with CONFIG_NUMA=n
has been added to the -mm tree.  Its filename is
     mm-remove-khugepaged-double-thp-vmstat-update-with-config_numa=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove khugepaged double thp vmstat update with CONFIG_NUMA=n
From: Andrea Arcangeli <aarcange@redhat.com>

Johannes noticed the vmstat update is already taken care of by
khugepaged_alloc_hugepage() internally.  The only places that are required
to update the vmstat are the callers of alloc_hugepage (callers of
khugepaged_alloc_hugepage aren't).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-remove-khugepaged-double-thp-vmstat-update-with-config_numa=n mm/huge_memory.c
--- a/mm/huge_memory.c~mm-remove-khugepaged-double-thp-vmstat-update-with-config_numa=n
+++ a/mm/huge_memory.c
@@ -2234,11 +2234,8 @@ static void khugepaged_loop(void)
 	while (likely(khugepaged_enabled())) {
 #ifndef CONFIG_NUMA
 		hpage = khugepaged_alloc_hugepage();
-		if (unlikely(!hpage)) {
-			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+		if (unlikely(!hpage))
 			break;
-		}
-		count_vm_event(THP_COLLAPSE_ALLOC);
 #else
 		if (IS_ERR(hpage)) {
 			khugepaged_alloc_sleep();
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-remove-khugepaged-double-thp-vmstat-update-with-config_numa=n.patch
mm-hugepages-can-cause-negative-commitlimit.patch

