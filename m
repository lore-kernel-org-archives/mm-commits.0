Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7177C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356699AbiEMCz4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352613AbiEMCzz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:55:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44406554
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C61CB82BA8
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C49AC385B8;
        Fri, 13 May 2022 02:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410551;
        bh=6WPUyFK9CT36gD0/bPBnSMjAGZOILy5GwgKVYxGLPps=;
        h=Date:To:From:Subject:From;
        b=cLHPjc99er6yoO+rGlnGEuZygHjcbq1EL9asXvb0S8whq2p/DsmhSAV8fYqiZqv1H
         W5JZOeGYrBjdmC9mg520BxITxJg7LN3GzhCxvaalumRoZ8VGBA7F7C1/NaiGBL48W4
         jnF+LpAK0eQHvJ0NNWPNS00oKsomjY951HASO0ag=
Date:   Thu, 12 May 2022 19:55:50 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com, lkp@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-handle-uffd-wp-during-fork-fix.patch removed from -mm tree
Message-Id: <20220513025551.1C49AC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: vma_needs_copy can be static
has been removed from the -mm tree.  Its filename was
     mm-shmem-handle-uffd-wp-during-fork-fix.patch

This patch was dropped because it was folded into mm-hugetlb-handle-uffd-wp-during-fork.patch

------------------------------------------------------
From: kernel test robot <lkp@intel.com>
Subject: mm/shmem: vma_needs_copy can be static

mm/memory.c:1238:1: warning: symbol 'vma_needs_copy' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/Ylb0CGeFJlc4EzLk@7ec4ff11d4ae
Fixes: 729c63ce2bbd ("mm/shmem: handle uffd-wp during fork()")
Signed-off-by: kernel test robot <lkp@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-shmem-handle-uffd-wp-during-fork-fix
+++ a/mm/memory.c
@@ -1234,7 +1234,7 @@ copy_p4d_range(struct vm_area_struct *ds
  * false when we can speed up fork() by allowing lazy page faults later until
  * when the child accesses the memory range.
  */
-bool
+static bool
 vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	/*
_

Patches currently in -mm which might be from lkp@intel.com are

mm-hugetlb-handle-uffd-wp-during-fork.patch

