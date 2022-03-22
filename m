Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F167C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbiCVVuz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236906AbiCVVuy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEB960CCC
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:49:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18FDC6175F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCCAC36AE5;
        Tue, 22 Mar 2022 21:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985765;
        bh=Ucyl7dsrthNgSkBKW6/KVlGj1sShxc2guQAd937y+l4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=KJ/OXuOaFoDC4kbsXeRocUQRavyYPTxFb9aLn9eNcU/97ufpLiJ2tUT3OObdVmLvO
         T8g9ZE635QWa6u/UWPhVkiJ1pQQWBl8dXZz51/Gf7hQ4H4Wz+LeqxLX27qiN0Oy6NH
         CAgUJ5kQ8qQrL0na73FLUdgs6KoUjRAd5ayQmJN0=
Date:   Tue, 22 Mar 2022 14:49:24 -0700
To:     xhao@linux.alibaba.com, skhan@linuxfoundation.org,
        rientjes@google.com, gregkh@linuxfoundation.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 215/227] mm/damon/core: add number of each enum type values
Message-Id: <20220322214925.6BCCAC36AE5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add number of each enum type values

This commit declares the number of legal values for each DAMON enum types
to make traversals of such DAMON enum types easy and safe.

Link: https://lkml.kernel.org/r/20220228081314.5770-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-add-number-of-each-enum-type-values
+++ a/include/linux/damon.h
@@ -87,6 +87,7 @@ struct damon_target {
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
  * @DAMOS_STAT:		Do nothing but count the stat.
+ * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
  */
 enum damos_action {
 	DAMOS_WILLNEED,
@@ -95,6 +96,7 @@ enum damos_action {
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
 	DAMOS_STAT,		/* Do nothing but only record the stat */
+	NR_DAMOS_ACTIONS,
 };
 
 /**
@@ -157,10 +159,12 @@ struct damos_quota {
  *
  * @DAMOS_WMARK_NONE:		Ignore the watermarks of the given scheme.
  * @DAMOS_WMARK_FREE_MEM_RATE:	Free memory rate of the system in [0,1000].
+ * @NR_DAMOS_WMARK_METRICS:	Total number of DAMOS watermark metrics
  */
 enum damos_wmark_metric {
 	DAMOS_WMARK_NONE,
 	DAMOS_WMARK_FREE_MEM_RATE,
+	NR_DAMOS_WMARK_METRICS,
 };
 
 /**
_
