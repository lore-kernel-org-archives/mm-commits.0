From: akpm@linux-foundation.org
Subject: + mm-mmu_notifier-init-notifier-if-necessary-v2.patch added to -mm tree
Date: Fri, 31 Aug 2012 12:48:36 -0700
Message-ID: <20120831194837.88DBA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:58129 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2HaTsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 15:48:39 -0400
Received: by wibhr14 with SMTP id hr14so84977wib.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 12:48:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com


The patch titled
     Subject: mm/mmu_notifier: init notifier if necessary
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-init-notifier-if-necessary-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/mmu_notifier: init notifier if necessary

v2: Use GFP_KERNEL instead of GFP_ATOMIC when allocating the MMU
    notifier_mm as Andrew suggested.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmu_notifier.c~mm-mmu_notifier-init-notifier-if-necessary-v2 mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-init-notifier-if-necessary-v2
+++ a/mm/mmu_notifier.c
@@ -215,7 +215,7 @@ static int do_mmu_notifier_register(stru
 
 	if (!mm_has_notifiers(mm)) {
 		mmu_notifier_mm = kmalloc(sizeof(struct mmu_notifier_mm),
-					GFP_ATOMIC);
+					GFP_KERNEL);
 		if (unlikely(!mmu_notifier_mm)) {
 			ret = -ENOMEM;
 			goto out_of_mem;
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

mm-slab-remove-duplicate-check.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
mm-mmu_notifier-init-notifier-if-necessary-v2.patch
mm-vmscan-fix-error-number-for-failed-kthread.patch

