Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3629CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E05E61A09
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhJVDrk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232871AbhJVDrj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:47:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5E4861A0C;
        Fri, 22 Oct 2021 03:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634874323;
        bh=eoPjzyO0WE8x7lar1rGrejHFtZiIyvGmDLQ5Rwqkfe8=;
        h=Date:From:To:Subject:From;
        b=A+l7W4Bm+x/azS/EMKXQQYBPy5Z/r2H3Er0HudLEjzBCOaG5soWMF4WIVmVUYbI2l
         2YVGx5xXAunCRFBqz1/rTSDRUMI0OIIo4DhuxkPvteefKJg2HgGZTmJZqMTU77FRbx
         KR3hgBWK6zc2DcZH1GK7aFeIBTBqNUhK1fDDrAoY=
Date:   Thu, 21 Oct 2021 20:45:22 -0700
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  +
 hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range.patch added
 to -mm tree
Message-ID: <20211022034522.NIDxXL4ei%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: remove redundant VM_BUG_ON() in add_reservation_in_range()
has been added to the -mm tree.  Its filename is
     hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: hugetlb: remove redundant VM_BUG_ON() in add_reservation_in_range()

When calling hugetlb_resv_map_add(), we've guaranteed that the parameter
'to' is always larger than 'from', so it never returns a negative value
from hugetlb_resv_map_add().  Thus remove the redundant VM_BUG_ON().

Link: https://lkml.kernel.org/r/2b565552f3d06753da1e8dda439c0d96d6d9a5a3.1634797639.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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

hugetlb-support-node-specified-when-using-cma-for-gigantic-hugepages.patch
hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro.patch
hugetlb-replace-the-obsolete-hugetlb_instantiation_mutex-in-the-comments.patch
hugetlb-remove-redundant-validation-in-has_same_uncharge_info.patch
hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range.patch
mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

