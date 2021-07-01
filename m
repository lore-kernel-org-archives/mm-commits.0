Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142FCC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10026146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbhGAB4O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB4O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E9DD61468;
        Thu,  1 Jul 2021 01:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104424;
        bh=A4GM+AdHH/VL3TLMEqI+tQ7OFTv2WyhwXCiTcnfvg3E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cGCdFp0vEPjSulc60KjauW3MmQPdfReiv2Df5uWr+7BJtcEaZ5bMu14armPU9wrJS
         1MFDKBd0XLs89iUb0Q6Z3lGcidYsjkwiVesbtKb3cfdh+QmT+FU5bLxpnqPv3yJmcx
         qPgGrMOpg/Hah3n40tDOBEAJ5aPJ7JGkMo9Fsp6I=
Date:   Wed, 30 Jun 2021 18:53:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 123/192] mm/z3fold: add kerneldoc fields for
 z3fold_pool
Message-ID: <20210701015344.aNl5evPur%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/z3fold: add kerneldoc fields for z3fold_pool

make W=1 generates the following warning for z3fold_pool

  mm/z3fold.c:171: warning: Function parameter or member 'zpool' not described in 'z3fold_pool'
  mm/z3fold.c:171: warning: Function parameter or member 'zpool_ops' not described in 'z3fold_pool'

Commit 9a001fc19ccc ("z3fold: the 3-fold allocator for compressed pages")
simply did not document the fields at the time.  Add rudimentary
documentation.

Link: https://lkml.kernel.org/r/20210520084809.8576-11-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/z3fold.c~mm-z3fold-add-kerneldoc-fields-for-z3fold_pool
+++ a/mm/z3fold.c
@@ -144,6 +144,8 @@ struct z3fold_header {
  * @c_handle:	cache for z3fold_buddy_slots allocation
  * @ops:	pointer to a structure of user defined operations specified at
  *		pool creation time.
+ * @zpool:	zpool driver
+ * @zpool_ops:	zpool operations structure with an evict callback
  * @compact_wq:	workqueue for page layout background optimization
  * @release_wq:	workqueue for safe page release
  * @work:	work_struct for safe page release
_
