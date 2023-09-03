Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE30C001DB
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 01:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbjICBi4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 21:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbjICBi4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 21:38:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FC4120
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 18:38:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F38461254
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 01:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3361C433C7;
        Sun,  3 Sep 2023 01:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693705131;
        bh=eSXR8kP4K0DjMYK8TD97JgY+v9NeQ24yt+5EhJKhwBo=;
        h=Date:To:From:Subject:From;
        b=wTneGebe+HMikVksYWRdpoOZ/cfmMH9Ue44U0//gZLHLkYMs/vLU2pAbUsAX2vdJe
         BfSPQcN6Mqgz53uZnanxdJVccSSrkkplhkW2UmqH/ncVGLnipV/FtXGHpfbjkpDKiL
         +oVHUHs5duYMJfJ0jJ6dkjlllkfxaSw98BzvFY3s=
Date:   Sat, 02 Sep 2023 18:38:51 -0700
To:     mm-commits@vger.kernel.org, usama.arif@bytedance.com,
        songmuchun@bytedance.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, linmiaohe@huawei.com, jthoughton@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-set-hugetlb-page-flag-before-optimizing-vmemmap.patch added to mm-unstable branch
Message-Id: <20230903013851.D3361C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: set hugetlb page flag before optimizing vmemmap
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-set-hugetlb-page-flag-before-optimizing-vmemmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-set-hugetlb-page-flag-before-optimizing-vmemmap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: set hugetlb page flag before optimizing vmemmap
Date: Tue, 29 Aug 2023 14:37:34 -0700

Currently, vmemmap optimization of hugetlb pages is performed before the
hugetlb flag (previously hugetlb destructor) is set identifying it as a
hugetlb folio.  This means there is a window of time where an ordinary
folio does not have all associated vmemmap present.  The core mm only
expects vmemmap to be potentially optimized for hugetlb and device dax. 
This can cause problems in code such as memory error handling that may
want to write to tail struct pages.

There is only one call to perform hugetlb vmemmap optimization today.  To
fix this issue, simply set the hugetlb flag before that call.

There was a similar issue in the free hugetlb path that was previously
addressed.  The two routines that optimize or restore hugetlb vmemmap
should only be passed hugetlb folios/pages.  To catch any callers not
following this rule, add VM_WARN_ON calls to the routines.  In the hugetlb
free code paths, some calls could be made to restore vmemmap after
clearing the hugetlb flag.  This was 'safe' as in these cases vmemmap was
already present and the call was a NOOP.  However, for consistency these
calls where eliminated so that we can add the VM_WARN_ON checks.

Link: https://lkml.kernel.org/r/20230829213734.69673-1-mike.kravetz@oracle.com
Fixes: f41f2ed43ca5 ("mm: hugetlb: free the vmemmap pages associated with each HugeTLB page")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |   31 ++++++++++++++++++++++---------
 mm/hugetlb_vmemmap.c |    3 +++
 2 files changed, 25 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~hugetlb-set-hugetlb-page-flag-before-optimizing-vmemmap
+++ a/mm/hugetlb.c
@@ -1720,7 +1720,12 @@ static void __update_and_free_hugetlb_fo
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return;
 
-	if (hugetlb_vmemmap_restore(h, &folio->page)) {
+	/*
+	 * If folio is not vmemmap optimized (!clear_dtor), then the folio
+	 * is no longer identified as a hugetlb page.  hugetlb_vmemmap_restore
+	 * can only be passed hugetlb pages and will BUG otherwise.
+	 */
+	if (clear_dtor && hugetlb_vmemmap_restore(h, &folio->page)) {
 		spin_lock_irq(&hugetlb_lock);
 		/*
 		 * If we cannot allocate vmemmap pages, just refuse to free the
@@ -1930,9 +1935,9 @@ static void __prep_account_new_huge_page
 
 static void __prep_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
+	folio_set_hugetlb(folio);
 	hugetlb_vmemmap_optimize(h, &folio->page);
 	INIT_LIST_HEAD(&folio->lru);
-	folio_set_hugetlb(folio);
 	hugetlb_set_folio_subpool(folio, NULL);
 	set_hugetlb_cgroup(folio, NULL);
 	set_hugetlb_cgroup_rsvd(folio, NULL);
@@ -3580,13 +3585,21 @@ static int demote_free_hugetlb_folio(str
 	remove_hugetlb_folio_for_demote(h, folio, false);
 	spin_unlock_irq(&hugetlb_lock);
 
-	rc = hugetlb_vmemmap_restore(h, &folio->page);
-	if (rc) {
-		/* Allocation of vmemmmap failed, we can not demote folio */
-		spin_lock_irq(&hugetlb_lock);
-		folio_ref_unfreeze(folio, 1);
-		add_hugetlb_folio(h, folio, false);
-		return rc;
+	/*
+	 * If vmemmap already existed for folio, the remove routine above would
+	 * have cleared the hugetlb folio flag.  Hence the folio is technically
+	 * no longer a hugetlb folio.  hugetlb_vmemmap_restore can only be
+	 * passed hugetlb folios and will BUG otherwise.
+	 */
+	if (folio_test_hugetlb(folio)) {
+		rc = hugetlb_vmemmap_restore(h, &folio->page);
+		if (rc) {
+			/* Allocation of vmemmmap failed, we can not demote folio */
+			spin_lock_irq(&hugetlb_lock);
+			folio_ref_unfreeze(folio, 1);
+			add_hugetlb_folio(h, folio, false);
+			return rc;
+		}
 	}
 
 	/*
--- a/mm/hugetlb_vmemmap.c~hugetlb-set-hugetlb-page-flag-before-optimizing-vmemmap
+++ a/mm/hugetlb_vmemmap.c
@@ -13,6 +13,7 @@
 #include <linux/pgtable.h>
 #include <linux/moduleparam.h>
 #include <linux/bootmem_info.h>
+#include <linux/mmdebug.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
@@ -456,6 +457,7 @@ int hugetlb_vmemmap_restore(const struct
 	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
 	unsigned long vmemmap_reuse;
 
+	VM_WARN_ON_ONCE(!PageHuge(head));
 	if (!HPageVmemmapOptimized(head))
 		return 0;
 
@@ -550,6 +552,7 @@ void hugetlb_vmemmap_optimize(const stru
 	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
 	unsigned long vmemmap_reuse;
 
+	VM_WARN_ON_ONCE(!PageHuge(head));
 	if (!vmemmap_should_optimize(h, head))
 		return;
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-set-hugetlb-page-flag-before-optimizing-vmemmap.patch

