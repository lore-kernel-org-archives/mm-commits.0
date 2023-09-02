Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91F0C71153
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbjIBWim (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbjIBWil (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:38:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B24CED
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F9D36130C
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE30C433C7;
        Sat,  2 Sep 2023 22:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693694317;
        bh=kT0F/lkvjDPTKp1RYU61HzNS9eq8UBSu6xrFmfdZX5Q=;
        h=Date:To:From:Subject:From;
        b=u4UcTmxFDQ7ZPhDrNSuKI+jMeMgIHtF0oGn4I69+aRyJm+DPafFpPT2SQ1r4yDtgi
         OhiggaV2B2343mmrAKU8FMHglKQlE35kIqvi1ixC7rtEUh1MR7I9PemYT+yPFXwIwA
         ic12fPJQnkVTTUikZCcSNhjprCCEBR7SiSF/R/Gw=
Date:   Sat, 02 Sep 2023 15:38:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-improve-comment-of-is_via_compact_memory.patch added to mm-unstable branch
Message-Id: <20230902223836.DDE30C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: improve comment of is_via_compact_memory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-improve-comment-of-is_via_compact_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-improve-comment-of-is_via_compact_memory.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: improve comment of is_via_compact_memory
Date: Fri, 1 Sep 2023 23:51:40 +0800

We do proactive compaction with order == -1 via
1. /proc/sys/vm/compact_memory
2. /sys/devices/system/node/nodex/compact
3. /proc/sys/vm/compaction_proactiveness
Add missed situation in which order == -1.

Link: https://lkml.kernel.org/r/20230901155141.249860-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-improve-comment-of-is_via_compact_memory
+++ a/mm/compaction.c
@@ -2065,8 +2065,10 @@ static isolate_migrate_t isolate_migrate
 }
 
 /*
- * order == -1 is expected when compacting via
- * /proc/sys/vm/compact_memory
+ * order == -1 is expected when compacting proactively via
+ * 1. /proc/sys/vm/compact_memory
+ * 2. /sys/devices/system/node/nodex/compact
+ * 3. /proc/sys/vm/compaction_proactiveness
  */
 static inline bool is_via_compact_memory(int order)
 {
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-compaction-use-correct-list-in-move_freelist_head-tail.patch
mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch
mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch
mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch
mm-compaction-improve-comment-of-is_via_compact_memory.patch
mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch

