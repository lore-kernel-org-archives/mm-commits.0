Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7DA5C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 04:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C0292250E
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 04:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732390AbhALEsM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jan 2021 23:48:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732895AbhALEsM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 Jan 2021 23:48:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE030221FE;
        Tue, 12 Jan 2021 04:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610426851;
        bh=n/OSY6WZmQ1scpO1eG2rQFfBy4FWr7JKkwu1nOj+7Kc=;
        h=Date:From:To:Subject:From;
        b=wbxcldkbpfYo6zE7gsaPFZ7t83rUrfOsL0q4PuTTK17ka4LbGvwjzdLLKZ54mz1L5
         lmGG/hOp0TQGSkAAeFxi3Iq9YvO4/A7YzTPvNaxxDVVIzddUIn5bbvRLtD0KyvhtGP
         vecLgU4R61JVAA9yPSmtuNaem+2RH9R5h7tOUvNk=
Date:   Mon, 11 Jan 2021 20:47:31 -0800
From:   akpm@linux-foundation.org
To:     benbjiang@tencent.com, cl@linux-foundation.org,
        mm-commits@vger.kernel.org, robinlai@tencent.com
Subject:  + mm-vmstatc-erase-latency-in-vmstat_shepherd.patch added
 to -mm tree
Message-ID: <20210112044731.P0lhvWZSA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: erase latency in vmstat_shepherd
has been added to the -mm tree.  Its filename is
     mm-vmstatc-erase-latency-in-vmstat_shepherd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstatc-erase-latency-in-vmstat_shepherd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstatc-erase-latency-in-vmstat_shepherd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Biao <benbjiang@tencent.com>
Subject: mm/vmstat.c: erase latency in vmstat_shepherd

Many 100us+ latencies have been deteceted in vmstat_shepherd() on CPX
platform which has 208 logic cpus.  And vmstat_shepherd is queued every
second, which could make the case worse.

Add schedule point in vmstat_shepherd() to erase the latency.

Link: https://lkml.kernel.org/r/20210111035526.1511-1-benbjiang@tencent.com
Signed-off-by: Jiang Biao <benbjiang@tencent.com>
Reported-by: Bin Lai <robinlai@tencent.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmstat.c~mm-vmstatc-erase-latency-in-vmstat_shepherd
+++ a/mm/vmstat.c
@@ -1973,6 +1973,8 @@ static void vmstat_shepherd(struct work_
 
 		if (!delayed_work_pending(dw) && need_update(cpu))
 			queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+
+		cond_resched();
 	}
 	put_online_cpus();
 
_

Patches currently in -mm which might be from benbjiang@tencent.com are

mm-vmstatc-erase-latency-in-vmstat_shepherd.patch

