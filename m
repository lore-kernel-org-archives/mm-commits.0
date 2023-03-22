Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDD6C6FD1F
	for <mm-commits@archiver.kernel.org>; Wed, 22 Mar 2023 23:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCVXEm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 19:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjCVXEl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 19:04:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F9E19C4C
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 16:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81898B81D84
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 23:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B00AC4339B;
        Wed, 22 Mar 2023 23:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679526269;
        bh=vTu+T3TF+hMRD3m5LaTfj9WoR92Pizuh8u4vkGf0tns=;
        h=Date:To:From:Subject:From;
        b=YDn9L48/h2UEJP23UETcWf09VbZ1FEau0CObZ437o6NGOuwyI7cYRcTeZIpWyiIod
         ccxib2QImey2AR10gwd/4BnaLzrX22kLT7aUFhrE3cPPg1Y3qnZB73aPZCI6AE0kEM
         4kTusjSBltkUDR0n4oq0XO3zsCgW+0SbQWUXBPBE=
Date:   Wed, 22 Mar 2023 16:04:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        jhubbard@nvidia.com, jgg@nvidia.com, jack@suse.cz,
        djwong@kernel.org, dan.j.williams@intel.com, apopple@nvidia.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-unshare-zero-destination-if-srcmap-is-hole-or-unwritten.patch added to mm-hotfixes-unstable branch
Message-Id: <20230322230429.3B00AC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: unshare: zero destination if srcmap is HOLE or UNWRITTEN
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fsdax-unshare-zero-destination-if-srcmap-is-hole-or-unwritten.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-unshare-zero-destination-if-srcmap-is-hole-or-unwritten.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: unshare: zero destination if srcmap is HOLE or UNWRITTEN
Date: Wed, 22 Mar 2023 11:11:09 +0000

unshare copies data from source to destination.  But if the source is HOLE
or UNWRITTEN extents, we should zero the destination, otherwise the result
will be unexpectable.

Link: https://lkml.kernel.org/r/1679483469-2-1-git-send-email-ruansy.fnst@fujitsu.com
Fixes: d984648e428b ("fsdax,xfs: port unshare to fsdax")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/dax.c~fsdax-unshare-zero-destination-if-srcmap-is-hole-or-unwritten
+++ a/fs/dax.c
@@ -1258,15 +1258,20 @@ static s64 dax_unshare_iter(struct iomap
 	/* don't bother with blocks that are not shared to start with */
 	if (!(iomap->flags & IOMAP_F_SHARED))
 		return length;
-	/* don't bother with holes or unwritten extents */
-	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
-		return length;
 
 	id = dax_read_lock();
 	ret = dax_iomap_direct_access(iomap, pos, length, &daddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
+	/* zero the distance if srcmap is HOLE or UNWRITTEN */
+	if (srcmap->flags & IOMAP_F_SHARED || srcmap->type == IOMAP_UNWRITTEN) {
+		memset(daddr, 0, length);
+		dax_flush(iomap->dax_dev, daddr, length);
+		ret = length;
+		goto out_unlock;
+	}
+
 	ret = dax_iomap_direct_access(srcmap, pos, length, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

fsdax-unshare-zero-destination-if-srcmap-is-hole-or-unwritten.patch

