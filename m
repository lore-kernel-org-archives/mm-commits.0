Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE26C4321E
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 20:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbiLBUMb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiLBULt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 15:11:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10643F37FC
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 12:11:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB0C1B82289
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 20:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC09C433C1;
        Fri,  2 Dec 2022 20:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670011905;
        bh=TJfI63bRN5SU4n7VbIBP2tLSag4POen8Li6oqmvXl3E=;
        h=Date:To:From:Subject:From;
        b=rdLMX5KH4UtQgGZQNkVKl00VL95kikZhruCkXDWtyzfvgNSP/CzuFQBJA1qMIMe6T
         pWKenGW/bKjnyY8hG56+rXH/KVNw/QIFcY1PCB7uBugRjVtppLk8AkF+67z2PPBPNK
         QTFCwlOBujO0cjRnLHAKFeNqa6E128itI5IV/0qY=
Date:   Fri, 02 Dec 2022 12:11:44 -0800
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hfsplus-remove-writepage.patch added to mm-unstable branch
Message-Id: <20221202201145.6BC09C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: remove ->writepage
has been added to the -mm mm-unstable branch.  Its filename is
     hfsplus-remove-writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfsplus-remove-writepage.patch

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

extfat-remove-writepage.patch
fat-remove-writepage.patch
hfs-remove-writepage.patch
hfsplus-remove-writepage.patch
hpfs-remove-writepage.patch
jfs-remove-writepage.patch
omfs-remove-writepage.patch

