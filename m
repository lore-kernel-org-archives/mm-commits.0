Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198D4EE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjHUUIM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjHUUIL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:08:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9620130;
        Mon, 21 Aug 2023 13:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8872649ED;
        Mon, 21 Aug 2023 20:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255CFC433C7;
        Mon, 21 Aug 2023 20:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692648488;
        bh=1SfLfLGkNMexqQK7KF1ntbtVTPdlZgium+x21G97yJU=;
        h=Date:To:From:Subject:From;
        b=PrNWmN5nsmSrZlGeprzRjHdONAYYdOOO1BCSnlA1aJZWdbPu21fIFifRXpRRsz51Y
         tCsEKbHGkryHmveIJ7ZN9x3rYVbOqOabrX5bFjc7bb5cqeACoMW9X6u8B/Y2ARrsko
         JrUNutiGD7NLxGSskHKB8ngsrBEVcx+lfHMzupyw=
Date:   Mon, 21 Aug 2023 13:08:07 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-general-protection-fault-in-nilfs_lookup_dirty_data_buffers.patch removed from -mm tree
Message-Id: <20230821200808.255CFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: fix general protection fault in nilfs_lookup_dirty_data_buffers()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-general-protection-fault-in-nilfs_lookup_dirty_data_buffers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix general protection fault in nilfs_lookup_dirty_data_buffers()
Date: Sat, 5 Aug 2023 22:20:38 +0900

A syzbot stress test reported that create_empty_buffers() called from
nilfs_lookup_dirty_data_buffers() can cause a general protection fault.

Analysis using its reproducer revealed that the back reference "mapping"
from a page/folio has been changed to NULL after dirty page/folio gang
lookup in nilfs_lookup_dirty_data_buffers().

Fix this issue by excluding pages/folios from being collected if, after
acquiring a lock on each page/folio, its back reference "mapping" differs
from the pointer to the address space struct that held the page/folio.

Link: https://lkml.kernel.org/r/20230805132038.6435-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+0ad741797f4565e7e2d2@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000002930a705fc32b231@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nilfs2/segment.c~nilfs2-fix-general-protection-fault-in-nilfs_lookup_dirty_data_buffers
+++ a/fs/nilfs2/segment.c
@@ -725,6 +725,11 @@ static size_t nilfs_lookup_dirty_data_bu
 		struct folio *folio = fbatch.folios[i];
 
 		folio_lock(folio);
+		if (unlikely(folio->mapping != mapping)) {
+			/* Exclude folios removed from the address space */
+			folio_unlock(folio);
+			continue;
+		}
 		head = folio_buffers(folio);
 		if (!head) {
 			create_empty_buffers(&folio->page, i_blocksize(inode), 0);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-warning-in-mark_buffer_dirty-due-to-discarded-buffer-reuse.patch

