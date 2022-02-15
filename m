Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B93C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 20:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244231AbiBOU57 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 15:57:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbiBOU57 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 15:57:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD98E031
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 12:57:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30E85B81CEF
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 20:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDED1C340EB;
        Tue, 15 Feb 2022 20:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644958665;
        bh=bzPD3dGe4CBCeWyuRhkBdZg6b4ln6DDUvfOYTf3HzCk=;
        h=Date:To:From:Subject:From;
        b=fQ2rOSX3vTVbkt5HiYbx7jmj3TIbaYafANeClJaQSlcFCWpn48taCu6KcNpxzjtcP
         lQIh5naqtHWhjqoyJdqWGf542IROJiKhV/3Qg37W8c6v3UJkols78579vVPj23M0tM
         06chJ3SpcOyvooBmSdTTCRaLUxBN4kTSYBvx0weE=
Date:   Tue, 15 Feb 2022 12:57:45 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch added to -mm tree
Message-Id: <20220215205745.CDED1C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: use damon_select_ops() instead of damon_{v,p}a_set_operations()
has been added to the -mm tree.  Its filename is
     mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: use damon_select_ops() instead of damon_{v,p}a_set_operations()

This commit makes DAMON_RECLAIM to select the registered monitoring
operations for the physical address space instead of setting it on its
own.  This allows DAMON_RECLAIM be independent of DAMON_PADDR, but leave
the dependency as is, because it's the only one monitoring operations it
use, and therefore it makes no sense to build DAMON_RECLAIM without
DAMON_PADDR.

Link: https://lkml.kernel.org/r/20220215184603.1479-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations
+++ a/mm/damon/reclaim.c
@@ -384,7 +384,9 @@ static int __init damon_reclaim_init(voi
 	if (!ctx)
 		return -ENOMEM;
 
-	damon_pa_set_operations(ctx);
+	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
+		return -EINVAL;
+
 	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
 
 	target = damon_new_target();
_

Patches currently in -mm which might be from sj@kernel.org are

mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2.patch
mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch
mm-damon-rename-damon_primitives-to-damon_operations.patch
mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
mm-damon-dbgfs-test-fix-is_target_id-change.patch
mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch

