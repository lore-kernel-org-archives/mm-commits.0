Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D251C11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7864A61241
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbhGABym (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGABym (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B312C61474;
        Thu,  1 Jul 2021 01:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104331;
        bh=2fBKr6yCuCxyiEB0OEX48/16v+DiafEG5O7H/lh1Oc0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=btgyzVSsqDPNioKFPDFd98ItYfZLBGRdDRdtXQSjZfTLOrRKP+zPzD/qJ1RvbyMCU
         telp4WfkudzXCkErImeJVCrnO5XdIyZlz15xD/63uC44JVZ0FK2Uig1iUm4eqgIYug
         yuirgMOYsl9fe3x0Wy02DrPkSitldIv17MFOF66I=
Date:   Wed, 30 Jun 2021 18:52:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 094/192] mm/thp: fix strncpy warning
Message-ID: <20210701015211.j_262-htJ%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/thp: fix strncpy warning

Using MAX_INPUT_BUF_SZ as the maximum length of the string makes fortify
complain as it thinks the string might be longer than the buffer, and if
it is, we will end up with a "string" that is missing a NUL terminator. 
It's trivial to show that 'tok' points to a NUL-terminated string which is
less than MAX_INPUT_BUF_SZ in length, so we may as well just use strcpy()
and avoid the warning.

Link: https://lkml.kernel.org/r/20210615200242.1716568-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-fix-strncpy-warning
+++ a/mm/huge_memory.c
@@ -3101,7 +3101,7 @@ static ssize_t split_huge_pages_write(st
 
 		tok = strsep(&buf, ",");
 		if (tok) {
-			strncpy(file_path, tok, MAX_INPUT_BUF_SZ);
+			strcpy(file_path, tok);
 		} else {
 			ret = -EINVAL;
 			goto out;
_
