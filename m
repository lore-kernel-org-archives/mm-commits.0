Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A37AECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241015AbiH0DKv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiH0DKt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:10:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B9C1FCCA
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:10:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB47361DC5
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF32C433C1;
        Sat, 27 Aug 2022 03:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661569846;
        bh=3Pq2cB9+3/hRasGPdajF2eJdkF9LnH07w5UIYbxRBUw=;
        h=Date:To:From:Subject:From;
        b=hu1dSuCM+Olc7lPbstKzM+sq5xQZ9kOyu8Iu5jVbKLsFkerWD/suHy50R1IWh17cZ
         d9oGlCY4iX+QoakiSYLWMmA7Q8Ad1jn4KZ+PeU0WN2AH3iMZv/CTmLsIFhR4WjZlOy
         WII1RcHODKawUN0IjpMdV35Xkmq5h14ICeSsJn+c=
Date:   Fri, 26 Aug 2022 20:10:45 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        akpm@linux-foundation.org, ye.xingchen@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-backing-dev-remove-the-unneeded-result-variable.patch added to mm-unstable branch
Message-Id: <20220827031046.4CF32C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: backing-dev: Remove the unneeded result variable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-backing-dev-remove-the-unneeded-result-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-backing-dev-remove-the-unneeded-result-variable.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: ye xingchen <ye.xingchen@zte.com.cn>
Subject: mm: backing-dev: Remove the unneeded result variable
Date: Fri, 26 Aug 2022 07:19:06 +0000

Return the value cgwb_bdi_init() directly instead of storing it in another
redundant variable.

Link: https://lkml.kernel.org/r/20220826071906.252419-1-ye.xingchen@zte.com.cn
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/backing-dev.c~mm-backing-dev-remove-the-unneeded-result-variable
+++ a/mm/backing-dev.c
@@ -776,8 +776,6 @@ static void cgwb_remove_from_bdi_list(st
 
 int bdi_init(struct backing_dev_info *bdi)
 {
-	int ret;
-
 	bdi->dev = NULL;
 
 	kref_init(&bdi->refcnt);
@@ -788,9 +786,7 @@ int bdi_init(struct backing_dev_info *bd
 	INIT_LIST_HEAD(&bdi->wb_list);
 	init_waitqueue_head(&bdi->wb_waitq);
 
-	ret = cgwb_bdi_init(bdi);
-
-	return ret;
+	return cgwb_bdi_init(bdi);
 }
 
 struct backing_dev_info *bdi_alloc(int node_id)
_

Patches currently in -mm which might be from ye.xingchen@zte.com.cn are

mm-backing-dev-remove-the-unneeded-result-variable.patch

