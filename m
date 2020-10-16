Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D06C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2D3E21775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881359;
	bh=Qo3NDcM3JMJRbsUMscCfEjiCJ5xBBe9kxhAshH3/Bzo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=v05YHdoe9jz/2Yp0xmcHzu0sJ1UuWPJ0GVvVYnkAWkcwN5Ih9/j2M+ZYAgBhAfO1c
	 At1yR8d5oyEUhk4Pvd8jpjMQSqdaiArLxGCFCkBmG2wZ9isPHDrcK/fQXjezBMnQL4
	 +ZrWRLzMwPOkTpjd0LV+vYzqjEvAfvQCwPUbrE3A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392717AbgJPUtT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUtT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:49:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D78AA2145D;
        Fri, 16 Oct 2020 20:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881358;
        bh=Qo3NDcM3JMJRbsUMscCfEjiCJ5xBBe9kxhAshH3/Bzo=;
        h=Date:From:To:Subject:From;
        b=NUn7B5YlmO+5Jjbc96HMempLDfZ/gTVXHQF1flo0FR57ByKLQpCIfkpkfyWKUkSWV
         J5mLHBfWCYWs6iVRBF+7wHqo2iK3z3R/hEv4VIgYCai0Wq9AveYSdnwzdftQ71WlBm
         IT0CVy1XHDu20UmS3400mpbwYk1oRszywB8vY9eQ=
Date:   Fri, 16 Oct 2020 13:49:17 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        aris@ruivo.org, cai@lca.pw, dave.hansen@intel.com,
        david@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, osalvador@suse.de, tony.luck@intel.com,
        zeil@yandex-team.ru
Subject:  [merged] mm-hwpoison-remove-recalculating-hpage.patch
 removed from -mm tree
Message-ID: <20201016204917.eon2zQk2D%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: remove recalculating hpage
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-remove-recalculating-hpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: remove recalculating hpage

hpage is never used after try_to_split_thp_page() in memory_failure(), so
we don't have to update hpage.  So let's not recalculate/use hpage.

Link: https://lkml.kernel.org/r/20200922135650.1634-3-osalvador@suse.de
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-recalculating-hpage
+++ a/mm/memory-failure.c
@@ -1341,7 +1341,6 @@ int memory_failure(unsigned long pfn, in
 		}
 		unlock_page(p);
 		VM_BUG_ON_PAGE(!page_count(p), p);
-		hpage = compound_head(p);
 	}
 
 	/*
@@ -1413,11 +1412,8 @@ int memory_failure(unsigned long pfn, in
 	/*
 	 * Now take care of user space mappings.
 	 * Abort on fail: __delete_from_page_cache() assumes unmapped page.
-	 *
-	 * When the raw error page is thp tail page, hpage points to the raw
-	 * page after thp split.
 	 */
-	if (!hwpoison_user_mappings(p, pfn, flags, &hpage)) {
+	if (!hwpoison_user_mappings(p, pfn, flags, &p)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
 		goto out;
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


