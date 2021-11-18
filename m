Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B18C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D350A61260
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhKRVhz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 16:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhKRVhz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 16:37:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0B0A6120A;
        Thu, 18 Nov 2021 21:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637271294;
        bh=IX6EGXzSn4LIPDzwPSVucqLgyTEVdIVpa0125Ti5tjA=;
        h=Date:From:To:Subject:From;
        b=h3npAHvZCbO4/3bKwkxqqmfT3fkC+D4ZEI2/yA1F/AxG8/B4huj9x+prs4jLmE8dS
         NoE2Tir5rjsDkISYS8nslHKe1aUnxaXra9W9CuQ1EE8e7uXebKXWgT6+PFXIfdxFv1
         f1HPMtB/mJCsuhEJt4qhdbzlEgVuqHdlYEnrig14=
Date:   Thu, 18 Nov 2021 13:34:54 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com
Subject:  +
 mm-damon-schemes-add-the-validity-judgment-of-thresholds.patch added to -mm
 tree
Message-ID: <20211118213454.Y78PntGjc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/schemes: add the validity judgment of thresholds
has been added to the -mm tree.  Its filename is
     mm-damon-schemes-add-the-validity-judgment-of-thresholds.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-schemes-add-the-validity-judgment-of-thresholds.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-schemes-add-the-validity-judgment-of-thresholds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/dbgfs.c~mm-damon-schemes-add-the-validity-judgment-of-thresholds
+++ a/mm/damon/dbgfs.c
@@ -215,6 +215,13 @@ static struct damos **str_to_schemes(con
 			goto fail;
 		}
 
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

mm-damon-unified-access_check-function-naming-rules.patch
mm-damon-add-age-of-region-tracepoint-support.patch
mm-damon-core-using-function-abs-instead-of-diff_of.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch
mm-damon-schemes-add-the-validity-judgment-of-thresholds.patch

