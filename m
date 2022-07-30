Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59C3C19F29
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239710AbiG3BJQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239714AbiG3BI4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759DD82103
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1244F61C3C
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C8AC433C1;
        Sat, 30 Jul 2022 01:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143319;
        bh=aBv3LMv1ZdWzcMEG2LLtI2yh9UGKVgHjLNhKdFUcZV0=;
        h=Date:To:From:Subject:From;
        b=lOYxl8gyqfjWjDUOtVkohx6IdAsRh1IXdl3F9APWnu7gVJgNHRoOdqkAyw395J1Cc
         yTQ3BcWh+e2+IZCzDFZ/+wEnBupjjzZIPbGEZ/droxPGpH8cCM8a/jjoP2DJWX8Pt/
         qGs+VGam/oqq/WSGMexDHX2uP+AfQzeNm0CF9XWQ=
Date:   Fri, 29 Jul 2022 18:08:38 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gupc-fix-formating-in-check_and_migrate_movable_page.patch removed from -mm tree
Message-Id: <20220730010839.68C8AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup.c: fix formatting in check_and_migrate_movable_page()
has been removed from the -mm tree.  Its filename was
     mm-gupc-fix-formating-in-check_and_migrate_movable_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/gup.c: fix formatting in check_and_migrate_movable_page()
Date: Thu, 21 Jul 2022 12:05:52 +1000

Commit b05a79d4377f ("mm/gup: migrate device coherent pages when pinning
instead of failing") added a badly formatted if statement. Fix it.

Link: https://lkml.kernel.org/r/20220721020552.1397598-2-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gupc-fix-formating-in-check_and_migrate_movable_page
+++ a/mm/gup.c
@@ -1980,8 +1980,8 @@ static long check_and_migrate_movable_pa
 				    folio_nr_pages(folio));
 	}
 
-	if (!list_empty(&movable_page_list) || isolation_error_count
-		|| coherent_pages)
+	if (!list_empty(&movable_page_list) || isolation_error_count ||
+	    coherent_pages)
 		goto unpin_pages;
 
 	/*
_

Patches currently in -mm which might be from apopple@nvidia.com are


