Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A246ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiILDdq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiILDcE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B401CB21
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 399B36116D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CBFC433D7;
        Mon, 12 Sep 2022 03:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953397;
        bh=ivE7OnRER2a04cWG1YjGRn5z83jS3WaEvgCasXesWi0=;
        h=Date:To:From:Subject:From;
        b=YReAiiAUNok4+pMRdvvob+mSZaa9DvAa9XLjDHEttghxauzj+BWwd4cz8yrhnCHhC
         xCjtO9/TQ6DlhSVzXvPbwdFRaZHEZ7/qbCBMEhFViGBlqgi8eTEA9iUmTO6E6z6LLH
         z5V3qXPzyP7iEy7A/lK+ORrFWZ8NA2FV2+d1KGGo=
Date:   Sun, 11 Sep 2022 20:29:56 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        akpm@linux-foundation.org, ye.xingchen@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-backing-dev-remove-the-unneeded-result-variable.patch removed from -mm tree
Message-Id: <20220912032957.92CBFC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: backing-dev: Remove the unneeded result variable
has been removed from the -mm tree.  Its filename was
     mm-backing-dev-remove-the-unneeded-result-variable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


