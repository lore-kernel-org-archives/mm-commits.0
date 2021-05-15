Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE64C43460
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E15B961444
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbhEOA21 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 20:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhEOA21 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 20:28:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A02A961454;
        Sat, 15 May 2021 00:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621038434;
        bh=OwbFWl/Il8OIZAeQ4HuX3sY8AeZ38lQtBoqZYgQMyGg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qKxIPPEJILUbOXXRIRU35iEy9Lvjne0wGFNY8IYFEY7gMM1X6YA7OTnz2C2yQp69W
         5LEl/LBZLmuYYcqLpswUIINYNuiBeVqkyauZP5OWLOg7V+y2cajSFJR9iyauY7pst/
         1GAdeo+604ttLq9OKVLMgh9ESbyXwRAjcoDVOfZ4=
Date:   Fri, 14 May 2021 17:27:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com,
        bsingharora@gmail.com, dan.j.williams@intel.com,
        daniel.vetter@ffwll.ch, david@redhat.com,
        gregkh@linuxfoundation.org, jglisse@redhat.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, oliver.sang@intel.com,
        smuchun@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 04/13] kernel/resource: fix return code check in
 __request_free_mem_region
Message-ID: <20210515002713.ECAlwWgMi%akpm@linux-foundation.org>
In-Reply-To: <20210514172634.9018621171d5334ceee97e95@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
