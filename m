Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6A6C11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7FEC61476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238515AbhGABzv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238512AbhGABzv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52EDF61476;
        Thu,  1 Jul 2021 01:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104400;
        bh=0+k8hs9ibwYdtLOuFHRuoU7n23xeI1sRZIOL6RVMXtg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Eyyog4ffAXg92KptTjfNsbZLC+0t8l2/2i6vd887hhbGzB3bdhX9k1ZgZ3XEr6Em7
         bAl1KbZIBrhmDb2ym9MsA3Y9mWzXIWWGvaCfv03OpLr0XXKoq1IEZKzPqFm6AVN8sW
         tsN2oshs2/P0YZkiQuUQSrIAa2JQmrVZDmLVb5Z4=
Date:   Wed, 30 Jun 2021 18:53:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 115/192] mm/vmscan: remove kerneldoc-like comment
 from isolate_lru_pages
Message-ID: <20210701015319.iIB49_A3s%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/vmscan: remove kerneldoc-like comment from isolate_lru_pages

Patch series "Clean W=1 build warnings for mm/".

This is a janitorial only.  During development of a tool to catch build
warnings early to avoid tripping the Intel lkp-robot, I noticed that mm/
is not clean for W=1.  This is generally harmless but there is no harm in
cleaning it up.  It disrupts git blame a little but on relatively obvious
lines that are unlikely to be git blame targets.


This patch (of 13):

make W=1 generates the following warning for vmscan.c

    mm/vmscan.c:1814: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

It is not a kerneldoc comment and isolate_lru_pages() is a static
function.  While the detailed comment is nice, it does not need to be
exposed via kernel-doc.

Link: https://lkml.kernel.org/r/20210520084809.8576-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20210520084809.8576-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages
+++ a/mm/vmscan.c
@@ -1821,7 +1821,7 @@ static __always_inline void update_lru_s
 
 }
 
-/**
+/*
  * Isolating page from the lruvec to fill in @dst list by nr_to_scan times.
  *
  * lruvec->lru_lock is heavily contended.  Some of the functions that
_
