Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B3EC05027
	for <mm-commits@archiver.kernel.org>; Thu,  9 Feb 2023 03:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbjBID4w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Feb 2023 22:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbjBID4v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2023 22:56:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A3783F0
        for <mm-commits@vger.kernel.org>; Wed,  8 Feb 2023 19:56:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8979E61881
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 03:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6374C433EF;
        Thu,  9 Feb 2023 03:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675915008;
        bh=K6/WTGq/GybE0gMfibkwscGBHOGdBhpCD+Y5fdojJk8=;
        h=Date:To:From:Subject:From;
        b=YIW/MKKLXZrwJ7adeotpYc1LwVHClcuKl2DVXfUggNQXAkJdZDjn4/andXln2eecX
         WUY8zc0KF5OtpAoBg3lt5izODvm2htDvzxaDi5wmcADGbKIlHQsipB1G1yRQuK0fql
         v09vs+MCAO3eQLuo5o/A7D+rUDfy/PZgxoPh4440=
Date:   Wed, 08 Feb 2023 19:56:48 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        mhocko@suse.com, markhemm@googlemail.com, hughd@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix.patch added to mm-unstable branch
Message-Id: <20230209035648.D6374C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix
Date: Wed Feb  8 07:54:45 PM PST 2023

fix shmem_read_mapping_page_gfp(), per Matthew

Link: https://lkml.kernel.org/r/Y+QdJTuzxeBYejw2@casper.infradead.org
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mark Hemment <markhemm@googlemail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/shmem.c~shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix
+++ a/mm/shmem.c
@@ -4354,8 +4354,12 @@ struct page *shmem_read_mapping_page_gfp
 					 pgoff_t index, gfp_t gfp)
 {
 	struct folio *folio = shmem_read_folio_gfp(mapping, index, gfp);
-	struct page *page = folio_file_page(folio, index);
+	struct page *page;
 
+	if (IS_ERR(folio))
+		return &folio->page;
+
+	page = folio_file_page(folio, index);
 	if (PageHWPoison(page)) {
 		folio_put(folio);
 		return ERR_PTR(-EIO);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

