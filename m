Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7A7C636D6
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjBJA5e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjBJAz6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0107F6F8F7
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2EEDB82398
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFE5C433EF;
        Fri, 10 Feb 2023 00:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990477;
        bh=nzjxFOe/cKvGvHT1a1CBLSJiqwqkCe3Bi8sxgl5ahOE=;
        h=Date:To:From:Subject:From;
        b=wodWbV82pYaijst3Xr1qxbjg6F+ZNscFl3pRIgfROZAiki2mwzxUHzm93yJuKVkEh
         LZsi6LeISq3coLFwJXzvaAcIt4ciqTGGEk7nRrYjO/eUaWqILTjK7Nv1S2S70j660f
         BZsCAHMgLnPfEOJ0e8OPJuqYAl6veLHzK70NEKaA=
Date:   Thu, 09 Feb 2023 16:54:36 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-locked-being-null-from-faultin_vma_page_range.patch removed from -mm tree
Message-Id: <20230210005437.4FFE5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: remove locked being NULL from faultin_vma_page_range()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-locked-being-null-from-faultin_vma_page_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: remove locked being NULL from faultin_vma_page_range()
Date: Tue, 24 Jan 2023 16:34:28 -0400

The only caller of this function always passes in a non-NULL locked, so
just remove this obsolete comment.

Link: https://lkml.kernel.org/r/7-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/gup.c~mm-gup-remove-locked-being-null-from-faultin_vma_page_range
+++ a/mm/gup.c
@@ -1558,12 +1558,7 @@ long populate_vma_page_range(struct vm_a
  * code on error (see __get_user_pages()).
  *
  * vma->vm_mm->mmap_lock must be held. The range must be page-aligned and
- * covered by the VMA.
- *
- * If @locked is NULL, it may be held for read or write and will be unperturbed.
- *
- * If @locked is non-NULL, it must held for read only and may be released.  If
- * it's released, *@locked will be set to 0.
+ * covered by the VMA. If it's released, *@locked will be set to 0.
  */
 long faultin_vma_page_range(struct vm_area_struct *vma, unsigned long start,
 			    unsigned long end, bool write, int *locked)
_

Patches currently in -mm which might be from jgg@nvidia.com are


