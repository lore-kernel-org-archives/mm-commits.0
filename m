Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95ECBC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D9276146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbhGAB4M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB4M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9485261469;
        Thu,  1 Jul 2021 01:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104421;
        bh=cj7TYLKQL7pFq+fI+egyyyGA5+4BIr7/uLEGZrlzhNw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gCikUNVTldA/pmKcUVSdMGIiO/gowAGJQTDCBkKqR73DEBrg8xKxRQEqB/8qndTQJ
         9/0JAr1q2N21IOaCO1qcXI04mgLpW7WH+ZsUfhxp8aNcAajixWElpQ+6ewMsmZpRPI
         2tyCKE/BomItaybyK9mxaodOxLj+KxxKiw5TuAJc=
Date:   Wed, 30 Jun 2021 18:53:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 122/192] mm/zbud: add kerneldoc fields for
 zbud_pool
Message-ID: <20210701015341.LKJP3M0fn%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
