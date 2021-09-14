Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E49C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 02:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB7E61108
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 02:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237372AbhINCyX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236953AbhINCyV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Sep 2021 22:54:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B36CC610FB;
        Tue, 14 Sep 2021 02:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631587984;
        bh=+R3Ds0Q+vLEip2A0UKCBa6BbcgcM+QxweeoyiFiw2Cs=;
        h=Date:From:To:Subject:From;
        b=sFZQag3l/PHYhDdK/mOw7bVnE/ucTWQyJRsi+u1F4MOkIDJUnQgWoSztMIS6Wn6M5
         cdqS8kqQczS6LlYmGK1ndIR8Cl6A5HB4NUB/rWfOvY9t5BJv1plzX/HT8oU5BquOR5
         JcKPMwLRhPKugxFyBR8k7GdDWHMJP6C5Ee+IjGEU=
Date:   Mon, 13 Sep 2021 19:53:04 -0700
From:   akpm@linux-foundation.org
To:     elver@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        oliver.sang@intel.com, will@kernel.org
Subject:  + mm-fix-data-race-in-pagepoisoned.patch added to -mm
 tree
Message-ID: <20210914025304.ant7cRvkO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix data race in PagePoisoned()
has been added to the -mm tree.  Its filename is
     mm-fix-data-race-in-pagepoisoned.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-data-race-in-pagepoisoned.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-data-race-in-pagepoisoned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Will Deacon <will@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-fix-data-race-in-pagepoisoned
+++ a/include/linux/page-flags.h
@@ -206,7 +206,7 @@ static __always_inline int PageCompound(
 #define	PAGE_POISON_PATTERN	-1l
 static inline int PagePoisoned(const struct page *page)
 {
-	return page->flags == PAGE_POISON_PATTERN;
+	return READ_ONCE(page->flags) == PAGE_POISON_PATTERN;
 }
 
 #ifdef CONFIG_DEBUG_VM
_

Patches currently in -mm which might be from elver@google.com are

kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address.patch
mm-fix-data-race-in-pagepoisoned.patch

