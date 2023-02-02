Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8888C05027
	for <mm-commits@archiver.kernel.org>; Thu,  2 Feb 2023 23:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbjBBXCW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Feb 2023 18:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjBBXCV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2023 18:02:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8107C339
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 15:02:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2A6A60D45
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 23:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F68C433D2;
        Thu,  2 Feb 2023 23:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675378939;
        bh=9WX3NBqZf0hT57zj12LY3tu2WS701wTGnQEPCn7/w20=;
        h=Date:To:From:Subject:From;
        b=CXGRort+G9Kkog0as7cGEhU3L1gJ70eQQwPPUYuN46Wv6R2ynQ+ZRKMJIrB1w/c+c
         3bM9WQhlbBNgDSqjOceaDiZYgVY0gXi2mlpzInkegWe2cW5b8wpvkUJSDmPga20e/n
         o5Jc9ZFxzmT9sfjMA9rN91Fz9huxsKWNuavLA0SQ=
Date:   Thu, 02 Feb 2023 15:02:18 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-dax_unshare_iter-should-return-a-valid-length.patch added to mm-hotfixes-unstable branch
Message-Id: <20230202230218.E8F68C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: dax_unshare_iter() should return a valid length
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fsdax-dax_unshare_iter-should-return-a-valid-length.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-dax_unshare_iter-should-return-a-valid-length.patch

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
Subject: fsdax: dax_unshare_iter() should return a valid length
Date: Thu, 2 Feb 2023 12:33:47 +0000

The copy_mc_to_kernel() will return 0 if it executed successfully.  Then
the return value should be set to the length it copied.

Link: https://lkml.kernel.org/r/1675341227-14-1-git-send-email-ruansy.fnst@fujitsu.com
Fixes: d984648e428b ("fsdax,xfs: port unshare to fsdax")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/dax.c~fsdax-dax_unshare_iter-should-return-a-valid-length
+++ a/fs/dax.c
@@ -1274,6 +1274,7 @@ static s64 dax_unshare_iter(struct iomap
 	ret = copy_mc_to_kernel(daddr, saddr, length);
 	if (ret)
 		ret = -EIO;
+	ret = length;
 
 out_unlock:
 	dax_read_unlock(id);
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

fsdax-dax_unshare_iter-should-return-a-valid-length.patch

