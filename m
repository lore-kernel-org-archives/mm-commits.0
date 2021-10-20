Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872A5C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69F146115B
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhJTWgI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 18:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhJTWgG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 18:36:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E654B6121E;
        Wed, 20 Oct 2021 22:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634769232;
        bh=Ztx3ukTgEDGM/4204YbZFXBWqxZYZUB7O4fsH3UZpSU=;
        h=Date:From:To:Subject:From;
        b=Yl9qT4qxzMZLeCdSnU0yZE0LvLvITrjm+L9Q/ab1+HW6Qma4HgmbcQ1ZUy/Qb+JDt
         vCjTy7pc6z9CxjJt17fMdw3kx9oF9gRL7NN8c2K6A0VWqKGbyqxJh5VDK2XldT3U4k
         RJIJBk/RdbDV1fv9EsyoqCI+y/2oUFYNT7kv9a5o=
Date:   Wed, 20 Oct 2021 15:33:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com
Subject:  +
 =?US-ASCII?Q?mm-damon-dbgfs-add-adaptive=5Ftargets-list-check-before-ena?=
 =?US-ASCII?Q?ble-monitor=5Fon.patch?= added to -mm tree
Message-ID: <20211020223351.SKPkbPHmS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: add adaptive_targets list check before enable monitor_on
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-add-adaptive_targets-list-check-before-enable-monitor_on.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-add-adaptive_targets-list-check-before-enable-monitor_on.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-add-adaptive_targets-list-check-before-enable-monitor_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-remove-unnecessary-variable-initialization.patch
mm-damon-dbgfs-add-adaptive_targets-list-check-before-enable-monitor_on.patch

