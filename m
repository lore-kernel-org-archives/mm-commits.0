Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04B2C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AF98214D8
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709432;
	bh=YI5VMyC4q5vMBvPQXuvEGDN7lO3cmu/00HH0ZWAyYsg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ODUtGavrjot9zjMHwRtL/Xu8qhLtPSoRlrwu/s/4IcUkjvLsB1wldvCFXWMn5bk0o
	 ZZxzJnq0zVsYPMu9Hev0E8UMAkUizm26ZnvpFsOCaB2PWyjBTdDDVRRJ/EZr8j416g
	 15p6SlpJhhNuLW5XM3oWZth3E79HqCiS4NmfAPDo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgJNVDw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVDv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:51 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2951206B2;
        Wed, 14 Oct 2020 21:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709430;
        bh=YI5VMyC4q5vMBvPQXuvEGDN7lO3cmu/00HH0ZWAyYsg=;
        h=Date:From:To:Subject:From;
        b=gT9RKy0qf/VnUmum4gkUDlWZ05wtJkwtGPZZ2k/jZ6We0aOKe6L5lTpvzrKQU3qel
         roBDi09kyLXFfoTt9Tg0LygAbYhpK2lK4CcAcsKbirIshCrbQ75WGDzm/v2lJmkcEk
         +5s5XQiq0w/b293ZQeQee9Xwd0PCae5RfciqkWC8=
Date:   Wed, 14 Oct 2020 14:03:49 -0700
From:   akpm@linux-foundation.org
To:     chenxiang66@hisilicon.com, david@redhat.com, ddstreet@ieee.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com
Subject:  [merged] mm-zbud-remove-redundant-initialization.patch
 removed from -mm tree
Message-ID: <20201014210349.yRknn5_rn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: remove redundant initialization
has been removed from the -mm tree.  Its filename was
     mm-zbud-remove-redundant-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiang Chen <chenxiang66@hisilicon.com>
Subject: mm/zbud: remove redundant initialization

zhdr is already initialized in the front of the function, so remove
redundant initialization here.

Link: https://lkml.kernel.org/r/1600419885-191907-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zbud.c~mm-zbud-remove-redundant-initialization
+++ a/mm/zbud.c
@@ -367,7 +367,6 @@ int zbud_alloc(struct zbud_pool *pool, s
 	spin_lock(&pool->lock);
 
 	/* First, try to find an unbuddied zbud page. */
-	zhdr = NULL;
 	for_each_unbuddied_list(i, chunks) {
 		if (!list_empty(&pool->unbuddied[i])) {
 			zhdr = list_first_entry(&pool->unbuddied[i],
_

Patches currently in -mm which might be from chenxiang66@hisilicon.com are


