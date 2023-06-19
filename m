Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0667EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 18:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjFSSk2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 14:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbjFSSk2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 14:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E4D198
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 11:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A783860E73
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 18:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0439CC433C8;
        Mon, 19 Jun 2023 18:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687200026;
        bh=ssleOC+61+X12DQIF7j7MQBX0QbQAsRA1lxSHSkPBxM=;
        h=Date:To:From:Subject:From;
        b=hMEyE3bfzpMnVuFPd1mU0D1QTKtX43KjguO5pQqxicyJBN4+NTICHSDQ03Az4EPQo
         8BsG/c2EQ07piPsxcwnCFEnKTbsHV89DADht67ZhsxJycblEPM8oJIKmtftSDjHSHW
         P+tyEHzzPVldvf/6mZSDl0EO8bVYE90YHW3ACnNw=
Date:   Mon, 19 Jun 2023 11:40:25 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4.patch added to mm-unstable branch
Message-Id: <20230619184026.0439CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4
Date: Mon, 19 Jun 2023 10:22:24 +0800

limit next_ptn to not exceed cc->free_pfn

Link: https://lkml.kernel.org/r/a1d859c28af0c7e85e91795e7473f553eb180a9d.1686813379.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4
+++ a/mm/compaction.c
@@ -1987,7 +1987,7 @@ static isolate_migrate_t isolate_migrate
 
 			next_pfn = skip_offline_sections(block_start_pfn);
 			if (next_pfn)
-				block_end_pfn = next_pfn;
+				block_end_pfn = min(next_pfn, cc->free_pfn);
 			continue;
 		}
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages.patch
mm-compaction-skip-memory-hole-rapidly-when-isolating-migratable-pages-v4.patch

