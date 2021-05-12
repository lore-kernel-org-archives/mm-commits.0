Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB271C433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83F7161413
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346215AbhELVN4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 17:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345987AbhELUhs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 16:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F006161412;
        Wed, 12 May 2021 20:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620851278;
        bh=L6X7T26VRST1vZVltOgJZ46yv+8aDuXl+qEG3v6d95M=;
        h=Date:From:To:Subject:From;
        b=SUTnSmPb59HTDzHx083tU3e8Es+MH7ISOhgpJr5WF99dRiVu1wj5fcd183o8lu2l2
         0TNuj98qGluE7GYc2vzDzPM29avSQYA4jEvShwkFInfX2IU5JMWd6QnG07TIqcNk0T
         wFKgjUS5wgSLTyJr8Yx9xxJ1mDdS9p1K8IrmDLzE=
Date:   Wed, 12 May 2021 13:27:57 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bsingharora@gmail.com,
        dan.j.williams@intel.com, daniel.vetter@ffwll.ch, david@redhat.com,
        gregkh@linuxfoundation.org, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        oliver.sang@intel.com, smuchun@gmail.com
Subject:  +
 kernel-resource-fix-return-code-check-in-__request_free_mem_region.patch
 added to -mm tree
Message-ID: <20210512202757.XR94Q4ChU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: fix return code check in __request_free_mem_region
has been added to the -mm tree.  Its filename is
     kernel-resource-fix-return-code-check-in-__request_free_mem_region.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-resource-fix-return-code-check-in-__request_free_mem_region.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-resource-fix-return-code-check-in-__request_free_mem_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: kernel/resource: fix return code check in __request_free_mem_region

Splitting an earlier version of a patch that allowed calling
__request_region() while holding the resource lock into a series of
patches required changing the return code for the newly introduced
__request_region_locked().

Unfortunately this change was not carried through to a subsequent commit
56fd94919b8b ("kernel/resource: fix locking in request_free_mem_region")
in the series.  This resulted in a use-after-free due to freeing the
struct resource without properly releasing it.  Fix this by correcting the
return code check so that the struct is not freed if the request to add it
was successful.

Link: https://lkml.kernel.org/r/20210512073528.22334-1-apopple@nvidia.com
Fixes: 56fd94919b8b ("kernel/resource: fix locking in request_free_mem_region")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Muchun Song <smuchun@gmail.com>
Cc: Oliver Sang <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~kernel-resource-fix-return-code-check-in-__request_free_mem_region
+++ a/kernel/resource.c
@@ -1805,7 +1805,7 @@ static struct resource *__request_free_m
 				REGION_DISJOINT)
 			continue;
 
-		if (!__request_region_locked(res, &iomem_resource, addr, size,
+		if (__request_region_locked(res, &iomem_resource, addr, size,
 						name, 0))
 			break;
 
_

Patches currently in -mm which might be from apopple@nvidia.com are

kernel-resource-fix-return-code-check-in-__request_free_mem_region.patch

