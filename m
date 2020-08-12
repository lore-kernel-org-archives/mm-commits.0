Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB13C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45F1820829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195924;
	bh=WaEIkNcfMYREm13ULQ8dmpesjXp77yj1RCb28Y9Ya5M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dK12HxRGpv1eXI8OwTgp2+D271QyUXeEA83864QTgUh+ZynnoKi5cHxMHlgElzAPb
	 PcmVNdmeyp2yyorffMPTUj/DAWsLKJ4W45DMqGyIkLilkxbaDc4aZJSVsCzvpX6qpX
	 kwWq/w/C54qVwbpDKi7mpOXOlReoYOn3Pp8bdQuo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLBcD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgHLBcB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA7A92076C;
        Wed, 12 Aug 2020 01:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195921;
        bh=WaEIkNcfMYREm13ULQ8dmpesjXp77yj1RCb28Y9Ya5M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=z883PzYJ0EL3PZiWG2ns0ckwAaZb5QtgbyyjtCk4xIrZEUt2jx5l5yNDDD54cGnQW
         nc0zm8wzmCYfkOb6Frr3ETp/eOmhy5JuM03OIt3lWwMLNhrZDtatN69FlsYMxenfFh
         SehgBlMHr0/JmzkXZ5kWoWUhZ4L30AiEJV9gyLhE=
Date:   Tue, 11 Aug 2020 18:32:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        song.bao.hua@hisilicon.com, torvalds@linux-foundation.org
Subject:  [patch 033/165] mm: hugetlb: fix the name of hugetlb CMA
Message-ID: <20200812013200.Wtnbj1Trq%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm: hugetlb: fix the name of hugetlb CMA

Once we enable CMA_DEBUGFS, we will get the below errors: directory
'cma-hugetlb' with parent 'cma' already present.

We should have different names for different CMA areas.

Link: http://lkml.kernel.org/r/20200616223131.33828-3-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-the-name-of-hugetlb-cma
+++ a/mm/hugetlb.c
@@ -5707,12 +5707,14 @@ void __init hugetlb_cma_reserve(int orde
 	reserved = 0;
 	for_each_node_state(nid, N_ONLINE) {
 		int res;
+		char name[20];
 
 		size = min(per_node, hugetlb_cma_size - reserved);
 		size = round_up(size, PAGE_SIZE << order);
 
+		snprintf(name, 20, "hugetlb%d", nid);
 		res = cma_declare_contiguous_nid(0, size, 0, PAGE_SIZE << order,
-						 0, false, "hugetlb",
+						 0, false, name,
 						 &hugetlb_cma[nid], nid);
 		if (res) {
 			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
_
