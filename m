Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED3FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9222E61260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhKKCsX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234348AbhKKCsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7516761108;
        Thu, 11 Nov 2021 02:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598720;
        bh=KLM1QoacUhxfqTOufDhPe/cYJl1YJPO3SQzuJuFeHaQ=;
        h=Date:From:To:Subject:From;
        b=XZvF53zqUepwBs818iBF8TPkTVD+/cKd/v1oB+Y58O8Sw5fF2WowVl6d8U2TZAhhq
         CexRtb9DwtGFk04yXicYKjStwSMrigA+etAIqHIEtynsx9fwFIKbVnTcBPMqPZyBX3
         awE4jm4Kwz9NHl16/D/soZdoETfHe+ETMEbNZ3G0=
Date:   Wed, 10 Nov 2021 18:45:20 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range.patch
 removed from -mm tree
Message-ID: <20211111024520.UpB5I__Hd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: remove redundant VM_BUG_ON() in add_reservation_in_range()
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: hugetlb: remove redundant VM_BUG_ON() in add_reservation_in_range()

When calling hugetlb_resv_map_add(), we've guaranteed that the parameter
'to' is always larger than 'from', so it never returns a negative value
from hugetlb_resv_map_add().  Thus remove the redundant VM_BUG_ON().

Link: https://lkml.kernel.org/r/2b565552f3d06753da1e8dda439c0d96d6d9a5a3.1634797639.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range
+++ a/mm/hugetlb.c
@@ -445,7 +445,6 @@ static long add_reservation_in_range(str
 		add += hugetlb_resv_map_add(resv, rg, last_accounted_offset,
 					    t, h, h_cg, regions_needed);
 
-	VM_BUG_ON(add < 0);
 	return add;
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

