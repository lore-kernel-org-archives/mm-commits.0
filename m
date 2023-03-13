Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5389BC6FD19
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 01:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCMBCI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 12 Mar 2023 21:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjCMBCF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 12 Mar 2023 21:02:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C072CC5E
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 18:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D598E6101F
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 01:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382B5C433D2;
        Mon, 13 Mar 2023 01:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678669323;
        bh=qoC3MWF/Btw4Cg+Ie1MUIOYfVxZLV06xN3sxLk8ys9s=;
        h=Date:To:From:Subject:From;
        b=L7pKHtd7p3TS9LjJlVvVNnE/1PYXxj9S8akQXwE+8doF75fv5Vj0kk/53unW9418h
         1vbkPP/lZX2VdifZK24+s33a+afbVvFIQtnMHlBE3we4GzWr853js40Fc+Ey7YfviQ
         WIkwp2MrVjfAlP+1f8MVIwsTEZ7FHP/GRDils72Q=
Date:   Sun, 12 Mar 2023 18:02:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        thomas.hellstrom@linux.intel.com, mhocko@suse.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch added to mm-unstable branch
Message-Id: <20230313010203.382B5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/ttm: remove comment referencing now-removed vmf_insert_mixed_prot()
has been added to the -mm mm-unstable branch.  Its filename is
     drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: drm/ttm: remove comment referencing now-removed vmf_insert_mixed_prot()
Date: Sun, 12 Mar 2023 23:40:15 +0000

This function no longer exists, however the prot != vma->vm_page_prot case
discussion has been retained and moved to vmf_insert_pfn_prot() so refer
to this instead.

Link: https://lkml.kernel.org/r/db403b3622b94a87bd93528cc1d6b44ae88adcdd.1678661628.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -254,7 +254,7 @@ vm_fault_t ttm_bo_vm_fault_reserved(stru
 		 * encryption bits. This is because the exact location of the
 		 * data may not be known at mmap() time and may also change
 		 * at arbitrary times while the data is mmap'ed.
-		 * See vmf_insert_mixed_prot() for a discussion.
+		 * See vmf_insert_pfn_prot() for a discussion.
 		 */
 		ret = vmf_insert_pfn_prot(vma, address, pfn, prot);
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch

