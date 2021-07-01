Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422C0C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2965461468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbhGABxN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238443AbhGABxM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0696146D;
        Thu,  1 Jul 2021 01:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104243;
        bh=ENApBjEaO1KjfEOhm60Hc0/aVXPQIXc8yzvZc6IY0Ck=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SQTBmV+oX8L/dPdkw5XiOSypuyI14pAdWiJpXIt8EX5awzM0j69OajqXnZnbyWo3r
         yiEK9kbguXf9w5dq7uYJnclTEemY7uGijy5ajiVWrm6vErt1Eqz3jiYb4mIqovblF1
         u13jFxcJ9W04GQEeKwDQR9pvL5LElafndlR9Ogck=
Date:   Wed, 30 Jun 2021 18:50:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        sjenning@redhat.com, torvalds@linux-foundation.org
Subject:  [patch 066/192] mm/zbud: reuse unbuddied[0] as buddied in
 zbud_pool
Message-ID: <20210701015042.NdLnvShOK%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zbud: reuse unbuddied[0] as buddied in zbud_pool

Patch series "Cleanups for zbud", v2.

This series contains just cleanups to save some possible memory in
zbud_pool and avoid exporting any unneeded zbud API.  More details can be
found in the respective changelogs


This patch (of 2):

Since commit 9d8c5b5284e4 ("mm: zbud: fix condition check on allocation
size"), zbud_pool.unbuddied[0] is always unused.  We can reuse it as
buddied field to save some possible memory.

Link: https://lkml.kernel.org/r/20210608114515.206992-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210608114515.206992-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/zbud.c~mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool
+++ a/mm/zbud.c
@@ -93,8 +93,14 @@
  */
 struct zbud_pool {
 	spinlock_t lock;
-	struct list_head unbuddied[NCHUNKS];
-	struct list_head buddied;
+	union {
+		/*
+		 * Reuse unbuddied[0] as buddied on the ground that
+		 * unbuddied[0] is unused.
+		 */
+		struct list_head buddied;
+		struct list_head unbuddied[NCHUNKS];
+	};
 	struct list_head lru;
 	u64 pages_nr;
 	const struct zbud_ops *ops;
_
