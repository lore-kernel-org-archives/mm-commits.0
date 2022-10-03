Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEA7C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiJCVNV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DC95208E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 27DD5CE0E5D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824EBC433D6;
        Mon,  3 Oct 2022 21:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831248;
        bh=Y40ubLHViHZDCm32ZJV85xRs35RzvuAPsxzOruC1UeU=;
        h=Date:To:From:Subject:From;
        b=Vo5n9IKNnf/FgZT/iS4XFFEpr69KmWuo9w46+TbdWLXhKkRUpOGZbgPlNMTpFkC6T
         oJWpegOB0XLzfFXdr7P9REUI6lfiuJ02/XYp7UaHWW3JYdiSM61B1wE3NmwQGcHdjY
         qjoR0Gxk/KhbQqfynwZ2NrabWehl7XebnnnAAHP8=
Date:   Mon, 03 Oct 2022 14:07:27 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-modules-common-implement-a-stats-parameters-generator-macro.patch removed from -mm tree
Message-Id: <20221003210728.824EBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/modules-common: implement a stats parameters generator macro
has been removed from the -mm tree.  Its filename was
     mm-damon-modules-common-implement-a-stats-parameters-generator-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/modules-common: implement a stats parameters generator macro
Date: Tue, 13 Sep 2022 17:44:42 +0000

DAMON_RECLAIM and DAMON_LRU_SORT have module parameters for DAMOS
statistics that having same names.  This commit implements a macro for
generating such module parameters so that we can reuse later.

Link: https://lkml.kernel.org/r/20220913174449.50645-16-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/modules-common.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/damon/modules-common.h~mm-damon-modules-common-implement-a-stats-parameters-generator-macro
+++ a/mm/damon/modules-common.h
@@ -23,3 +23,15 @@
 	module_param_named(wmarks_high, wmarks.high, ulong, 0600);	\
 	module_param_named(wmarks_mid, wmarks.mid, ulong, 0600);	\
 	module_param_named(wmarks_low, wmarks.low, ulong, 0600);
+
+#define DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(stat, try_name,		\
+		succ_name, qt_exceed_name)				\
+	module_param_named(nr_##try_name, stat.nr_tried, ulong, 0400);	\
+	module_param_named(bytes_##try_name, stat.sz_tried, ulong,	\
+			0400);						\
+	module_param_named(nr_##succ_name, stat.nr_applied, ulong,	\
+			0400);						\
+	module_param_named(bytes_##succ_name, stat.sz_applied, ulong,	\
+			0400);						\
+	module_param_named(qt_exceed_name, stat.qt_exceeds, ulong,	\
+			0400);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

