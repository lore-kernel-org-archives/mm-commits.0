Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83481C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344760AbhLJWuN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43486 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344658AbhLJWuM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 693BEB828B0
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD115C00446;
        Fri, 10 Dec 2021 22:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176395;
        bh=oETgYmcj1gH/uhD0N3o2roLnBg9WlJ32wefbRp7a+/E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SiCerIWL4Z+AJnax3X7SG5AjgkzwTW3JvNv+B35pYVoRtzLYx3jb5kxXGxMYjBXWd
         bfXTYvA5cE/9565UPfry9qy1ZPWCWOnC5Az1nLAjLdI/jYHSCkCLo2/5RM7LOMMMii
         IdZFmOlGIRt2Vc/qg1HRn6ASUz0WCI7vd3q6C+MI=
Date:   Fri, 10 Dec 2021 14:46:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 09/21] mm/damon/core: remove unnecessary error
 messages
Message-ID: <20211210224634.mKra4MjZS%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: remove unnecessary error messages

DAMON core prints error messages when damon_target object creation is
failed or wrong monitoring attributes are given.  Because appropriate
error code is returned for each case, the messages are not essential. 
Also, because the code path can be triggered with user-specified input,
this could result in kernel log mistakenly being messy.  To avoid the
case, this commit removes the messages.

Link: https://lkml.kernel.org/r/20211201150440.1088-4-sj@kernel.org
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Fixes: b9a6ac4e4ede ("mm/damon: adaptively adjust regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-unnecessary-error-messages
+++ a/mm/damon/core.c
@@ -282,7 +282,6 @@ int damon_set_targets(struct damon_ctx *
 	for (i = 0; i < nr_ids; i++) {
 		t = damon_new_target(ids[i]);
 		if (!t) {
-			pr_err("Failed to alloc damon_target\n");
 			/* The caller should do cleanup of the ids itself */
 			damon_for_each_target_safe(t, next, ctx)
 				damon_destroy_target(t);
@@ -312,16 +311,10 @@ int damon_set_attrs(struct damon_ctx *ct
 		    unsigned long aggr_int, unsigned long primitive_upd_int,
 		    unsigned long min_nr_reg, unsigned long max_nr_reg)
 {
-	if (min_nr_reg < 3) {
-		pr_err("min_nr_regions (%lu) must be at least 3\n",
-				min_nr_reg);
+	if (min_nr_reg < 3)
 		return -EINVAL;
-	}
-	if (min_nr_reg > max_nr_reg) {
-		pr_err("invalid nr_regions.  min (%lu) > max (%lu)\n",
-				min_nr_reg, max_nr_reg);
+	if (min_nr_reg > max_nr_reg)
 		return -EINVAL;
-	}
 
 	ctx->sample_interval = sample_int;
 	ctx->aggr_interval = aggr_int;
_
