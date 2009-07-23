From: akpm@linux-foundation.org
Subject: + ksm-change-ksm-nice-level-to-be-5.patch added to -mm tree
Date: Thu, 23 Jul 2009 14:07:53 -0700
Message-ID: <200907232107.n6NL7ssH027940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124AbZGWVIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 17:08:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chrisw@redhat.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     ksm: change ksm nice level to be 5
has been added to the -mm tree.  Its filename is
     ksm-change-ksm-nice-level-to-be-5.patch

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
Subject: ksm: change ksm nice level to be 5
From: Izik Eidus <ieidus@redhat.com>

ksm should try not to disturb other tasks as much as possible.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-change-ksm-nice-level-to-be-5 mm/ksm.c
--- a/mm/ksm.c~ksm-change-ksm-nice-level-to-be-5
+++ a/mm/ksm.c
@@ -1270,7 +1270,7 @@ static void ksm_do_scan(unsigned int sca
 
 static int ksm_scan_thread(void *nothing)
 {
-	set_user_nice(current, 0);
+	set_user_nice(current, 5);
 
 	while (!kthread_should_stop()) {
 		if (ksm_run & KSM_RUN_MERGE) {
_

Patches currently in -mm which might be from ieidus@redhat.com are

linux-next.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch

