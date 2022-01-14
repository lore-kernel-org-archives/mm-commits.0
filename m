Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804D1C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiANWJz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiANWJy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36276C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:09:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8811FCE2384
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A032AC36AEC;
        Fri, 14 Jan 2022 22:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198190;
        bh=aIhc77Uq5yJjcD900SeC3Syb5vcahaAxAaDKlZ9jVxU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WfpBeHStwYgSF78FqoSJ4pOmrbdYf+5a5lGWgfr4Re4Ao1NS3I5ZtPGP7hjf281Cu
         8ZvLEJIELJXhMPbTai/27F9dh3DTcsjRVr64RXMQjDu59PhzpOf6lXRQxt7JHaMxie
         d9Av2A1DxYtEgpndz5iU/BF6w626Vb5j4hVYwUvA=
Date:   Fri, 14 Jan 2022 14:09:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org, xhao@linux.alibaba.com
Subject:  [patch 126/146] mm/damon/schemes: add the validity
 judgment of thresholds
Message-ID: <20220114220950.xLR4KeO6m%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/schemes: add the validity judgment of thresholds

In dbgfs "schemes" interface, i do some test like this:
    # cd /sys/kernel/debug/damon
    # echo "2 1 2 1 10 1 3 10 1 1 1 1 1 1 1 1 2 3" > schemes
    # cat schemes
    # 2 1 2 1 10 1 3 10 1 1 1 1 1 1 1 1 2 3 0 0

There have some unreasonable places, i set the valules of these variables
"<min_sz, max_sz> <min_nr_a, max_nr_a>, <min_age, max_age>, <wmarks.high,
wmarks.mid, wmarks.low>" as "<2, 1>, <2, 1>, <10, 1>, <1, 2, 3>.

So there add a validity judgment for these thresholds value.

Link: https://lkml.kernel.org/r/d78360e52158d786fcbf20bc62c96785742e76d3.1637239568.git.xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/dbgfs.c~mm-damon-schemes-add-the-validity-judgment-of-thresholds
+++ a/mm/damon/dbgfs.c
@@ -213,6 +213,13 @@ static struct damos **str_to_schemes(con
 		if (!damos_action_valid(action))
 			goto fail;
 
+		if (min_sz > max_sz || min_nr_a > max_nr_a || min_age > max_age)
+			goto fail;
+
+		if (wmarks.high < wmarks.mid || wmarks.high < wmarks.low ||
+		    wmarks.mid <  wmarks.low)
+			goto fail;
+
 		pos += parsed;
 		scheme = damon_new_scheme(min_sz, max_sz, min_nr_a, max_nr_a,
 				min_age, max_age, action, &quota, &wmarks);
_
