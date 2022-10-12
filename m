Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F02C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 19:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiJLTkM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 15:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJLTkJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 15:40:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0513D2FFC8
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 12:40:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A79CFB81AD1
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 19:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E25C433D6;
        Wed, 12 Oct 2022 19:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665603606;
        bh=39O432H1Sov6eZ57/wugtR9+1YdZBhc9jO2xh4Jnzt8=;
        h=Date:To:From:Subject:From;
        b=lVfHeq6lX2EYaRRjB7q8Gtcf3S2h+g1hnYOq3PjcYygrR3LVqaD+Za96X3BMV4G5j
         C5/2QKKhw1yD8e7cbT8Mz2HTu6m0LcN9yf6GB2w5OxEzDgCI1ftWi3goecreUhWgfs
         xh0aXwlkhBnPmMGpSO5rSWUISfb9E50RQHCYfUpM=
Date:   Wed, 12 Oct 2022 12:40:05 -0700
To:     mm-commits@vger.kernel.org, nicememory@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ext4f2fs-fix-readahead-of-verity-data.patch added to mm-unstable branch
Message-Id: <20221012194006.52E25C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ext4,f2fs: fix readahead of verity data
has been added to the -mm mm-unstable branch.  Its filename is
     ext4f2fs-fix-readahead-of-verity-data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ext4f2fs-fix-readahead-of-verity-data.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ext4,f2fs: fix readahead of verity data
Date: Wed, 12 Oct 2022 20:34:19 +0100

The recent change of page_cache_ra_unbounded() arguments was buggy in the
two callers, causing us to readahead the wrong pages.  Move the definition
of ractl down to after the index is set correctly.  This affected
performance on configurations that use fs-verity.

Link: https://lkml.kernel.org/r/20221012193419.1453558-1-willy@infradead.org
Fixes: 73bb49da50cd ("mm/readahead: make page_cache_ra_unbounded take a readahead_control")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Jintao Yin <nicememory@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/verity.c |    3 ++-
 fs/f2fs/verity.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/verity.c~ext4f2fs-fix-readahead-of-verity-data
+++ a/fs/ext4/verity.c
@@ -365,13 +365,14 @@ static struct page *ext4_read_merkle_tre
 					       pgoff_t index,
 					       unsigned long num_ra_pages)
 {
-	DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
 	struct page *page;
 
 	index += ext4_verity_metadata_pos(inode) >> PAGE_SHIFT;
 
 	page = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
 	if (!page || !PageUptodate(page)) {
+		DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
+
 		if (page)
 			put_page(page);
 		else if (num_ra_pages > 1)
--- a/fs/f2fs/verity.c~ext4f2fs-fix-readahead-of-verity-data
+++ a/fs/f2fs/verity.c
@@ -262,13 +262,14 @@ static struct page *f2fs_read_merkle_tre
 					       pgoff_t index,
 					       unsigned long num_ra_pages)
 {
-	DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
 	struct page *page;
 
 	index += f2fs_verity_metadata_pos(inode) >> PAGE_SHIFT;
 
 	page = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
 	if (!page || !PageUptodate(page)) {
+		DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
+
 		if (page)
 			put_page(page);
 		else if (num_ra_pages > 1)
_

Patches currently in -mm which might be from willy@infradead.org are

ext4f2fs-fix-readahead-of-verity-data.patch

