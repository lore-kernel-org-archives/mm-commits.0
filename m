Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDC2C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5783B64EE1
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhBZBSr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:18:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhBZBSo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:18:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FD6F64F24;
        Fri, 26 Feb 2021 01:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302280;
        bh=CW0Y0Y1Ak43kKBuaaxro7IBEj4r8oOE1CH4qs5kHqFs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=x35jhEn3oUgv1wDs1ven85cK6rpP56f1/ukx1UuQhJTNMZXfkEH9N3lTG1J37aidT
         HWiMelLQiELWjDWLh8PVfa30ksPDHl4dBnXtBG+1GnhdO7kp/gOBtLvoog28Cr3Phv
         APGiFmjWpPgK5XgaZBefPv4figTytfUmDdnRoqMg=
Date:   Thu, 25 Feb 2021 17:17:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 042/118] mm/rmap: fix obsolete comment in
 __page_check_anon_rmap()
Message-ID: <20210226011759.fJf9U1f9p%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/rmap: fix obsolete comment in __page_check_anon_rmap()

Commit 21333b2b66b8 ("ksm: no debug in page_dup_rmap()") has reverted
page_dup_rmap() to an inline atomic_inc of mapcount.  So page_dup_rmap()
does not call __page_check_anon_rmap() anymore.

Link: https://lkml.kernel.org/r/20210128110209.50857-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap
+++ a/mm/rmap.c
@@ -1086,8 +1086,7 @@ static void __page_check_anon_rmap(struc
 	 * be set up correctly at this point.
 	 *
 	 * We have exclusion against page_add_anon_rmap because the caller
-	 * always holds the page locked, except if called from page_dup_rmap,
-	 * in which case the page is already known to be setup.
+	 * always holds the page locked.
 	 *
 	 * We have exclusion against page_add_new_anon_rmap because those pages
 	 * are initially only visible via the pagetables, and the pte is locked
_
