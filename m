Return-Path: <SRS0=50af=CO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F52C433E2
	for <mm-commits@archiver.kernel.org>; Sat,  5 Sep 2020 20:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86F0320796
	for <mm-commits@archiver.kernel.org>; Sat,  5 Sep 2020 20:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599338026;
	bh=pjte/MsdvDUoy9kxUwig9RZ7vgAFxe9QXxv1SX1Eif8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=W0pr07LNnmRi/WdpogKaDE8jfBelRriHtnUYa6Hp/phA+YjOU6dWqpz7F3sF1yAii
	 pL9EKXRNuiEdMdXSR9JABt4dmo0lwxBIsTyVz0HlAwW1ACEfPRVbfizHa6FqnP0i8A
	 1HVMk/yll3a/GVbgQsy1EOw/MC8uRsSsNJ10+C74=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgIEUdq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Sep 2020 16:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIEUdq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 5 Sep 2020 16:33:46 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A8D820738;
        Sat,  5 Sep 2020 20:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599338025;
        bh=pjte/MsdvDUoy9kxUwig9RZ7vgAFxe9QXxv1SX1Eif8=;
        h=Date:From:To:Subject:From;
        b=SgEaEoHixP19iafJsD5OMPsdc8ke5XaUPPW0GWS5Qz2MHaB9PMOOqL8zFm2jLbWlY
         cpIfjkNktV25bLiebxFv9cwWxCu7JOw6Uw1kaKuI/oZUhow2dFTGAWAXEFzgh2zYfR
         cXvgiG9Y81tGb6YRLKYdsq9dpT1R5VtBtt+3bl74=
Date:   Sat, 05 Sep 2020 13:33:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        linmiaohe@huawei.com
Subject:  + mm-vmstat-use-helper-macro-abs.patch added to -mm tree
Message-ID: <20200905203344.BWfS1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: use helper macro abs()
has been added to the -mm tree.  Its filename is
     mm-vmstat-use-helper-macro-abs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-use-helper-macro-abs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-use-helper-macro-abs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -329,7 +329,7 @@ void __mod_zone_page_state(struct zone *
 
 	t = __this_cpu_read(pcp->stat_threshold);
 
-	if (unlikely(x > t || x < -t)) {
+	if (unlikely(abs(x) > t)) {
 		zone_page_state_add(x, zone, item);
 		x = 0;
 	}
@@ -354,7 +354,7 @@ void __mod_node_page_state(struct pglist
 
 	t = __this_cpu_read(pcp->stat_threshold);
 
-	if (unlikely(x > t || x < -t)) {
+	if (unlikely(abs(x) > t)) {
 		node_page_state_add(x, pgdat, item);
 		x = 0;
 	}
@@ -515,7 +515,7 @@ static inline void mod_zone_state(struct
 		o = this_cpu_read(*p);
 		n = delta + o;
 
-		if (n > t || n < -t) {
+		if (abs(n) > t) {
 			int os = overstep_mode * (t >> 1) ;
 
 			/* Overflow must be added to zone counters */
@@ -577,7 +577,7 @@ static inline void mod_node_state(struct
 		o = this_cpu_read(*p);
 		n = delta + o;
 
-		if (n > t || n < -t) {
+		if (abs(n) > t) {
 			int os = overstep_mode * (t >> 1) ;
 
 			/* Overflow must be added to node counters */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

