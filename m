Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B3FC55178
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BFB62224E
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604279278;
	bh=XVnr5KpwBnyWJFxMQ7brN6nwBPjxCN9Aa6KqmEEuKHM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=nhcZNFpeGVDl6EQuA7oAyN7NuLR/2FHBv9+Lc0o7+JwbpRU9I1zk02hB9+GjBsEPi
	 9bbQYAzDETGzChZlZYAZZHE/x0lA/v6wqJp+NdP72X3pwU2ezkSOZ+67FMfZYCi2Pe
	 lBKVfFCq1/bGIUrNv3ac/VmrCCo4fWIFDvXxIg5s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgKBBH5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:07:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBH5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:07:57 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2791722272;
        Mon,  2 Nov 2020 01:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279277;
        bh=XVnr5KpwBnyWJFxMQ7brN6nwBPjxCN9Aa6KqmEEuKHM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TIVNvCj/rqk5/wgDAobSbzjzuezz9F3oahI0x+pMZczG3p4WyVJKmS01cNXto8TWL
         lIPm20WfHQFZjrhxapLmokSyNjvgc9/RoMIkVZr1X3nOqusWiNgzSKhJn2+woQXZdw
         QHYXQEsta358QLPc8sDnTQ7oGaHXQuY9FH+bM4FU=
Date:   Sun, 01 Nov 2020 17:07:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        chaithco@redhat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 11/15] mm, oom: keep oom_adj under or at upper
 limit when printing
Message-ID: <20201102010756.AS_nVXHtR%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Charles Haithcock <chaithco@redhat.com>
Subject: mm, oom: keep oom_adj under or at upper limit when printing

For oom_score_adj values in the range [942,999], the current
calculations will print 16 for oom_adj. This patch simply limits the
output so output is inline with docs.

Link: https://lkml.kernel.org/r/20201020165130.33927-1-chaithco@redhat.com
Signed-off-by: Charles Haithcock <chaithco@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/base.c~mm-oom-keep-oom_adj-under-or-at-upper-limit-when-printing
+++ a/fs/proc/base.c
@@ -1049,6 +1049,8 @@ static ssize_t oom_adj_read(struct file
 		oom_adj = (task->signal->oom_score_adj * -OOM_DISABLE) /
 			  OOM_SCORE_ADJ_MAX;
 	put_task_struct(task);
+	if (oom_adj > OOM_ADJUST_MAX)
+		oom_adj = OOM_ADJUST_MAX;
 	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_adj);
 	return simple_read_from_buffer(buf, count, ppos, buffer, len);
 }
_
