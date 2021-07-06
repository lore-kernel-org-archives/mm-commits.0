Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6F7C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44FC661C9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhGFTXq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGFTXq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72B3361C9A;
        Tue,  6 Jul 2021 19:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599266;
        bh=Dhqeen+5l5OmY04q/0yWn8fnDpPF9CD04+cES4KKq54=;
        h=Date:From:To:Subject:From;
        b=C9sZz1K9q9t/B/zQozyxmk85W39WOUxnMGB/qnfrFtSX1rr7iH2lhTlETLDEPVL3u
         dSqK6eZ+Ojxkj0EGhoCB+5ogIgroXo+0KeiVFP6NhhFqFudNG7HPEIoEm7NWN0TA+0
         HABluJ3my3Hf5uRDPH0P3VcsH9Fn7TRh6qL1BpcM=
Date:   Tue, 06 Jul 2021 12:21:06 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  [merged] mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch
 removed from -mm tree
Message-ID: <20210706192106.HxPpxNgk4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: add kerneldoc fields for zbud_pool
has been removed from the -mm tree.  Its filename was
     mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/zbud: add kerneldoc fields for zbud_pool

make W=1 generates the following warning for zbud_pool

  mm/zbud.c:105: warning: Function parameter or member 'zpool' not described in 'zbud_pool'
  mm/zbud.c:105: warning: Function parameter or member 'zpool_ops' not described in 'zbud_pool'

Commit 479305fd7172 ("zpool: remove zpool_evict()") removed the
zpool_evict helper and added the associated zpool and operations structure
in struct zbud_pool but did not add documentation for the fields.  Add
rudimentary documentation.

Link: https://lkml.kernel.org/r/20210520084809.8576-10-mgorman@techsingularity.net
Fixes: 479305fd7172 ("zpool: remove zpool_evict()")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/zbud.c~mm-zbud-add-kerneldoc-fields-for-zbud_pool
+++ a/mm/zbud.c
@@ -92,6 +92,8 @@ struct zbud_ops {
  * @pages_nr:	number of zbud pages in the pool.
  * @ops:	pointer to a structure of user defined operations specified at
  *		pool creation time.
+ * @zpool:	zpool driver
+ * @zpool_ops:	zpool operations structure with an evict callback
  *
  * This structure is allocated at pool creation time and maintains metadata
  * pertaining to a particular zbud pool.
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


