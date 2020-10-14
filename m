Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3A3C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1027B214D8
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709443;
	bh=IqNt0hZmxcbEVsRN6v8DB0/LpYARjWj42UiNR6WYgOU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Nlyxe/A1EMd04g6JBDoEwLabM98D2jqIK/ZMUbligQWG5eWTBhZ0phG3FWlg5WKm/
	 Rv43BRQjEJ82LZfeUJLfNXwHmcYjEZQtiBGzGL1GMvXQ0wpdNyM/I0ykjPiNWg6MCl
	 5N4soNz6yGVMzCke8lgSAHLsHOZP4Mxz7SCa7P/Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbgJNVEC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVEC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:04:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1C10206B2;
        Wed, 14 Oct 2020 21:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709441;
        bh=IqNt0hZmxcbEVsRN6v8DB0/LpYARjWj42UiNR6WYgOU=;
        h=Date:From:To:Subject:From;
        b=OOQiSGo/tAvpIhauzzQ6ZVGdBBSSsX5c130OKDX3B/1TVDqqg1PZ2U5bV6xdNQbIy
         /q0Mu1Ci6p1ZhNcq3A1B/GhFHnhTr+LvN9a0LF08Xa+PoExXgJLVGMR+BypdWanPop
         eW5YU6aOsJcrFo/Y4fxwiJWBtIq66GiRByB7kEZ4=
Date:   Wed, 14 Oct 2020 14:04:01 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  [merged]
 mm-mempolicy-remove-or-narrow-the-lock-on-current.patch removed from -mm
 tree
Message-ID: <20201014210401.nhf85p2JD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: remove or narrow the lock on current
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-remove-or-narrow-the-lock-on-current.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mempolicy: remove or narrow the lock on current

It is not necessary to hold the lock of current when setting nodemask of
a new policy.

Link: https://lkml.kernel.org/r/20200921040416.86185-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-remove-or-narrow-the-lock-on-current
+++ a/mm/mempolicy.c
@@ -875,13 +875,12 @@ static long do_set_mempolicy(unsigned sh
 		goto out;
 	}
 
-	task_lock(current);
 	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
-		task_unlock(current);
 		mpol_put(new);
 		goto out;
 	}
+	task_lock(current);
 	old = current->mempolicy;
 	current->mempolicy = new;
 	if (new && new->mode == MPOL_INTERLEAVE)
@@ -1324,9 +1323,7 @@ static long do_mbind(unsigned long start
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
 			mmap_write_lock(mm);
-			task_lock(current);
 			err = mpol_set_nodemask(new, nmask, scratch);
-			task_unlock(current);
 			if (err)
 				mmap_write_unlock(mm);
 		} else
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

