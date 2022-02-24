Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33851C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiBXEFU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiBXEFU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:05:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FD51693BE
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:04:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 564D8B8219E
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 04:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43B6C340E9;
        Thu, 24 Feb 2022 04:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645675488;
        bh=4mYGyfZntCvboTMjIiUmgUZfIXRNi3DV9loea0JPU2c=;
        h=Date:To:From:Subject:From;
        b=IPzrzQHMpjxyRzz6JONTOeVQs8rBOGQEPao3YPWRK0J42rw0eyMbGLfatY8skWYuh
         syK9mpoUmjqzTS47/lr0oyZM81DFGmhSlvqUX7+hyd19Sr4eARuE2a2rSTIuEX4qhc
         lDUdxMzaZdgtjNrDvu8yU2d7NY/8CbiPHB4jpjqs=
Date:   Wed, 23 Feb 2022 20:04:47 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-argument-list-that-the-kdoc-format-and-script-verified.patch added to -mm tree
Message-Id: <20220224040447.E43B6C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix argument list that the kdoc format and script verified.
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-argument-list-that-the-kdoc-format-and-script-verified.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-argument-list-that-the-kdoc-format-and-script-verified.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-argument-list-that-the-kdoc-format-and-script-verified.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm/rmap: fix argument list that the kdoc format and script verified.

The warnings were found by running scripts/kernel-doc, which is
caused by using 'make W=1'.

mm/rmap.c:1684: warning: Function parameter or member 'folio' not described in 'try_to_unmap'
mm/rmap.c:1684: warning: Excess function parameter 'page' description in 'try_to_unmap'
mm/rmap.c:2086: warning: Function parameter or member 'folio' not described in 'folio_make_device_exclusive'
mm/rmap.c:2086: warning: expecting prototype for page_make_device_exclusive(). Prototype was for folio_make_device_exclusive() instead

Link: https://lkml.kernel.org/r/20220224014344.99537-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-argument-list-that-the-kdoc-format-and-script-verified
+++ a/mm/rmap.c
@@ -1696,7 +1696,7 @@ static int page_not_mapped(struct folio
 
 /**
  * try_to_unmap - try to remove all page table mappings to a page
- * @page: the page to get unmapped
+ * @folio: The folio we're currently operating on.
  * @flags: action and flags
  *
  * Tries to remove all the page table entries which are mapping this
@@ -2097,8 +2097,8 @@ static bool page_make_device_exclusive_o
 }
 
 /**
- * page_make_device_exclusive - mark the page exclusively owned by a device
- * @page: the page to replace page table entries for
+ * folio_make_device_exclusive - mark the page exclusively owned by a device
+ * @folio: The folio we're currently operating on.
  * @mm: the mm_struct where the page is expected to be mapped
  * @address: address where the page is expected to be mapped
  * @owner: passed to MMU_NOTIFY_EXCLUSIVE range notifier callbacks
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

proc-vmcore-fix-vmcore_alloc_buf-kernel-doc-comment.patch
mm-rmap-fix-argument-list-that-the-kdoc-format-and-script-verified.patch

