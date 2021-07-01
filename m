Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8282C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D8E261474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbhGABz7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238512AbhGABz7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E2E861468;
        Thu,  1 Jul 2021 01:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104409;
        bh=WPR0A5ldhcr/Rg+H/hGL/pWm5PGPcZZqm+EdFgccASo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iWAvY5S30A1DSuNvCDeE89n0bf9nnZ7MR8ABqZerBALHNuP7M0iIXq2As79bqx8XH
         FwVJ9fts9mbP5WZVyhuvycCLU3LtGUhayhMg1DmADVIwQi9pRT3U2cZdj1QJjfPaWk
         KkrwtzR52SP1PLFTHK68QkD1dMfkhrOJucv42HM4=
Date:   Wed, 30 Jun 2021 18:53:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 118/192] mm/mapping_dirty_helpers: remove double
 Note in kerneldoc
Message-ID: <20210701015329.whOMTfvhF%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/mapping_dirty_helpers: remove double Note in kerneldoc

make W=1 generates the following warning for mm/mapping_dirty_helpers.c

mm/mapping_dirty_helpers.c:325: warning: duplicate section name 'Note'

The helper function is very specific to one driver -- vmwgfx.  While the
two notes are separate, all of it needs to be taken into account when
using the helper so make it one note.

Link: https://lkml.kernel.org/r/20210520084809.8576-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mapping_dirty_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mapping_dirty_helpers.c~mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc
+++ a/mm/mapping_dirty_helpers.c
@@ -317,7 +317,7 @@ EXPORT_SYMBOL_GPL(wp_shared_mapping_rang
  * pfn_mkwrite(). And then after a TLB flush following the write-protection
  * pick up all dirty bits.
  *
- * Note: This function currently skips transhuge page-table entries, since
+ * This function currently skips transhuge page-table entries, since
  * it's intended for dirty-tracking on the PTE level. It will warn on
  * encountering transhuge dirty entries, though, and can easily be extended
  * to handle them as well.
_
