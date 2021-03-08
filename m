Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D4DC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 22:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 140E965252
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 22:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhCHWsB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:48:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230122AbhCHWrq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 17:47:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B916D65252;
        Mon,  8 Mar 2021 22:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615243665;
        bh=bXUE/9tlMMPDUkcNAAeqdFno+ucweT9+t4VdAedyqQ8=;
        h=Date:From:To:Subject:From;
        b=dNGQw8lnuAZxR8+ZGEj9hUbVbC9RBqUTfny6Mj/B5UIkqfBKr5prj9tD1A7uu8qmN
         o08nc1q7KzWb3lBlAxlKBVYzgcHKa9DlaSzINDTKaXANXVlkA0aYYYcSvvaJqXYMV1
         9zMUDLSI62wGlnL+86htp2o/zUoo/5WqllY4L3Tg=
Date:   Mon, 08 Mar 2021 14:47:45 -0800
From:   akpm@linux-foundation.org
To:     charante@codeaurora.org, mm-commits@vger.kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  + mm-compaction-update-the-compact-events-properly.patch
 added to -mm tree
Message-ID: <20210308224745.LrpoxdnBG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: update the COMPACT[STALL|FAIL] events properly
has been added to the -mm tree.  Its filename is
     mm-compaction-update-the-compact-events-properly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-update-the-compact-events-properly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-update-the-compact-events-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2494,6 +2494,14 @@ static enum compact_result compact_zone_
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
@@ -4181,6 +4181,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	memalloc_noreclaim_restore(noreclaim_flag);
 	psi_memstall_leave(&pflags);
 
+	if (*compact_result == COMPACT_SKIPPED)
+		return NULL;
 	/*
 	 * At least in one zone compaction wasn't deferred or skipped, so let's
 	 * count a compaction stall
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-compaction-update-the-compact-events-properly.patch

