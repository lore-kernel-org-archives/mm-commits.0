Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06039C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB25D61182
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhEEBhs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231963AbhEEBhs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC12661029;
        Wed,  5 May 2021 01:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178612;
        bh=zBgcdasPnO3k59Efi5IngddrS8K1mrvVMSS8p+mjlAU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bikJbos4w2Y9qnVEUJrPKPPAsOvWrhfi/GqerjWXpVXksQDZyLltW+n9COLGnfPd/
         SGoVJIcugK8KYnRN0jyxa7F2CCrHsJRn+CnQozXHVtSN3kJGE1GiIFoRWZD9zVetJG
         wTq59jmvQhdic6xD7CijRAwqZ8d9NmQYHOCXCIUg=
Date:   Tue, 04 May 2021 18:36:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, charante@codeaurora.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 076/143] mm: compaction: update the
 COMPACT[STALL|FAIL] events properly
Message-ID: <20210505013651.peaO1GLjv%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
