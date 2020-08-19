Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D05C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FAAF20882
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597807667;
	bh=A/B4XHme9GLYt0fFJdSQ1alemIbtcnpXkqo3lmxZQTQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RdDrOB57LybMxXMRSGfOfqeqzQbRZRfyW+z+5IvTxINt3La64IgLnXSRNumFYUPT2
	 hEEUuEu+wHaYdYDZvvkTbipzMQhCB3GqI2TCxb4hZP2QiIQidTWmslNTcPtxHorAAG
	 6Fg1EXnStUjer/ClWJTFD1ZSX8aav0ozdkNZXk9I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHSD1r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgHSD1q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:27:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2B9E20639;
        Wed, 19 Aug 2020 03:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597807664;
        bh=A/B4XHme9GLYt0fFJdSQ1alemIbtcnpXkqo3lmxZQTQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Dqlo5BBn+ICGBO++I1yy0VwXuCPH75UurrsLDQLcOZKi7N4rbmP0D7fcidx1WUXaj
         Tw0Oami+dcIMRg3oyoESJpCo6Jyh4FX/N5wrv9Tsa/RLLMiO05J3nJiRDXY+bLfETl
         kI0EujVjbSq/ZbIZ4ihswkv6hvx3JGMsayA8CCvk=
Date:   Tue, 18 Aug 2020 20:27:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, hewenliang4@huawei.com, hushiyuan@huawei.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, wuyun.wu@huawei.com
Subject:  + mm-slub-branch-optimization-in-free-slowpath.patch
 added to -mm tree
Message-ID: <20200819032743.yFUtbKv5s%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: branch optimization in free slowpath
has been added to the -mm tree.  Its filename is
     mm-slub-branch-optimization-in-free-slowpath.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-branch-optimization-in-free-slowpath.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-branch-optimization-in-free-slowpath.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Abel Wu <wuyun.wu@huawei.com>
Subject: mm/slub.c: branch optimization in free slowpath

The two conditions are mutually exclusive and gcc compiler will optimise
this into if-else-like pattern.  Given that the majority of free_slowpath
is free_frozen, let's provide some hint to the compilers.

Tests (perf bench sched messaging -g 20 -l 400000, executed 10x
after reboot) are done and the summarized result:

	un-patched	patched
max.	192.316		189.851
min.	187.267		186.252
avg.	189.154		188.086
stdev.	1.37		0.99

Link: http://lkml.kernel.org/r/20200813101812.1617-1-wuyun.wu@huawei.com
Signed-off-by: Abel Wu <wuyun.wu@huawei.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hewenliang <hewenliang4@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/slub.c~mm-slub-branch-optimization-in-free-slowpath
+++ a/mm/slub.c
@@ -3024,20 +3024,21 @@ static void __slab_free(struct kmem_cach
 
 	if (likely(!n)) {
 
-		/*
-		 * If we just froze the page then put it onto the
-		 * per cpu partial list.
-		 */
-		if (new.frozen && !was_frozen) {
+		if (likely(was_frozen)) {
+			/*
+			 * The list lock was not taken therefore no list
+			 * activity can be necessary.
+			 */
+			stat(s, FREE_FROZEN);
+		} else if (new.frozen) {
+			/*
+			 * If we just froze the page then put it onto the
+			 * per cpu partial list.
+			 */
 			put_cpu_partial(s, page, 1);
 			stat(s, CPU_PARTIAL_FREE);
 		}
-		/*
-		 * The list lock was not taken therefore no list
-		 * activity can be necessary.
-		 */
-		if (was_frozen)
-			stat(s, FREE_FROZEN);
+
 		return;
 	}
 
_

Patches currently in -mm which might be from wuyun.wu@huawei.com are

mm-slub-branch-optimization-in-free-slowpath.patch

