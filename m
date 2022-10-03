Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D33C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJCVOL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36B252087
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 929F9B815F2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A13C433D6;
        Mon,  3 Oct 2022 21:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831245;
        bh=HqoYmGA9j+xx/aXVYxHUIxDR2+7TeY7YYO+FuEfEEPs=;
        h=Date:To:From:Subject:From;
        b=YxbMAPb9E6Iiej40RNeSCiU9fJY+SyHi8qjLNRKWTtmDgK4wZP/tGQO2wHdfk9DjN
         aL2XsRSk2wErvmiXs135Bqj3ZGAWPYLJu1nVruz9l2wHtzy8oiFvCN53FHYHV/eqZl
         EmcxRm55+3XapxwSyC/u08PCOe9frG9xR1UGKmlk=
Date:   Mon, 03 Oct 2022 14:07:24 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-modules-common-implement-a-watermarks-module-parameters-generator-macro.patch removed from -mm tree
Message-Id: <20221003210725.39A13C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/modules-common: implement a watermarks module parameters generator macro
has been removed from the -mm tree.  Its filename was
     mm-damon-modules-common-implement-a-watermarks-module-parameters-generator-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/modules-common: implement a watermarks module parameters generator macro
Date: Tue, 13 Sep 2022 17:44:39 +0000

DAMON_RECLAIM and DAMON_LRU_SORT have module parameters for watermarks
that having same names.  This commit implements a macro for generating
such module parameters so that we can reuse later.

Link: https://lkml.kernel.org/r/20220913174449.50645-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/modules-common.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/modules-common.h~mm-damon-modules-common-implement-a-watermarks-module-parameters-generator-macro
+++ a/mm/damon/modules-common.h
@@ -16,3 +16,10 @@
 			0600);						\
 	module_param_named(max_nr_regions, attrs.max_nr_regions, ulong,	\
 			0600);
+
+#define DEFINE_DAMON_MODULES_WMARKS_PARAMS(wmarks)			\
+	module_param_named(wmarks_interval, wmarks->interval, ulong,	\
+			0600);						\
+	module_param_named(wmarks_high, wmarks.high, ulong, 0600);	\
+	module_param_named(wmarks_mid, wmarks.mid, ulong, 0600);	\
+	module_param_named(wmarks_low, wmarks.lowulong, 0600);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

