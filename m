Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A99C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 02:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiB1C6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiB1C6t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 21:58:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B19231375
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 18:58:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD745B80CD5
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 02:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74064C340E9;
        Mon, 28 Feb 2022 02:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646017089;
        bh=7KK4B0rH9cnfwsPiyGQT19I2Dot5/dwKDWi6vfTv5ZQ=;
        h=Date:To:From:Subject:From;
        b=cPIqFeQUN7lE2u77C4a8zcgWONGWrbFdHsAGhPorZIoykbubpmiXcIMYcrf37dxfD
         /gXkxbadqz9no6m3e8kST8MSWakw47Bt6YwqLj9Fld930XHykkkE9Uq/h0JrpcY1j3
         VYmS4MnQkDjItQXGeMn5R0mii+jW4L7GD3K4KCII=
Date:   Sun, 27 Feb 2022 18:58:08 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-rmap-fix-argument-list-that-the-kdoc-format-and-script-verified.patch removed from -mm tree
Message-Id: <20220228025809.74064C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix argument list that the kdoc format and script verified.
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-argument-list-that-the-kdoc-format-and-script-verified.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

