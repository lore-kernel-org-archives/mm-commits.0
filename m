Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA30C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 912BD61421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhEHWuC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhEHWuB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E3F66101D;
        Sat,  8 May 2021 22:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514139;
        bh=IKrlLNc56bnXSbvHlig1y+PRKVmkx+pDvbYRpavJYuI=;
        h=Date:From:To:Subject:From;
        b=nAGsSzolURqYHKwqHUxFZ/eNc/Sth7CfZ2XtM1LwSueE4KCyYYR0RcCdbZSvXLhgK
         E+EoQjPybffIYxNDmHjy+PhmXXseUX53Uk0ktc44A7P4fBNO0mLfcff+HQJ22Jfy/1
         a04oqYhjO8u16/4oxilqvY7T35wINP9b44iJQb3M=
Date:   Sat, 08 May 2021 15:48:59 -0700
From:   akpm@linux-foundation.org
To:     charante@codeaurora.org, mm-commits@vger.kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-compaction-update-the-compact-events-properly.patch removed from -mm
 tree
Message-ID: <20210508224859.cKBJI95qY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: update the COMPACT[STALL|FAIL] events properly
has been removed from the -mm tree.  Its filename was
     mm-compaction-update-the-compact-events-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm: compaction: update the COMPACT[STALL|FAIL] events properly

By definition, COMPACT[STALL|FAIL] events needs to be counted when there
is 'At least in one zone compaction wasn't deferred or skipped from the
direct compaction'.  And when compaction is skipped or deferred,
COMPACT_SKIPPED will be returned but it will still go and update these
compaction events which is wrong in the sense that COMPACT[STALL|FAIL] is
counted without even trying the compaction.

Correct this by skipping the counting of these events when COMPACT_SKIPPED
is returned for compaction.  This indirectly also avoid the unnecessary
try into the get_page_from_freelist() when compaction is not even tried.

There is a corner case where compaction is skipped but still count
COMPACTSTALL event, which is that IRQ came and freed the page and the same
is captured in capture_control.

Link: https://lkml.kernel.org/r/1613151184-21213-1-git-send-email-charante@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++++++
 mm/page_alloc.c |    2 ++
 2 files changed, 10 insertions(+)

--- a/mm/compaction.c~mm-compaction-update-the-compact-events-properly
+++ a/mm/compaction.c
@@ -2529,6 +2529,14 @@ static enum compact_result compact_zone_
 	 */
 	WRITE_ONCE(current->capture_control, NULL);
 	*capture = READ_ONCE(capc.page);
+	/*
+	 * Technically, it is also possible that compaction is skipped but
+	 * the page is still captured out of luck(IRQ came and freed the page).
+	 * Returning COMPACT_SUCCESS in such cases helps in properly accounting
+	 * the COMPACT[STALL|FAIL] when compaction is skipped.
+	 */
+	if (*capture)
+		ret = COMPACT_SUCCESS;
 
 	return ret;
 }
--- a/mm/page_alloc.c~mm-compaction-update-the-compact-events-properly
+++ a/mm/page_alloc.c
@@ -4204,6 +4204,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	memalloc_noreclaim_restore(noreclaim_flag);
 	psi_memstall_leave(&pflags);
 
+	if (*compact_result == COMPACT_SKIPPED)
+		return NULL;
 	/*
 	 * At least in one zone compaction wasn't deferred or skipped, so let's
 	 * count a compaction stall
_

Patches currently in -mm which might be from charante@codeaurora.org are


