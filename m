Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE291C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbjDFCsO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbjDFCrS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:47:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7CF9ED3
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78AAC642C1
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B12C4339B;
        Thu,  6 Apr 2023 02:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749129;
        bh=vmsBaf7Vgk6jE48ZTBlHySs/I+ci6wUAsPviGPknaDM=;
        h=Date:To:From:Subject:From;
        b=shg1oSPbNT2xgQ9JvHJlRF3Hp7X22NowsYX9BWNoADWB77SWPAUL/YRSABySB08G0
         Qj5IfiuL6Y/Kj7IYbFDox+UAN84d7zsGC6BqV3p2V8W7eUK+WAH6T4Hbnizwk8HyQt
         nDtTuKzKZE4fMfDwwfPIcHEYPevXhl2w0Q6ME3dU=
Date:   Wed, 05 Apr 2023 19:45:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thomas.hellstrom@linux.intel.com, peterx@redhat.com,
        mtosatti@redhat.com, mhocko@suse.com, linux@armlinux.org.uk,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, hca@linux.ibm.com,
        frederic@kernel.org, dan.j.williams@intel.com, cl@linux.com,
        christian.koenig@amd.com, chenhuacai@kernel.org,
        atomlin@atomlin.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch removed from -mm tree
Message-Id: <20230406024529.D0B12C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drm/ttm: remove comment referencing now-removed vmf_insert_mixed_prot()
has been removed from the -mm tree.  Its filename was
     drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: drm/ttm: remove comment referencing now-removed vmf_insert_mixed_prot()
Date: Sun, 12 Mar 2023 23:40:15 +0000

This function no longer exists, however the prot != vma->vm_page_prot case
discussion has been retained and moved to vmf_insert_pfn_prot() so refer
to this instead.

Link: https://lkml.kernel.org/r/db403b3622b94a87bd93528cc1d6b44ae88adcdd.1678661628.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/ttm/ttm_bo_vm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


