Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A2AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14739216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881397;
	bh=TvPikspgUbBRHNq/9cWIcq6l8Ipf9FqIfBuHkgX9cLo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gHfjsjYm4km4Os43Q90itjB1ZMZqoIEcV3vwdCSJ/YFhXlJCipmjiLkUr2s5NMz6k
	 X0Ow9YWLuOsxm1QTUwkm4Y7t6MEVyxldpEnu0+7wuNV80ZJT71BrgUcrSV9rlQZRbg
	 4alnFr2dt56WJNthQEatom5XgpYOM5GKaXmNQafs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392729AbgJPUt4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392725AbgJPUt4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:49:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC4552145D;
        Fri, 16 Oct 2020 20:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881396;
        bh=TvPikspgUbBRHNq/9cWIcq6l8Ipf9FqIfBuHkgX9cLo=;
        h=Date:From:To:Subject:From;
        b=PL+kn3Whq4BJjfUKVhkk6gwbbB57V+h9Daneh6BDx9APwzNWD04tn+0SVuelA3pLQ
         L5gNLI/BbJptuyRYEu3WQLsnTwHAFHHz7NLr75DIc/AL9cCafiD9Fkv57rtU2Kgf0X
         JouoTtc5qT0wmkswfLjtN8E+rHNGSHDVuAMDx8s8=
Date:   Fri, 16 Oct 2020 13:49:55 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-vmstat-use-helper-macro-abs.patch removed
 from -mm tree
Message-ID: <20201016204955.yHYMM2DM6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: use helper macro abs()
has been removed from the -mm tree.  Its filename was
     mm-vmstat-use-helper-macro-abs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmstat.c: use helper macro abs()

Use helper macro abs() to simplify the "x > t || x < -t" cmp.

Link: https://lkml.kernel.org/r/20200905084008.15748-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-use-helper-macro-abs
+++ a/mm/vmstat.c
@@ -325,7 +325,7 @@ void __mod_zone_page_state(struct zone *
 
 	t = __this_cpu_read(pcp->stat_threshold);
 
-	if (unlikely(x > t || x < -t)) {
+	if (unlikely(abs(x) > t)) {
 		zone_page_state_add(x, zone, item);
 		x = 0;
 	}
@@ -350,7 +350,7 @@ void __mod_node_page_state(struct pglist
 
 	t = __this_cpu_read(pcp->stat_threshold);
 
-	if (unlikely(x > t || x < -t)) {
+	if (unlikely(abs(x) > t)) {
 		node_page_state_add(x, pgdat, item);
 		x = 0;
 	}
@@ -511,7 +511,7 @@ static inline void mod_zone_state(struct
 		o = this_cpu_read(*p);
 		n = delta + o;
 
-		if (n > t || n < -t) {
+		if (abs(n) > t) {
 			int os = overstep_mode * (t >> 1) ;
 
 			/* Overflow must be added to zone counters */
@@ -573,7 +573,7 @@ static inline void mod_node_state(struct
 		o = this_cpu_read(*p);
 		n = delta + o;
 
-		if (n > t || n < -t) {
+		if (abs(n) > t) {
 			int os = overstep_mode * (t >> 1) ;
 
 			/* Overflow must be added to node counters */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

