Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 289C7C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB7F420897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817808;
	bh=Mxd1Ax7SjAVTOHSwLcrllBgVXMiyjzZTjRuukJa9wo0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=oXzd+SBw4J4LWu6x70tEeyPnpEWUBU9iK5b0yx3FNAj03TZKD7oXuEQQrRQ36CN18
	 3khxpMUFqfwpFdGfrMqfU9xdMr7aLfE1SxSOm2e7wMWAPzAIFXgmLkPxsQCTEqoD/f
	 rIOydRhK78VHQP7VcvMyX/hmo/cY0rZD2zTFP1Dg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgJPDKI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgJPDKI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DF662087D;
        Fri, 16 Oct 2020 03:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817806;
        bh=Mxd1Ax7SjAVTOHSwLcrllBgVXMiyjzZTjRuukJa9wo0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VbENCmIci11+1rFgYsTheTYI2jAQ196vL+zdDEQBoh/39Br83CMWC0VyWtsLbsTIW
         WD5aKnhpJD4eGhY4SDxF6uDaeo92gIgzPuUKgseBwIi98CKhJt3O5ahG5+KWsTCMy1
         tor9MXrMgOMl++5/barlpwYp1Z83RQ5xvF5g5UGA=
Date:   Thu, 15 Oct 2020 20:10:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        tanxiaofei@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 091/156] mm/workingset.c: fix some doc warnings
Message-ID: <20201016031005.JL723Sm7n%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>
Subject: mm/workingset.c: fix some doc warnings

Fix following warnings caused by mismatch bewteen function parameters and
comments.

mm/workingset.c:228: warning: Function parameter or member 'lruvec' not described in 'workingset_age_nonresident'
mm/workingset.c:228: warning: Excess function parameter 'memcg' description in 'workingset_age_nonresident'

Link: https://lkml.kernel.org/r/1600485913-11192-1-git-send-email-tanxiaofei@huawei.com
Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/workingset.c~mm-fix-some-doc-warnings-in-workingsetc
+++ a/mm/workingset.c
@@ -216,7 +216,7 @@ static void unpack_shadow(void *shadow,
 
 /**
  * workingset_age_nonresident - age non-resident entries as LRU ages
- * @memcg: the lruvec that was aged
+ * @lruvec: the lruvec that was aged
  * @nr_pages: the number of pages to count
  *
  * As in-memory pages are aged, non-resident pages need to be aged as
_
