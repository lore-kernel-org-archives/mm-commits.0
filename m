Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B001AC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 08:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 930CD610A5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 08:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhJ0IDd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240708AbhJ0IDX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 04:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D607160F22;
        Wed, 27 Oct 2021 08:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635321658;
        bh=/rlASG4vL8xmdkLywsI/WQFI4Ywq7QHQTzvCX8EQJgc=;
        h=Date:From:To:Subject:From;
        b=USzBxlOumgNaB44V7RcWuvqwMpqYZzhGVGqmroeKvEyGspS5Hq30WD8RKH33pDeZR
         KZrAhQEAzaUylIFiN49bwx1x7YLcD0IdqSDC5209JNKT/d7lf5d3QydCmpDzBDvN0l
         9vvNLSQJ36N+ofoAp8VfCSvtmQVeLJEpgbsBG9cc=
Date:   Wed, 27 Oct 2021 01:00:57 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  + mm-simplify-bdi-refcounting-fix.patch added to -mm tree
Message-ID: <20211027080057.3pVuWi1XY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-simplify-bdi-refcounting-fix
has been added to the -mm tree.  Its filename is
     mm-simplify-bdi-refcounting-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-bdi-refcounting-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-bdi-refcounting-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-simplify-bdi-refcounting-fix.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

