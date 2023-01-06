Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A198C4708E
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbjAFAgu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236401AbjAFAgH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:36:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F7E61302
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:35:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B19061BC8
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD7CC433EF;
        Fri,  6 Jan 2023 00:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965351;
        bh=HGol26jtZvRmd54ubLxyY4SN3slxXPBJ2R3zxikub04=;
        h=Date:To:From:Subject:From;
        b=sK5suvRk9qJEmZHDm1Pk9wr/IFla9tlDL24u3/wjP2Uvk6D71jxtbCeribnrn0w3f
         wGaeUT8ahxl7zLP2Fu2QA7sIIx1B9o+iG4e7iLliVX3FpZDjD8cx3l3QKlgvZ5iQBY
         2a2ursHeeydiNi6lRdigSYlvh6Zn864ghzDxvCQk=
Date:   Thu, 05 Jan 2023 16:35:51 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, lkp@intel.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stop-using-vma_mas_store-for-maple-tree-store.patch added to mm-unstable branch
Message-Id: <20230106003551.CBD7CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: stop using vma_mas_store() for maple tree store
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-stop-using-vma_mas_store-for-maple-tree-store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stop-using-vma_mas_store-for-maple-tree-store.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/damon: stop using vma_mas_store() for maple tree store
Date: Thu, 5 Jan 2023 19:16:00 +0000

Prepare for the removal of the vma_mas_store() function by open coding
the maple tree store in this test code.  Set the range of the maple
state and call the store function directly.

Link: https://lkml.kernel.org/r/20230105191517.3099082-27-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/damon/vaddr-test.h~mm-damon-stop-using-vma_mas_store-for-maple-tree-store
+++ a/mm/damon/vaddr-test.h
@@ -24,8 +24,10 @@ static void __link_vmas(struct maple_tre
 		return;
 
 	mas_lock(&mas);
-	for (i = 0; i < nr_vmas; i++)
-		vma_mas_store(&vmas[i], &mas);
+	for (i = 0; i < nr_vmas; i++) {
+		mas_set_range(&mas, vmas[i].vm_start, vmas[i].vm_end - 1);
+		mas_store_gfp(&mas, &vmas[i], GFP_KERNEL);
+	}
 	mas_unlock(&mas);
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-damon-stop-using-vma_mas_store-for-maple-tree-store.patch

