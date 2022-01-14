Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69456C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiANWDX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57372 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiANWDW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F872B8262F
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6BBC36AE9;
        Fri, 14 Jan 2022 22:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197800;
        bh=8h2BgT3ZMcQgq/WkmRNRPLVea1gYYnRdpxuR56cd7Jk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=F7mayFiRGSuCe8l7j6onNbOEdP7IyKdm3vHLNebdvSTu/eu1DpnwtlPUZqV+UXN0q
         y8uaP/RE2icpd/bFeU/b9Qbee2BEiDk2wLhKd4IQyXmYb3dzycnV3QitTSKtT3Tyof
         LuvNXUKKKl+y5wi/kA7pZ8EtthBQY82eWnBZ8qtE=
Date:   Fri, 14 Jan 2022 14:03:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        wangborong@cdjrlc.com
Subject:  [patch 009/146] ia64: fix typo in a comment
Message-ID: <20220114220319.N8AxJActa%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jason Wang <wangborong@cdjrlc.com>
Subject: ia64: fix typo in a comment

The double `the' in a comment is repeated, thus it should be removed.

Link: https://lkml.kernel.org/r/20211113030316.22650-1-wangborong@cdjrlc.com
Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/uncached.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/uncached.c~ia64-fix-typo-in-a-comment
+++ a/arch/ia64/kernel/uncached.c
@@ -171,7 +171,7 @@ failed:
  * @n_pages: number of contiguous pages to allocate
  *
  * Allocate the specified number of contiguous uncached pages on the
- * the requested node. If not enough contiguous uncached pages are available
+ * requested node. If not enough contiguous uncached pages are available
  * on the requested node, roundrobin starting with the next higher node.
  */
 unsigned long uncached_alloc_page(int starting_nid, int n_pages)
_
