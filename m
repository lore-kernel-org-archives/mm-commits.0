Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED933C433E2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 22:00:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A774120709
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 22:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599170431;
	bh=ynqJydLy69spISu6RyCLQNwPKCtD3uChku82GiQH7xo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hyqbBoPDsbUPx37nJxlSD6Mb3q1osM7vxsAqXFL3m1BjFjaoM/S5o/zBjTHN0qXv/
	 BAY+/HovdMDy46b9HdgjdiGVTmKEgqJzo+4fm6sxtXUmqB9el6gxoCJDvmmH+W44wS
	 QPnS4pw0X1G1OTSMz2/CInWrWiZ9wN/VKhZbQeDU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgICWAb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 18:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbgICWAb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 18:00:31 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7323520678;
        Thu,  3 Sep 2020 22:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599170430;
        bh=ynqJydLy69spISu6RyCLQNwPKCtD3uChku82GiQH7xo=;
        h=Date:From:To:Subject:From;
        b=2FyuE9bX4uNaMtqZXZJG4Hg/A9e9WTcPPFxF3FypQcgTy1Rrz2csiFTB43siW11qu
         H3BQERH91xjWQ/AUf6yUECz5pm1V5vtCU7iSmcXB9qhSGRPTYCza9n1AA0TC9Rny7f
         O4iPOs+MFu284fppNYBGUTb28S2Ia9pN9L8TF4zM=
Date:   Thu, 03 Sep 2020 15:00:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org
Subject:  + linux-next-rejects.patch added to -mm tree
Message-ID: <20200903220030.8WlmQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/filemap.c~linux-next-rejects
+++ a/mm/filemap.c
@@ -827,10 +827,10 @@ int replace_page_cache_page(struct page
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
-static int __add_to_page_cache_locked(struct page *page,
-				      struct address_space *mapping,
-				      pgoff_t offset, gfp_t gfp,
-				      void **shadowp)
+static noinline int __add_to_page_cache_locked(struct page *page,
+					       struct address_space *mapping,
+					       pgoff_t offset, gfp_t gfp,
+					       void **shadowp)
 {
 	XA_STATE(xas, &mapping->i_pages, offset);
 	int huge = PageHuge(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-rejects.patch

