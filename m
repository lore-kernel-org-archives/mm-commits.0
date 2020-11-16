Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05699C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE96820702
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:10:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMy4HVBv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgKPUJy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:09:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbgKPUJx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 15:09:53 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C62F220702;
        Mon, 16 Nov 2020 20:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605557393;
        bh=qIyVHhcRjnA/IkJ4RVpypkZwWzltR2iZmdA3N87JTFw=;
        h=Date:From:To:Subject:From;
        b=iMy4HVBvvr4IRNwxRWorLvZBu2Fo3u0Y8VmT8RKkyXifzflQQYH75q2rDKygCAyEm
         hok6mrddb79MRRFzPk2MNt/Aw1KcL4eI2w8Vz02EG9lQAEXXgwh3SU86gtvUI8moxn
         beBNUBn+tIzsTtQY3Vobbl65xIrve/azV/7URN+w=
Date:   Mon, 16 Nov 2020 12:09:52 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sh_def@163.com
Subject:  +
 mm-compaction-move-compaction_suitables-comment-to-right-place.patch added
 to -mm tree
Message-ID: <20201116200952.o_yJuZqBS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: move compaction_suitable's comment to right place
has been added to the -mm tree.  Its filename is
     mm-compaction-move-compaction_suitables-comment-to-right-place.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-move-compaction_suitables-comment-to-right-place.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-move-compaction_suitables-comment-to-right-place.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/compaction: move compaction_suitable's comment to right place

Since commit 837d026d560c ("mm/compaction: more trace to understand
when/why compaction start/finish"), the comment place is not suitable.

So move compaction_suitable's comment to right place.

Link: https://lkml.kernel.org/r/20201116144121.GA385717@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/compaction.c~mm-compaction-move-compaction_suitables-comment-to-right-place
+++ a/mm/compaction.c
@@ -2070,13 +2070,6 @@ static enum compact_result compact_finis
 	return ret;
 }
 
-/*
- * compaction_suitable: Is this suitable to run compaction on this zone now?
- * Returns
- *   COMPACT_SKIPPED  - If there are too few free pages for compaction
- *   COMPACT_SUCCESS  - If the allocation would succeed without compaction
- *   COMPACT_CONTINUE - If compaction should run now
- */
 static enum compact_result __compaction_suitable(struct zone *zone, int order,
 					unsigned int alloc_flags,
 					int highest_zoneidx,
@@ -2120,6 +2113,13 @@ static enum compact_result __compaction_
 	return COMPACT_CONTINUE;
 }
 
+/*
+ * compaction_suitable: Is this suitable to run compaction on this zone now?
+ * Returns
+ *   COMPACT_SKIPPED  - If there are too few free pages for compaction
+ *   COMPACT_SUCCESS  - If the allocation would succeed without compaction
+ *   COMPACT_CONTINUE - If compaction should run now
+ */
 enum compact_result compaction_suitable(struct zone *zone, int order,
 					unsigned int alloc_flags,
 					int highest_zoneidx)
_

Patches currently in -mm which might be from sh_def@163.com are

mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch
mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
mm-compaction-move-compaction_suitables-comment-to-right-place.patch
mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch
acctc-use-elif-instead-of-end-and-elif.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

