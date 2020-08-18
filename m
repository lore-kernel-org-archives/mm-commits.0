Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E37C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39A6220772
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597794561;
	bh=9mkg22055canRKys0H8ekcMB6nJhfpBnsqm+LjM2Auc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zASlDcEje1tqD+nuc4Do54xL+kJHU0qbKzIrhU+3asV37IaVWHw+mE+qp2tFwUK7Y
	 Hz0lpKzXYPgpkrY5p7S+StfQNoLYMt5lfV3/Q5ML80mlodcn8/WGxtarhdzE5ZJ3UY
	 VdTwV6hh9ull673hNGkAfLFwz0mTSyWgzgbQCXCg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgHRXtU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgHRXtU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 19:49:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B549E2065D;
        Tue, 18 Aug 2020 23:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597794559;
        bh=9mkg22055canRKys0H8ekcMB6nJhfpBnsqm+LjM2Auc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Z5X8pHF0Mkygz0YzSwOxy9DgplWSNCCqDZCqyjfnf5kfTjpgc5xAkQdeJgJjSPPlK
         drdStp4XDy8KZgSIORHfn72Qvp/NBSBgMG3RHpQaLH3S+IoGxRW7VPb3BwWqCKny9h
         aZaqTEKGKvZBiAahdQEnDCllQp+9uBut0LsBjulU=
Date:   Tue, 18 Aug 2020 16:49:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        yuehaibing@huawei.com
Subject:  +
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix.patch?= added to -mm tree
Message-ID: <20200818234919.9CYCgF_OH%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: Remove duplicate include
has been added to the -mm tree.  Its filename is
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/madvise: Remove duplicate include

Remove duplicate header which is included twice.

Link: http://lkml.kernel.org/r/20200818114448.45492-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix
+++ a/mm/madvise.c
@@ -17,7 +17,6 @@
 #include <linux/falloc.h>
 #include <linux/fadvise.h>
 #include <linux/sched.h>
-#include <linux/sched/mm.h>
 #include <linux/ksm.h>
 #include <linux/fs.h>
 #include <linux/file.h>
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch

