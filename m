Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91B4C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 01:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiLLBRI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 20:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiLLBRH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 20:17:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDED65D0
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 17:17:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 077DA60DEE
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 01:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B88C433D2;
        Mon, 12 Dec 2022 01:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670807824;
        bh=s55fJSrJc6Qo74P66M76VXym7UABnL7ut/QFRHxbtas=;
        h=Date:To:From:Subject:From;
        b=y1n+IuffAsDoUK8ymWw520G8HyeV9HX38BMfGVJIeeR6X/ciQF0akYA8p3O8y3RIb
         yIMPPis14pWvl81jpg/AFCXg9Kq+pZIShV7vfXtA4CvFUgZeCkYOGwiuJdQOf3IhaM
         lRWClwXFVsxeef8WS+mx/qC7hfRAptid8M0qbQVE=
Date:   Sun, 11 Dec 2022 17:17:03 -0800
To:     mm-commits@vger.kernel.org, ruansy.fnst@fujitsu.com,
        jhubbard@nvidia.com, jgg@nvidia.com, djwong@kernel.org,
        david@fromorbit.com, dan.j.williams@intel.com, apopple@nvidia.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix.patch removed from -mm tree
Message-Id: <20221212011704.58B88C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix
has been removed from the -mm tree.  Its filename was
     fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix.patch

This patch was dropped because it was folded into fsdax-zero-the-edges-if-source-is-hole-or-unwritten.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix
Date: Thu Dec  1 04:37:42 PM PST 2022

update dax_iomap_copy_around() kerneldoc, per Darrick

Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/dax.c~fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix
+++ a/fs/dax.c
@@ -1092,7 +1092,8 @@ out:
 }
 
 /**
- * dax_iomap_copy_around - Copy the data from source to destination before write
+ * dax_iomap_copy_around - Prepare for an unaligned write to a shared/cow page
+ * by copying the data before and after the range to be written.
  * @pos:	address to do copy from.
  * @length:	size of copy operation.
  * @align_size:	aligned w.r.t align_size (either PMD_SIZE or PAGE_SIZE)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fsdax-zero-the-edges-if-source-is-hole-or-unwritten.patch
mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix.patch

