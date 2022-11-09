Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41D7C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiKIBis (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiKIBid (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68588559C
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 734F9B81CC8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFF9C433C1;
        Wed,  9 Nov 2022 01:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957903;
        bh=xNmL9J40iuTCo7ye0U0JULcwRLbDyAzBoGUx/6Z8BPQ=;
        h=Date:To:From:Subject:From;
        b=QOPBf5az0HmPGVlgZgTmDxHVe4aeZ2Xd9BgRBG7h+c0GSiKPj4MlNh3ErTGAC17sf
         QJdBHgi+DaXlKu+McQLG7I8zpAMCQd/cqJtMqSxg8nBzR9PwAJIhy2UIBK8OrpKneD
         /v9aDKd7b9DSOZ3QW8bvhIx1N+XrKGTlBc93QSSA=
Date:   Tue, 08 Nov 2022 17:38:22 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        lukas.bulwahn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-remove-unneeded-assignments-in-shmem_get_folio_gfp.patch removed from -mm tree
Message-Id: <20221109013823.1BFF9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: remove unneeded assignments in shmem_get_folio_gfp()
has been removed from the -mm tree.  Its filename was
     mm-shmem-remove-unneeded-assignments-in-shmem_get_folio_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: mm/shmem: remove unneeded assignments in shmem_get_folio_gfp()
Date: Fri, 7 Oct 2022 10:50:27 +0200

After the rework of shmem_get_folio_gfp() to use a folio, the local
variable hindex is only needed to be set once before passing it to
shmem_add_to_page_cache().

Remove the unneeded initialization and assignments of the variable hindex
before the actual effective assignment and first use.

No functional change. No change in object code.

Link: https://lkml.kernel.org/r/20221007085027.6309-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-unneeded-assignments-in-shmem_get_folio_gfp
+++ a/mm/shmem.c
@@ -1826,7 +1826,7 @@ static int shmem_get_folio_gfp(struct in
 	struct shmem_sb_info *sbinfo;
 	struct mm_struct *charge_mm;
 	struct folio *folio;
-	pgoff_t hindex = index;
+	pgoff_t hindex;
 	gfp_t huge_gfp;
 	int error;
 	int once = 0;
@@ -1864,7 +1864,6 @@ repeat:
 	}
 
 	if (folio) {
-		hindex = folio->index;
 		if (sgp == SGP_WRITE)
 			folio_mark_accessed(folio);
 		if (folio_test_uptodate(folio))
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are


