Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B8DC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Apr 2022 19:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237868AbiDMTCs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237859AbiDMTCq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Apr 2022 15:02:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37770381B4
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 12:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C508561AB2
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 19:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150E3C385A4;
        Wed, 13 Apr 2022 19:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649876423;
        bh=IbfQdaAWvwHPsNqbnaIMcDPmaU04J5VBumbfWFBk/Wg=;
        h=Date:To:From:Subject:From;
        b=ICEOIskXT2cmluhZy+WqFSHFFPSG+jNKHp7x02jtubpSgwYurj6AjBSEhFVdLXZtp
         fYoQJ+/D1OkgfvOPojHtBLPHD9di4Ck3vwoeNj29LXuQatLaNMt0IgQEfnLqtnsYF7
         YTlGoduxjYURENvpc6GlH0CBJOK7kgLsABa4S0jQ=
Date:   Wed, 13 Apr 2022 12:00:22 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com, lkp@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-handle-uffd-wp-during-fork-fix.patch added to -mm tree
Message-Id: <20220413190023.150E3C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: vma_needs_copy can be static
has been added to the -mm tree.  Its filename is
     mm-shmem-handle-uffd-wp-during-fork-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-handle-uffd-wp-during-fork-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-handle-uffd-wp-during-fork-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-secretmem-fix-panic-when-growing-a-memfd_secret-fix.patch
mm-shmem-handle-uffd-wp-during-fork-fix.patch

