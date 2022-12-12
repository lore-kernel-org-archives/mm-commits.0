Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA7CC4708D
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiLLCRN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiLLCPO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:15:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79AFDFA0
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67413B80B67
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB10C433D2;
        Mon, 12 Dec 2022 02:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811285;
        bh=VxKFvosiU0BGomH0dTFH7Ys7fJKz6cigtL6qpk/dqxk=;
        h=Date:To:From:Subject:From;
        b=dMIMIIUA7Pvm+ni/w88ps57h5qj4ql2rnap5E/eZ7g+FrnZ4xdyP9k4L4jBjw+BL0
         cDkm4G3S1YGQcVBaCTqrmNhcpxfl3ZV0/bP0W0z/U53LA551GYvRSCADUmdfAVppoN
         DRTCH/FrzQHADkz2W/KLthRMOBT72MoMeASgHP1Y=
Date:   Sun, 11 Dec 2022 18:14:44 -0800
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hfsplus-remove-writepage.patch removed from -mm tree
Message-Id: <20221212021445.1AB10C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hfsplus: remove ->writepage
has been removed from the -mm tree.  Its filename was
     hfsplus-remove-writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: hfsplus: remove ->writepage
Date: Fri, 2 Dec 2022 11:26:41 +0100

->writepage is a very inefficient method to write back data, and only
used through write_cache_pages or a a fallback when no ->migrate_folio
method is present.

Set ->migrate_folio to the generic buffer_head based helper, and stop
wiring up ->writepage for hfsplus_aops.

Link: https://lkml.kernel.org/r/20221202102644.770505-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hfsplus/inode.c~hfsplus-remove-writepage
+++ a/fs/hfsplus/inode.c
@@ -170,12 +170,12 @@ const struct address_space_operations hf
 	.dirty_folio	= block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio	= hfsplus_read_folio,
-	.writepage	= hfsplus_writepage,
 	.write_begin	= hfsplus_write_begin,
 	.write_end	= generic_write_end,
 	.bmap		= hfsplus_bmap,
 	.direct_IO	= hfsplus_direct_IO,
 	.writepages	= hfsplus_writepages,
+	.migrate_folio	= buffer_migrate_folio,
 };
 
 const struct dentry_operations hfsplus_dentry_operations = {
_

Patches currently in -mm which might be from hch@lst.de are


