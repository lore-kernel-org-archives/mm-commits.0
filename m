Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48668C2BBCF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FFB12343B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgLPRIx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:08:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgLPRIx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:08:53 -0500
Date:   Wed, 16 Dec 2020 09:08:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138492;
        bh=wO0937hp3Sd3AkeDt2/AM2Y3AxYLtPgjjS58XMIZUmQ=;
        h=From:To:Subject:From;
        b=pPDyi8iwFyBd9gCJbDtZOVQ9F73QB3UrJHotIc0fnFjGV1DA+rGLONG5jl9/DulJJ
         3vlp3gTKIxRc/u7GyK+kBtmS2J4g+xWYbyQS674wt1HzoxtzhQ7IauBVenoPcrPEse
         zJNaqPe6rXsDYzomlDhyHdkvDFokm1uHt3DWg6Yc=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, cheloha@linux.ibm.com, david@redhat.com,
        ldufour@linux.ibm.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        nathanl@linux.ibm.com
Subject:  [merged]
 mm-memory_hotplug-quieting-offline-operation.patch removed from -mm tree
Message-ID: <20201216170812.hun7loPZP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: quieting offline operation
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-quieting-offline-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.ibm.com>
Subject: mm/memory_hotplug: quieting offline operation

On PowerPC, when dymically removing memory from a system we can see in the
console a lot of messages like this:

[  186.575389] Offlined Pages 4096

This message is displayed on each LMB (256MB) removed, which means that we
removing 1TB of memory, this message is displayed 4096 times.

Moving it to DEBUG to not flood the console.

Link: https://lkml.kernel.org/r/20201211150157.91399-1-ldufour@linux.ibm.com
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-quieting-offline-operation
+++ a/mm/memory_hotplug.c
@@ -1561,7 +1561,7 @@ int __ref offline_pages(unsigned long st
 
 	/* Mark all sections offline and remove free pages from the buddy. */
 	__offline_isolated_pages(start_pfn, end_pfn);
-	pr_info("Offlined Pages %ld\n", nr_pages);
+	pr_debug("Offlined Pages %ld\n", nr_pages);
 
 	/*
 	 * The memory sections are marked offline, and the pageblock flags
_

Patches currently in -mm which might be from ldufour@linux.ibm.com are


