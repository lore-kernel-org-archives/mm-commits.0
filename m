Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE2DC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiJCVNB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiJCVLi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04EC51A18
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BC65B811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C599C433D6;
        Mon,  3 Oct 2022 21:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831227;
        bh=EOPkbexnuw8ArK2djJ1eDjSFlIhXPrWb4FRlaDuyDTU=;
        h=Date:To:From:Subject:From;
        b=ZOwkBY8xZ+96pzkBmP9ux8Sr8IFXUm/ZEzNcuP03yqLmxrhmri0oBojTFZbki6+oy
         IwNdBjodPkzrghUK2oJOx+o4yapxPi30HSa3t6bsXDxEtmgDXMkEf5OgqhgGaH0M+O
         4rm5ZKskhA64uK2mTucy0xcjPpFXIKgpK14bV9L8=
Date:   Mon, 03 Oct 2022 14:07:06 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sj@kernel.org, kaixuxia@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch removed from -mm tree
Message-Id: <20221003210707.4C599C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: use the wrapper directly to check if the kdamond is running
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon/sysfs: use the wrapper directly to check if the kdamond is running
Date: Mon, 12 Sep 2022 23:11:53 +0800

We can use the 'damon_sysfs_kdamond_running()' wrapper directly to check
if the kdamond is running in 'damon_sysfs_turn_damon_on()'.

Link: https://lkml.kernel.org/r/1662995513-24489-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running
+++ a/mm/damon/sysfs.c
@@ -2465,8 +2465,7 @@ static int damon_sysfs_turn_damon_on(str
 	struct damon_ctx *ctx;
 	int err;
 
-	if (kdamond->damon_ctx &&
-			damon_sysfs_ctx_running(kdamond->damon_ctx))
+	if (damon_sysfs_kdamond_running(kdamond))
 		return -EBUSY;
 	if (damon_sysfs_cmd_request.kdamond == kdamond)
 		return -EBUSY;
_

Patches currently in -mm which might be from kaixuxia@tencent.com are


