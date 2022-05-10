Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C16BFC4167B
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbiEJEU6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236137AbiEJETu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:19:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1052AC0E0
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28490B81AF1
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA685C385C5;
        Tue, 10 May 2022 04:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156068;
        bh=xXqXCQmD4MoIJcHM28O5/2KquqDqlP/oiUbZVlUjdzE=;
        h=Date:To:From:Subject:From;
        b=0D7QO0Q/QOhPmZNgzI4CpZannbf5Bx68XnDs6Ot5KUWt/vlGSPEyIrljYxdwlmJcI
         fkWDldE8D82BOlUW1ysEUChnEMb2mJFvdmS3XJQODsxGbSpe+GmNH6pKL4wyQhS2mm
         KYN91fubrhrFfJ5Ke4AB0K4t++x7sxNCSumtvP3A=
Date:   Mon, 09 May 2022 21:14:28 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, liqiong@nfschina.com,
        yuzhe@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-unnecessary-type-castings.patch removed from -mm tree
Message-Id: <20220510041428.CA685C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: remove unnecessary type castings
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-unnecessary-type-castings.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Yu Zhe <yuzhe@nfschina.com>
Subject: mm/damon: remove unnecessary type castings

Remove unnecessary void* type castings.

Link: https://lkml.kernel.org/r/20220421153056.8474-1-yuzhe@nfschina.com
Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: liqiong <liqiong@nfschina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-remove-unnecessary-type-castings
+++ a/mm/damon/core.c
@@ -1042,7 +1042,7 @@ static int kdamond_wait_activation(struc
  */
 static int kdamond_fn(void *data)
 {
-	struct damon_ctx *ctx = (struct damon_ctx *)data;
+	struct damon_ctx *ctx = data;
 	struct damon_target *t;
 	struct damon_region *r, *next;
 	unsigned int max_nr_accesses = 0;
_

Patches currently in -mm which might be from yuzhe@nfschina.com are


