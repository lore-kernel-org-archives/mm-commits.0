Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300EFC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BBDF61C7F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhGFTV0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhGFTV0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C60061C7C;
        Tue,  6 Jul 2021 19:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599126;
        bh=UINFrrU6FyLVnkQfv7D5yQUdKY4n7ka+oxB93Nodv7k=;
        h=Date:From:To:Subject:From;
        b=FeUhujv1BZzlgidO5Th/aNaol2qsUCwywMFEEuAwLIAfoxKvuUkTfMaPts5CTGfXi
         wSm8lA/PqdzgZsgHDySGVDeu0NhT/nc8W5Hz1+FCwe7v8/ydF+8+HDxpb28DqHTxBJ
         pQ20dviuk+WLaSllNSTWunPtftdwLPN+lSl8tKas=
Date:   Tue, 06 Jul 2021 12:18:46 -0700
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, sjenning@redhat.com
Subject:  [merged]
 mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch removed from -mm tree
Message-ID: <20210706191846.D42tvOYEM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: reuse unbuddied[0] as buddied in zbud_pool
has been removed from the -mm tree.  Its filename was
     mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

