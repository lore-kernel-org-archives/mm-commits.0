Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87613C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiLAAKi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiLAAIh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:08:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8FD5C0C1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F65261E69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89272C433D6;
        Thu,  1 Dec 2022 00:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852977;
        bh=/ao3KaWI++TKacUhjW/k/cZEd9JUuKgjIJAD//j76Q4=;
        h=Date:To:From:Subject:From;
        b=OXlWceYa2D0kfiBiF2jRGa0Z9MPlliduoU3FgU55G5T0/W6tFAlqEjUPBhQvus3DD
         qwS9naUQaeR6h0EoYiZn6p7/XqKNUk3zkHhp4XNqLxeIBZhcKQ4PagCW6WBY1ZuUWs
         Rs6BO8KdIknV3WbbBphbiMCcVeuUjj+IE9e4eyAc=
Date:   Wed, 30 Nov 2022 16:02:56 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-split-off-__bdi_set_min_ratio-function.patch removed from -mm tree
Message-Id: <20221201000257.89272C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: split off __bdi_set_min_ratio() function
has been removed from the -mm tree.  Its filename was
     mm-split-off-__bdi_set_min_ratio-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: split off __bdi_set_min_ratio() function
Date: Fri, 18 Nov 2022 16:52:06 -0800

This splits off the __bdi_set_min_ratio() function from the
bdi_set_min_ratio() function. The __bdi_set_min_ratio() function will
also be called from the bdi_set_min_bytes() function, which will be
introduced in the next patch.

Link: https://lkml.kernel.org/r/20221119005215.3052436-12-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-split-off-__bdi_set_min_ratio-function
+++ a/mm/page-writeback.c
@@ -685,7 +685,7 @@ static u64 bdi_get_bytes(unsigned int ra
 	return bytes;
 }
 
-int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
+static int __bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 {
 	unsigned int delta;
 	int ret = 0;
@@ -731,6 +731,11 @@ static int __bdi_set_max_ratio(struct ba
 	return ret;
 }
 
+int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
+{
+	return __bdi_set_min_ratio(bdi, min_ratio * BDI_RATIO_SCALE);
+}
+
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio)
 {
 	if (max_ratio > 100)
_

Patches currently in -mm which might be from shr@devkernel.io are


