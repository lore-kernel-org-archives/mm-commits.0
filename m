From: akpm@google.com
Subject: + mm-huge_memoryc-quiet-sparse-noise.patch added to -mm tree
Date: Wed, 28 Sep 2011 12:21:03 -0700
Message-ID: <201109281921.p8SJL4KZ018152@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:24479 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1I1TVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2011 15:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, aarcange@redhat.com, hsweeten@visionengravers.com, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     Subject: mm/huge_memory.c: quiet sparse noise
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-quiet-sparse-noise.patch

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
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: mm/huge_memory.c: quiet sparse noise

Quiet the sparse noise:

warning: symbol 'khugepaged_scan' was not declared. Should it be static?
warning: context imbalance in 'khugepaged_scan_mm_slot' - unexpected unlock

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/huge_memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-huge_memoryc-quiet-sparse-noise mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memoryc-quiet-sparse-noise
+++ a/mm/huge_memory.c
@@ -89,7 +89,8 @@ struct khugepaged_scan {
 	struct list_head mm_head;
 	struct mm_slot *mm_slot;
 	unsigned long address;
-} khugepaged_scan = {
+};
+static struct khugepaged_scan khugepaged_scan = {
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
@@ -2084,6 +2085,8 @@ static void collect_mm_slot(struct mm_sl
 
 static unsigned int khugepaged_scan_mm_slot(unsigned int pages,
 					    struct page **hpage)
+	__releases(&khugepaged_mm_lock)
+	__acquires(&khugepaged_mm_lock)
 {
 	struct mm_slot *mm_slot;
 	struct mm_struct *mm;
_
Subject: Subject: mm/huge_memory.c: quiet sparse noise

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch
mm-memblockc-quiet-sparse-noise.patch
mm-thrashc-quiet-sparse-noise.patch
mm-mempolicyc-quiet-sparse-noise.patch
mm-huge_memoryc-quiet-sparse-noise.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch

