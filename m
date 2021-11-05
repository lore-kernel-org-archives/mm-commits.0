Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2871C43217
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9058561262
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhKEUnj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233485AbhKEUnj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3685611C0;
        Fri,  5 Nov 2021 20:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144859;
        bh=FJ117JC7W34jlEpL/A9WwXWOZvE/GIu5k4dPVvRpWhg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LqRfLvajSIolyrWcrw1gj03FmGbXqEKxHp8HVRzSc1zAMiq18vwCxMzwIH4Q/q0eM
         GnnElNvUXF3vUAx2oegpiDCHknrBsaXCSFTN6rviddYuZcg7q1lL4unRHiTj4od0/8
         yMTxBDcIUnvE4CPIriYSbVuuEYo74FUWs6DGVE+M=
Date:   Fri, 05 Nov 2021 13:40:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, elver@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        oliver.sang@intel.com, torvalds@linux-foundation.org,
        will@kernel.org
Subject:  [patch 121/262] mm: fix data race in PagePoisoned()
Message-ID: <20211105204058.ifx3dDphm%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: mm: fix data race in PagePoisoned()

PagePoisoned() accesses page->flags which can be updated concurrently:

  | BUG: KCSAN: data-race in next_uptodate_page / unlock_page
  |
  | write (marked) to 0xffffea00050f37c0 of 8 bytes by task 1872 on cpu 1:
  |  instrument_atomic_write           include/linux/instrumented.h:87 [inline]
  |  clear_bit_unlock_is_negative_byte include/asm-generic/bitops/instrumented-lock.h:74 [inline]
  |  unlock_page+0x102/0x1b0           mm/filemap.c:1465
  |  filemap_map_pages+0x6c6/0x890     mm/filemap.c:3057
  |  ...
  | read to 0xffffea00050f37c0 of 8 bytes by task 1873 on cpu 0:
  |  PagePoisoned                   include/linux/page-flags.h:204 [inline]
  |  PageReadahead                  include/linux/page-flags.h:382 [inline]
  |  next_uptodate_page+0x456/0x830 mm/filemap.c:2975
  |  ...
  | CPU: 0 PID: 1873 Comm: systemd-udevd Not tainted 5.11.0-rc4-00001-gf9ce0be71d1f #1

To avoid the compiler tearing or otherwise optimizing the access, use
READ_ONCE() to access flags.

Link: https://lore.kernel.org/all/20210826144157.GA26950@xsang-OptiPlex-9020/
Link: https://lkml.kernel.org/r/20210913113542.2658064-1-elver@google.com
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-fix-data-race-in-pagepoisoned
+++ a/include/linux/page-flags.h
@@ -215,7 +215,7 @@ static __always_inline int PageCompound(
 #define	PAGE_POISON_PATTERN	-1l
 static inline int PagePoisoned(const struct page *page)
 {
-	return page->flags == PAGE_POISON_PATTERN;
+	return READ_ONCE(page->flags) == PAGE_POISON_PATTERN;
 }
 
 #ifdef CONFIG_DEBUG_VM
_
