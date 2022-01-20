Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F994C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377889AbiATV21 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38412 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377892AbiATV20 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D0C8617CF
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A2FC340E0;
        Thu, 20 Jan 2022 21:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714105;
        bh=TpizDCgDoRNLiUAAP9GkB+1uYsN6rmnDpdri4WTxdU0=;
        h=Date:From:To:Subject:From;
        b=pA1CnTNelJvYIr1CdDJ/xImiUpZL7DMfXjm8Hisx5SvzgHudqB/3QN0AdUJDheycW
         QuCtYk3pVdsscCghvGdod3GDczFP0kIuJ6T6jhnwXQQtK4otfiHkLqP7yRo3V0HBgE
         fle6pN+iw7cGvV2UJU78ywzsC0zZWdrcL4+ZXk4A=
Date:   Thu, 20 Jan 2022 13:28:25 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com
Subject:  [merged]
 mm-damon-schemes-add-the-validity-judgment-of-thresholds.patch removed from
 -mm tree
Message-ID: <20220120212825.vhK-hVGYD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/schemes: add the validity judgment of thresholds
has been removed from the -mm tree.  Its filename was
     mm-damon-schemes-add-the-validity-judgment-of-thresholds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from xhao@linux.alibaba.com are


