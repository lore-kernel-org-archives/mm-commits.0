Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C3FC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjBJAsy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBJAsx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:48:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7876B5AB13
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 297FAB822D1
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59B9C433EF;
        Fri, 10 Feb 2023 00:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990129;
        bh=+6U1dLCH1CLcsIUn9Iv7+JfSfqIX1Y6y0/LPn5csnqY=;
        h=Date:To:From:Subject:From;
        b=KkFjPYgEd1DYLXiWYp/G/02lmvN1Rex3WLaD9X72Fez/Wp4LS0RQqy+oj8pSBu021
         /lFGw5qNj1bd/M9lDipcyzHUxMWhJ9ie5hUKFOT/oE6SGigQEM45WUQYoApw4692y/
         BkhJ6rYft4WHpf+JiaR+VCeF1YRWXJrRHzoVVFGM=
Date:   Thu, 09 Feb 2023 16:48:49 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        mhocko@suse.com, markhemm@googlemail.com, hughd@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix.patch removed from -mm tree
Message-Id: <20230210004849.B59B9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix
has been removed from the -mm tree.  Its filename was
     shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix.patch

This patch was dropped because it was folded into shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch

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

shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

