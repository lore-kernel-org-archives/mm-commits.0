Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8FFC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6C4561252
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhKEUus (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233838AbhKEUus (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:50:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC3A760FBF;
        Fri,  5 Nov 2021 20:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145288;
        bh=8zNn0MTxAyxMFfsR2o/RpV1VmQ5LkBRO4BH3td/iDdk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IYW5oQV4FQVoInok6fvQeiuXjqjkirgW+Jrb7HTCHRTkFb/9uuLPabxOX44McEj3z
         ObtdTdzn7mMUHRHtulxIC3XqrQ0AyO+YPggEHlkZXwtFx/en3RG4YLddPz3uQlw66v
         RFByHfdgSbvM93BiYZKMoY9YKRAng3XyRZpdiPn0=
Date:   Fri, 05 Nov 2021 13:48:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org, xhao@linux.alibaba.com
Subject:  [patch 255/262] mm/damon/dbgfs: add adaptive_targets list
 check before enable monitor_on
Message-ID: <20211105204807.WLs3d5z72%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/dbgfs: add adaptive_targets list check before enable monitor_on

When the ctx->adaptive_targets list is empty, I did some test on
monitor_on interface like this.

    # cat /sys/kernel/debug/damon/target_ids
    #
    # echo on > /sys/kernel/debug/damon/monitor_on
    # damon: kdamond (5390) starts

Though the ctx->adaptive_targets list is empty, but the kthread_run still
be called, and the kdamond.x thread still be created, this is meaningless.

So there adds a judgment in 'dbgfs_monitor_on_write', if the
ctx->adaptive_targets list is empty, return -EINVAL.

Link: https://lkml.kernel.org/r/0a60a6e8ec9d71989e0848a4dc3311996ca3b5d4.1634720326.git.xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |    5 +++++
 mm/damon/dbgfs.c      |   15 ++++++++++++---
 3 files changed, 18 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-dbgfs-add-adaptive_targets-list-check-before-enable-monitor_on
+++ a/include/linux/damon.h
@@ -440,6 +440,7 @@ void damon_destroy_scheme(struct damos *
 
 struct damon_target *damon_new_target(unsigned long id);
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
+bool damon_targets_empty(struct damon_ctx *ctx);
 void damon_free_target(struct damon_target *t);
 void damon_destroy_target(struct damon_target *t);
 unsigned int damon_nr_regions(struct damon_target *t);
--- a/mm/damon/core.c~mm-damon-dbgfs-add-adaptive_targets-list-check-before-enable-monitor_on
+++ a/mm/damon/core.c
@@ -180,6 +180,11 @@ void damon_add_target(struct damon_ctx *
 	list_add_tail(&t->list, &ctx->adaptive_targets);
 }
 
+bool damon_targets_empty(struct damon_ctx *ctx)
+{
+	return list_empty(&ctx->adaptive_targets);
+}
+
 static void damon_del_target(struct damon_target *t)
 {
 	list_del(&t->list);
--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-add-adaptive_targets-list-check-before-enable-monitor_on
+++ a/mm/damon/dbgfs.c
@@ -878,12 +878,21 @@ static ssize_t dbgfs_monitor_on_write(st
 		return -EINVAL;
 	}
 
-	if (!strncmp(kbuf, "on", count))
+	if (!strncmp(kbuf, "on", count)) {
+		int i;
+
+		for (i = 0; i < dbgfs_nr_ctxs; i++) {
+			if (damon_targets_empty(dbgfs_ctxs[i])) {
+				kfree(kbuf);
+				return -EINVAL;
+			}
+		}
 		ret = damon_start(dbgfs_ctxs, dbgfs_nr_ctxs);
-	else if (!strncmp(kbuf, "off", count))
+	} else if (!strncmp(kbuf, "off", count)) {
 		ret = damon_stop(dbgfs_ctxs, dbgfs_nr_ctxs);
-	else
+	} else {
 		ret = -EINVAL;
+	}
 
 	if (!ret)
 		ret = count;
_
