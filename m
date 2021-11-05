Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2AA4C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CED6D61186
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhKESd4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhKESdy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F046112D;
        Fri,  5 Nov 2021 18:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137075;
        bh=CQAc/R8lyeY0uyQ94u6Mrb+1+GUsgrnJuXyTo6/N+7g=;
        h=Date:From:To:Subject:From;
        b=uLrD9FTyUOiWhmLOokSJvwXdj7sK6N9PJIO4iFOIuWmxCG+vOK5bycd8M9lsfJxl7
         LIhncRfFUJ73tdHlxhi8wpTZLOdq2m1qQrcj8Zzd1jZqQLwsy9g+VUYJly5ufaNMYA
         QOYFrBtG8GXZ5wSLlPaP9HngaA691SVhqUdtOcQA=
Date:   Fri, 05 Nov 2021 11:31:14 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  [folded-merged] mm-simplify-bdi-refcounting-fix.patch
 removed from -mm tree
Message-ID: <20211105183114.T94bvGYbm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-simplify-bdi-refcounting-fix
has been removed from the -mm tree.  Its filename was
     mm-simplify-bdi-refcounting-fix.patch

This patch was dropped because it was folded into mm-simplify-bdi-refcounting.patch

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm-simplify-bdi-refcounting-fix

add comment

Link: https://lkml.kernel.org/r/20211027074207.GA12793@lst.de
Cc: Jan Kara <jack@suse.cz>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev-defs.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/backing-dev-defs.h~mm-simplify-bdi-refcounting-fix
+++ a/include/linux/backing-dev-defs.h
@@ -103,6 +103,9 @@ struct wb_completion {
  * change as blkcg is disabled and enabled higher up in the hierarchy, a wb
  * is tested for blkcg after lookup and removed from index on mismatch so
  * that a new wb for the combination can be created.
+ *
+ * Each bdi_writeback that is no embedded into the backing_dev_info must hold
+ * a reference to the parent backing_dev_info.  See cgwb_create() for details.
  */
 struct bdi_writeback {
 	struct backing_dev_info *bdi;	/* our parent bdi */
_

Patches currently in -mm which might be from hch@lst.de are

mm-dont-include-linux-daxh-in-linux-mempolicyh.patch
mm-export-bdi_unregister.patch
mtd-call-bdi_unregister-explicitly.patch
fs-explicitly-unregister-per-superblock-bdis.patch
mm-dont-automatically-unregister-bdis.patch
mm-simplify-bdi-refcounting.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

