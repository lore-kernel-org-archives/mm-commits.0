Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F827C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJCVP1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiJCVN5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D7554C82
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22AE2B81122
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3F7C433D7;
        Mon,  3 Oct 2022 21:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831359;
        bh=tDNKjqNOewhhqeIDkKUrKAcaiG/plQ+Z9EMLL15JoOg=;
        h=Date:To:From:Subject:From;
        b=QPF5IQnzwrW+hJbiPzv+RrqA4z3T9RDv8KhcB4YFJTz/SeJZpmhHbUWaLRN2UuEdq
         byCotCUlbUh4axkQuGsI2J3O0vFYY2S736mkyi7vuBeDWUw1ajJysCTnlSa0sDXOJA
         dOPvvIsIVRfRI7vE9H1LNDHI8Dz/69U9FdapTJWI=
Date:   Mon, 03 Oct 2022 14:09:19 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-use-struct-damon_target-instead-of-void-in-target_valid.patch removed from -mm tree
Message-Id: <20221003210919.CE3F7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: use 'struct damon_target *' instead of 'void *' in target_valid()
has been removed from the -mm tree.  Its filename was
     mm-damon-use-struct-damon_target-instead-of-void-in-target_valid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon: use 'struct damon_target *' instead of 'void *' in target_valid()
Date: Thu, 15 Sep 2022 19:33:41 +0800

We could use 'struct damon_target *' directly instead of 'void *' in
target_valid() operation to make code simple.

Link: https://lkml.kernel.org/r/1663241621-13293-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 mm/damon/vaddr.c      |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-use-struct-damon_target-instead-of-void-in-target_valid
+++ a/include/linux/damon.h
@@ -346,7 +346,7 @@ struct damon_operations {
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
 			struct damon_target *t, struct damon_region *r,
 			struct damos *scheme);
-	bool (*target_valid)(void *target);
+	bool (*target_valid)(struct damon_target *t);
 	void (*cleanup)(struct damon_ctx *context);
 };
 
--- a/mm/damon/vaddr.c~mm-damon-use-struct-damon_target-instead-of-void-in-target_valid
+++ a/mm/damon/vaddr.c
@@ -593,9 +593,8 @@ static unsigned int damon_va_check_acces
  * Functions for the target validity check and cleanup
  */
 
-static bool damon_va_target_valid(void *target)
+static bool damon_va_target_valid(struct damon_target *t)
 {
-	struct damon_target *t = target;
 	struct task_struct *task;
 
 	task = damon_get_task_struct(t);
_

Patches currently in -mm which might be from kaixuxia@tencent.com are


