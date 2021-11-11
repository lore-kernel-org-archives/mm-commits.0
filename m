Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91561C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B05B6113B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbhKKCrS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234310AbhKKCrS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A193F6103C;
        Thu, 11 Nov 2021 02:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598669;
        bh=nZcLmRAzSYsuMakPpA8NK5uMTQgXNiyS/yG/JOpTQ04=;
        h=Date:From:To:Subject:From;
        b=qtm8U7pS5LNciHi+O55ywjgFTYfUH/0YYjNxttOiVVFx/kglr6o2lSrOkTyW3VHGL
         6kxAujDEIJ/Bdo+ka2TlNstlu56TFMSWYWVmhlCykI04xEfmLnNBXaMNm4pzLSEcsI
         KTRvX20CQtKHSuCNdRN8RP6yUuyrM7MKT9GbBbZM=
Date:   Wed, 10 Nov 2021 18:44:29 -0800
From:   akpm@linux-foundation.org
To:     elver@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        oliver.sang@intel.com, will@kernel.org
Subject:  [merged] mm-fix-data-race-in-pagepoisoned.patch removed
 from -mm tree
Message-ID: <20211111024429.V-Y4Zjmpg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix data race in PagePoisoned()
has been removed from the -mm tree.  Its filename was
     mm-fix-data-race-in-pagepoisoned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from elver@google.com are


