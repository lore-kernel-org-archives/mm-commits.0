Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C8EC61DA3
	for <mm-commits@archiver.kernel.org>; Tue, 21 Feb 2023 23:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjBUX1K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Feb 2023 18:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBUX1J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2023 18:27:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE79B30291
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2023 15:27:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7382961208
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2023 23:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C028FC4339C;
        Tue, 21 Feb 2023 23:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677022027;
        bh=dFPRcOfORE2PNtNmWD46QtYc0mrpynrkar2Tb8Sph3c=;
        h=Date:To:From:Subject:From;
        b=ZhRUU57vnu07zO6cvbPLIVv7q/+rgPcBteQcs1/aDoVMt4tC2C9LmFYPE2GCfqoMM
         8IofYooDXE67DMGYhSXt2dlo7YtzkYyRChIMXIhyMTQ3fO5Gxyodb7K8IgQLT7AXVo
         UhXviKFu8ZrqMZK5v+WN885cRYVJtRBLGoUjURgI=
Date:   Tue, 21 Feb 2023 15:27:06 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        agruenba@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-gfs2-logc-fix-build-in-__gfs2_writepage.patch added to mm-nonmm-unstable branch
Message-Id: <20230221232707.C028FC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/gfs2/log.c: fix build in  __gfs2_writepage()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-gfs2-logc-fix-build-in-__gfs2_writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-gfs2-logc-fix-build-in-__gfs2_writepage.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/gfs2/log.c: fix build in  __gfs2_writepage()
Date: Tue Feb 21 03:23:08 PM PST 2023

mm-stable was based on 6.2-rc4 and hence its patch d585bdbeb79a ("fs:
convert writepage_t callback to pass a folio") didn't know about the
post-rc4 95ecbd0f162f ("Revert "gfs2: stop using generic_writepages in
gfs2_ail1_start_one"").

Net result is that d585bdbeb79a failed to convert fs/gfs2/log.c.  The fix
is from Andreas.

Reported-by: Andreas Gruenbacher <agruenba@redhat.com>
  Link: https://lkml.kernel.org/r/20230203105401.3362277-1-agruenba@redhat.com
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/gfs2/log.c~fs-gfs2-logc-fix-build-in-__gfs2_writepage
+++ a/fs/gfs2/log.c
@@ -80,11 +80,11 @@ void gfs2_remove_from_ail(struct gfs2_bu
 	brelse(bd->bd_bh);
 }
 
-static int __gfs2_writepage(struct page *page, struct writeback_control *wbc,
-		       void *data)
+static int __gfs2_writepage(struct folio *folio, struct writeback_control *wbc,
+			    void *data)
 {
 	struct address_space *mapping = data;
-	int ret = mapping->a_ops->writepage(page, wbc);
+	int ret = mapping->a_ops->writepage(&folio->page, wbc);
 	mapping_set_error(mapping, ret);
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-gfs2-logc-fix-build-in-__gfs2_writepage.patch

