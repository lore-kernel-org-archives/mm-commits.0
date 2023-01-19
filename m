Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5EBC677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjASBTk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjASBRt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:17:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FC56C547
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3C2661B18
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F09C433F1;
        Thu, 19 Jan 2023 01:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090939;
        bh=0G4IetAOU1uSluPcgcSNHux3bphFudl9WH2i+uWCd4E=;
        h=Date:To:From:Subject:From;
        b=znM7CkEhdkxYoJCgJSiMYebsUeu2Ql3DptSC2x/qWKkMnm0V3Arp/j2UCp4UvpMOv
         3IS68LoexVIi1dvLWNzRYLpCSgFnuzLSgeLVDHx/3yfAWdfcfToNSX3G15quzawO8a
         Q2kY2ixvtwVrHevXWFtQj/fasXFgkOPn62jNl5oc=
Date:   Wed, 18 Jan 2023 17:15:38 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.cz, almaz.alexandrovich@paragon-software.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-remove-an-outdated-comment-on-mpage_writepages.patch removed from -mm tree
Message-Id: <20230119011539.14F09C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: remove an outdated comment on mpage_writepages
has been removed from the -mm tree.  Its filename was
     fs-remove-an-outdated-comment-on-mpage_writepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: fs: remove an outdated comment on mpage_writepages
Date: Thu, 29 Dec 2022 06:10:26 -1000

Patch series "remove generic_writepages"

This series removes generic_writepages by open coding the current
functionality in the three remaining callers.  Besides removing some
code the main benefit is that one of the few remaining ->writepage
callers from outside the core page cache code go away.

This patch (of 6):


mpage_writepages doesn't do any of the page locking itself, so remove and
outdated comment on the locking pattern there.

Link: https://lkml.kernel.org/r/20221229161031.391878-1-hch@lst.de
Link: https://lkml.kernel.org/r/20221229161031.391878-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/fs/mpage.c~fs-remove-an-outdated-comment-on-mpage_writepages
+++ a/fs/mpage.c
@@ -641,14 +641,6 @@ out:
  *
  * This is a library function, which implements the writepages()
  * address_space_operation.
- *
- * If a page is already under I/O, generic_writepages() skips it, even
- * if it's dirty.  This is desirable behaviour for memory-cleaning writeback,
- * but it is INCORRECT for data-integrity system calls such as fsync().  fsync()
- * and msync() need to guarantee that all the data which was dirty at the time
- * the call was made get new I/O started against them.  If wbc->sync_mode is
- * WB_SYNC_ALL then we were called for data integrity and we must wait for
- * existing IO to complete.
  */
 int
 mpage_writepages(struct address_space *mapping,
_

Patches currently in -mm which might be from hch@lst.de are


