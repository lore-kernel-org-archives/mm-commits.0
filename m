Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F6FEC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 22:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbiK1WTF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 17:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbiK1WS4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 17:18:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6428230F5C
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 14:18:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 071F9B81035
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 22:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B397DC433D7;
        Mon, 28 Nov 2022 22:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669673932;
        bh=mIYgpjpT7KpE3bSUSe4ITHXlodeO+Q0qQBF/bBSGrT4=;
        h=Date:To:From:Subject:From;
        b=2c2RuFNwgUKk8JFRJ60JpbMMvuepvSe3A5st3dBvOeDNNbWXjJ4tFS6oob+gz9NZ+
         N9p/5um10Ji8YfZw7SLJhbkughFTGVay6HXtbBmE2Lhg/lRye9Lo7FrhlKOBmjN1hr
         odfySGsuIGbyUSywI41bSsOyBNFemxtJuVXmvT1E=
Date:   Mon, 28 Nov 2022 14:18:52 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org, bfoster@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fadvise-use-llong_max-instead-of-1-for-eof.patch added to mm-unstable branch
Message-Id: <20221128221852.B397DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/fadvise: use LLONG_MAX instead of -1 for eof
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fadvise-use-llong_max-instead-of-1-for-eof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fadvise-use-llong_max-instead-of-1-for-eof.patch

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
Cc: Christoph Hellwig <hch@infradead.org>
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

filemap-skip-write-and-wait-if-end-offset-precedes-start.patch
mm-fadvise-use-llong_max-instead-of-1-for-eof.patch

