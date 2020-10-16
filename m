Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7EAC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE9A520897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816267;
	bh=vHYOGHu0gT/r5g9stsKEey/EYU06gb0oYyYcbHmQLys=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tGrhomuEplgWfdQjUvMJNRaEpjrKkhF7wVMur6hp2PppP6EHo/iX40yOFnQBydf1s
	 RBXiBWHIHTLx036nXA8qroNoyq86XbgtFRRtokQCdbxShXKeqMO4hEnOxEkZ0UkwUA
	 +n4gUsouKM6Wf+vYHx6SjWQMNVUTWN5dYRMuVNyg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389834AbgJPCo0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389682AbgJPCo0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:44:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E4A82145D;
        Fri, 16 Oct 2020 02:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816265;
        bh=vHYOGHu0gT/r5g9stsKEey/EYU06gb0oYyYcbHmQLys=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uHns43jYZ6cgoBvnk50gB0/08Tzlfx4eeJfZnqbUvdcuYYDUK4ChgCqb8FvXESC25
         1PJLJnMRRY4oGVj/l+P5SyrLMhBD/XwjCwVaBy4QTQaVu4NW1ioynVs3JMAIZpR3pC
         hMoJKCJ+yJP0BlIt/r4f797WiTPXaKfLA+0uY1oM=
Date:   Thu, 15 Oct 2020 19:44:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 056/156] mm/vmstat.c: use helper macro abs()
Message-ID: <20201016024424.biNnIIAcg%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
