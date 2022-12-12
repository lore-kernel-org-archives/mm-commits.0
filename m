Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8FFC4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiLLCOj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiLLCOI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDDAB1DE
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B90260E77
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9F9C433F2;
        Mon, 12 Dec 2022 02:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811238;
        bh=N1igBjzX8NNp5ppnEc1PKUxQDo/ByQRuHhQ+z78YEUs=;
        h=Date:To:From:Subject:From;
        b=pVpgPadBgAYWqFmxg9sZqBbF18StCJ6NCdxUjpZxp6rKvG+6p4TmTScjE4pLdM0t0
         Qn6gNknQtYvFnhbJCerOywkX+TVdluGr9AqYSYRgThvvZ6jS2+oUyZ1f0oSvHfNZC/
         ynLAVBwdiQLbscn5BZt25+wRxagBOEUwwSrHyitY=
Date:   Sun, 11 Dec 2022 18:13:57 -0800
To:     mm-commits@vger.kernel.org, hch@lst.de, bfoster@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fadvise-use-llong_max-instead-of-1-for-eof.patch removed from -mm tree
Message-Id: <20221212021358.5E9F9C433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/fadvise: use LLONG_MAX instead of -1 for eof
has been removed from the -mm tree.  Its filename was
     mm-fadvise-use-llong_max-instead-of-1-for-eof.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brian Foster <bfoster@redhat.com>
Subject: mm/fadvise: use LLONG_MAX instead of -1 for eof
Date: Mon, 28 Nov 2022 10:56:32 -0500

generic_fadvise() sets endbyte = -1 to specify end of file (i.e.  if
length == 0 is passed from userspace).  Most other callers to
filemap_fdatawrite_range() use LLONG_MAX for this purpose, particularly if
they also call fdatawait_range() (which requires end >= start).  For
example, sync_file_range(), vfs_fsync() (where the range is passed down
through per-fs ->fsync() callbacks), filemap_flush(), etc. 
generic_fadvise() does not currently wait on writeback, but fix the call
up to be consistent with other callers.

Link: https://lkml.kernel.org/r/20221128155632.3950447-3-bfoster@redhat.com
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/fadvise.c~mm-fadvise-use-llong_max-instead-of-1-for-eof
+++ a/mm/fadvise.c
@@ -72,7 +72,7 @@ int generic_fadvise(struct file *file, l
 	 */
 	endbyte = (u64)offset + (u64)len;
 	if (!len || endbyte < len)
-		endbyte = -1;
+		endbyte = LLONG_MAX;
 	else
 		endbyte--;		/* inclusive */
 
_

Patches currently in -mm which might be from bfoster@redhat.com are


