Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD4FC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiLOXKQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiLOXJl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:09:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5574760354
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:09:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8CF761F92
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8FCC433D2;
        Thu, 15 Dec 2022 23:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145774;
        bh=z4VzPaUm+SQL1296eLKUIYTWwOFSOINqe/7qtVXMlpc=;
        h=Date:To:From:Subject:From;
        b=SejFehGV4Y6+DsIVNntRqbaAdzxckc91gmGwgb24tVK0q7gbij6tnTci/v9pjP96D
         Out2a7k37pVZzn4VwodaxlNJydm8p+lqId38f5MSoRosXMDcYd1zkokwe/V+JD1shO
         6Ueh0r5yedtyrAS87bvKuE7m3czbHVDsXNiPqJos=
Date:   Thu, 15 Dec 2022 15:09:33 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + page_io-remove-buffer_head-include.patch added to mm-unstable branch
Message-Id: <20221215230934.4F8FCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: page_io: remove buffer_head include
has been added to the -mm mm-unstable branch.  Its filename is
     page_io-remove-buffer_head-include.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/page_io-remove-buffer_head-include.patch

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
Subject: page_io: remove buffer_head include
Date: Thu, 15 Dec 2022 21:43:56 +0000

page_io never uses buffer_heads to do I/O.

Link: https://lkml.kernel.org/r/20221215214402.3522366-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_io.c~page_io-remove-buffer_head-include
+++ a/mm/page_io.c
@@ -18,7 +18,6 @@
 #include <linux/swap.h>
 #include <linux/bio.h>
 #include <linux/swapops.h>
-#include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/frontswap.h>
 #include <linux/blkdev.h>
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch

