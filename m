From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xtensa-implement-flush_icache_user_range-fix.patch
 added to -mm tree
Date: Wed, 27 May 2020 17:16:44 -0700
Message-ID: <20200528001644.CQk9YrkKu%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgE1AQp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 20:16:45 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@zankel.net, hch@lst.de, jcmvbkbc@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: fix flush_icache_user_range in noMMU configs
has been added to the -mm tree.  Its filename is
     xtensa-implement-flush_icache_user_range-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xtensa-implement-flush_icache_user_range-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xtensa-implement-flush_icache_user_range-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: xtensa: fix flush_icache_user_range in noMMU configs

flush_icache_user_range definition for xtensa is placed under preprocessor
condition that is not processed in noMMU configurations, resulting in the
following build errors:

  fs/exec.c:1065:3: error: implicit declaration of function
  `flush_icache_user_range'
  fs/binfmt_flat.c:857:2: error: implicit declaration of function
  `flush_icache_user_range'

Move definition outside conditional compilation block.

Link: http://lkml.kernel.org/r/20200525221556.4270-1-jcmvbkbc@gmail.com
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/cacheflush.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/xtensa/include/asm/cacheflush.h~xtensa-implement-flush_icache_user_range-fix
+++ a/arch/xtensa/include/asm/cacheflush.h
@@ -107,8 +107,6 @@ void flush_cache_page(struct vm_area_str
 #define flush_cache_page  local_flush_cache_page
 #endif
 
-#define flush_icache_user_range flush_icache_range
