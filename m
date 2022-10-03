Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E81E3C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJCVNF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785551A38B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23988B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CBFC433B5;
        Mon,  3 Oct 2022 21:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831241;
        bh=4p36pnycMIBfw/vchTQboOmr5Ck9sAYCVeiMPSSZzJY=;
        h=Date:To:From:Subject:From;
        b=ivAvyWyEPBdO6V2RUgr4oC1eEw3/DJBpNUBCFv8Gx8stRU7RE5Qfht2jlqN6qhoaJ
         W3lhzincTshBC0ywPGKayAVKPMd6EfFnVGYHqjln0ImMTc+1SIE3IdjOlJZvvnucVk
         6rUI60H524G/ER9JX+L+PFX2/kXZmWZNkXzWjMOI=
Date:   Mon, 03 Oct 2022 14:07:21 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-implement-a-monitoring-attributes-module-parameters-generator-macro.patch removed from -mm tree
Message-Id: <20221003210721.C9CBFC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: implement a monitoring attributes module parameters generator macro
has been removed from the -mm tree.  Its filename was
     mm-damon-implement-a-monitoring-attributes-module-parameters-generator-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: implement a monitoring attributes module parameters generator macro
Date: Tue, 13 Sep 2022 17:44:36 +0000

DAMON_RECLAIM and DAMON_LRU_SORT have module parameters for monitoring
attributes that having same names.  This commot implements a macro for
generating such module parameters so that we can reuse later.

Link: https://lkml.kernel.org/r/20220913174449.50645-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/modules-common.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- /dev/null
+++ a/mm/damon/modules-common.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common Primitives for DAMON Modules
+ *
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#include <linux/moduleparam.h>
+
+#define DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(attrs)			\
+	module_param_named(sample_interval, attrs.sample_interval,	\
+			ulong, 0600);					\
+	module_param_named(aggr_interval, attrs.aggr_interval, ulong,	\
+			0600);						\
+	module_param_named(min_nr_regions, attrs.min_nr_regions, ulong,	\
+			0600);						\
+	module_param_named(max_nr_regions, attrs.max_nr_regions, ulong,	\
+			0600);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

