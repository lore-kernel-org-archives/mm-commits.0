Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7905C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355797AbiCYBgW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350754AbiCYBfq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28A42C10C
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CD36B81DE2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA21C340EC;
        Fri, 25 Mar 2022 01:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172006;
        bh=VzN/1qRD3YR7mJUql4+z8UR5RibBI1la+h7zlPjjDj0=;
        h=Date:To:From:Subject:From;
        b=f6PfTvHuDaDL3R6beBwadA/ll85yCtFAJ13T0nCwLm6E8ENwBpIsOXIj4GqfCwIhF
         E2P5AdYBCZ4Xtj0NFVyNeIOZN5zf4MOw73cMdCHs+zNHo+nZPsTCsDxD/57/SAmL9M
         5PrWjxnTB3B6oFgGxRqXQELy+JooskxMWGtz4QqU=
Date:   Thu, 24 Mar 2022 18:33:25 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        skhan@linuxfoundation.org, rientjes@google.com,
        gregkh@linuxfoundation.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-core-add-number-of-each-enum-type-values.patch removed from -mm tree
Message-Id: <20220325013326.1DA21C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: add number of each enum type values
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-number-of-each-enum-type-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are


