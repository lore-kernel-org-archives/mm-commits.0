Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0F3EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjFSX1x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjFSXZv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C0C10D4
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D7D760F32
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D01C433C0;
        Mon, 19 Jun 2023 23:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217017;
        bh=N6S1KwRjRx9BQk+x5g21jQ1s+39ac1AQvyAKwSx3Kp4=;
        h=Date:To:From:Subject:From;
        b=jhgguIGQWEpbitDaaqh8UVpVia3hB2o0CC2bdBwi+xZCB+flav4nh4olEtImldhnG
         pVPRcIR1jlh0SxjJttAWdx1K+I2HCFO8TBM40GswF6t9sXNTFt6zL+lEVD4+R5vb1z
         u9EdaJJG+Lj4quHFIzhO3HJmIXmvb1OOhdI6qtC0=
Date:   Mon, 19 Jun 2023 16:23:37 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-make-compound_page_dtors-static.patch removed from -mm tree
Message-Id: <20230619232337.A6D01C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: make compound_page_dtors static
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-compound_page_dtors-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: page_alloc: make compound_page_dtors static
Date: Sat, 17 Jun 2023 11:46:22 +0800

It's only used inside page_alloc.c now. So make it static and remove the
declaration in mm.h.

Link: https://lkml.kernel.org/r/20230617034622.1235913-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/page_alloc.c    |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-page_alloc-make-compound_page_dtors-static
+++ a/include/linux/mm.h
@@ -1220,7 +1220,6 @@ enum compound_dtor_id {
 #endif
 	NR_COMPOUND_DTORS,
 };
-extern compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS];
 
 static inline void folio_set_compound_dtor(struct folio *folio,
 		enum compound_dtor_id compound_dtor)
--- a/mm/page_alloc.c~mm-page_alloc-make-compound_page_dtors-static
+++ a/mm/page_alloc.c
@@ -284,7 +284,7 @@ const char * const migratetype_names[MIG
 #endif
 };
 
-compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
+static compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
 	[NULL_COMPOUND_DTOR] = NULL,
 	[COMPOUND_PAGE_DTOR] = free_compound_page,
 #ifdef CONFIG_HUGETLB_PAGE
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


