Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4F5C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06EC364F0E
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbhBXUFS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235473AbhBXUDy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3135864E7A;
        Wed, 24 Feb 2021 20:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196979;
        bh=CVIEiTchpZw0XsVoJdhriHeLgGDcugYxey5h859uyyc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=K7n42VJVjAyXutN8ZX5cs4h64oOxmEJVvlE3siRF3FtLJo2C+YXVBvcZ1DWUBw8CO
         AIzURrB1ximB2O4Rwjg00PsXngAjghrfBZ1dlQCdnF5zlgweqZkeDOBqgZAcSsUEuE
         viAXbbOeberfKGT8BjTxKnIrNa90NlhnZN5ahepE=
Date:   Wed, 24 Feb 2021 12:02:58 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stephenzhangzsd@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 051/173] mm/swapfile.c: fix debugging information
 problem
Message-ID: <20210224200258.WYqSGoEu3%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stephen Zhang <stephenzhangzsd@gmail.com>
Subject: mm/swapfile.c: fix debugging information problem

Once the function name is changed, it may be easy to forget to modify the
corresponding code here.

Link: https://lkml.kernel.org/r/1611369120-2276-1-git-send-email-stephenzhangzsd@gmail.com
Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-fix-debugging-information-problem
+++ a/mm/swapfile.c
@@ -1157,13 +1157,13 @@ static struct swap_info_struct *__swap_i
 	return p;
 
 bad_offset:
-	pr_err("swap_info_get: %s%08lx\n", Bad_offset, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	goto out;
 bad_device:
-	pr_err("swap_info_get: %s%08lx\n", Unused_file, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Unused_file, entry.val);
 	goto out;
 bad_nofile:
-	pr_err("swap_info_get: %s%08lx\n", Bad_file, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
 out:
 	return NULL;
 }
@@ -1180,7 +1180,7 @@ static struct swap_info_struct *_swap_in
 	return p;
 
 bad_free:
-	pr_err("swap_info_get: %s%08lx\n", Unused_offset, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Unused_offset, entry.val);
 out:
 	return NULL;
 }
_
