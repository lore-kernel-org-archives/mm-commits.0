Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673F5C636D4
	for <mm-commits@archiver.kernel.org>; Sat,  4 Feb 2023 01:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjBDBxN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 20:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbjBDBxH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 20:53:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862C7A267
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 17:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28068B82C66
        for <mm-commits@vger.kernel.org>; Sat,  4 Feb 2023 01:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C580EC433EF;
        Sat,  4 Feb 2023 01:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675475582;
        bh=xXD9UcnOfEiGYAXVFekDHWYoo+FmBkp4q5O/oe0MmTI=;
        h=Date:To:From:Subject:From;
        b=NhmxeiFBsZ7dHpCETR38d5Ke25Xs1K+fVZ4U2Gh7Blc/Rbq5X8JVvr37G+wDMYcZp
         fSquHLyUIMJbJnvZ8Op2hw3VClrZ70OObqm+X9NB6T30yU/X+LaizQRxNjQneaU9kH
         wF8i5u8Q95C3J8Es5JzlHNkSpbzXlJ05sHNNr10g=
Date:   Fri, 03 Feb 2023 17:53:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        jhubbard@nvidia.com, jgg@nvidia.com, djwong@kernel.org,
        david@fromorbit.com, dan.j.williams@intel.com, apopple@nvidia.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fsdax-dax_unshare_iter-should-return-a-valid-length.patch removed from -mm tree
Message-Id: <20230204015302.C580EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax: dax_unshare_iter() should return a valid length
has been removed from the -mm tree.  Its filename was
     fsdax-dax_unshare_iter-should-return-a-valid-length.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: dax_unshare_iter() should return a valid length
Date: Thu, 2 Feb 2023 12:33:47 +0000

The copy_mc_to_kernel() will return 0 if it executed successfully.  Then
the return value should be set to the length it copied.

[akpm@linux-foundation.org: don't mess up `ret', per Matthew]
Link: https://lkml.kernel.org/r/1675341227-14-1-git-send-email-ruansy.fnst@fujitsu.com
Fixes: d984648e428b ("fsdax,xfs: port unshare to fsdax")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/dax.c~fsdax-dax_unshare_iter-should-return-a-valid-length
+++ a/fs/dax.c
@@ -1271,8 +1271,9 @@ static s64 dax_unshare_iter(struct iomap
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = copy_mc_to_kernel(daddr, saddr, length);
-	if (ret)
+	if (copy_mc_to_kernel(daddr, saddr, length) == 0)
+		ret = length;
+	else
 		ret = -EIO;
 
 out_unlock:
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


