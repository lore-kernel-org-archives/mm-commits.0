Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48383C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347624AbiATV3H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38808 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377902AbiATV3G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ADB161715
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903CDC340E0;
        Thu, 20 Jan 2022 21:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714145;
        bh=JTbP3yIlL39S3jfN3FCXMpLpThG/HydlgYSEhyoTu8M=;
        h=Date:From:To:Subject:From;
        b=dUYUSD2Oiw/Oun1Gj/wZUMNxuPA4N1bYmgoo8dO69V17HHbKn7jIYzAcHytlhTJNj
         dEljzOtV0/zh5Oj3wzKKlrPyZnyuaR7Z9wsKYuA6+4LBCyQxvlkny8JbiM3XSHvq+I
         TvS/aZaYZomDI53eqEF2aJtzDW+zLWOv6dHzAs4U=
Date:   Thu, 20 Jan 2022 13:29:05 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-dbgfs-remove-a-unnecessary-variable.patch removed from -mm tree
Message-ID: <20220120212905.WwjscCiZp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: remove an unnecessary variable
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-remove-a-unnecessary-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: remove an unnecessary variable

Patch series "mm/damon: Hide unnecessary information disclosures".

DAMON is exposing some unnecessary information including kernel pointer
in kernel log and tracepoint.  This patchset hides such information.
The first patch is only for a trivial cleanup, though.


This patch (of 4):

This commit removes a unnecessarily used variable in
dbgfs_target_ids_write().

Link: https://lkml.kernel.org/r/20211229131016.23641-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211229131016.23641-2-sj@kernel.org
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-remove-a-unnecessary-variable
+++ a/mm/damon/dbgfs.c
@@ -364,7 +364,7 @@ static ssize_t dbgfs_target_ids_write(st
 	struct damon_ctx *ctx = file->private_data;
 	struct damon_target *t, *next_t;
 	bool id_is_pid = true;
-	char *kbuf, *nrs;
+	char *kbuf;
 	unsigned long *targets;
 	ssize_t nr_targets;
 	ssize_t ret;
@@ -374,14 +374,13 @@ static ssize_t dbgfs_target_ids_write(st
 	if (IS_ERR(kbuf))
 		return PTR_ERR(kbuf);
 
-	nrs = kbuf;
 	if (!strncmp(kbuf, "paddr\n", count)) {
 		id_is_pid = false;
 		/* target id is meaningless here, but we set it just for fun */
 		scnprintf(kbuf, count, "42    ");
 	}
 
-	targets = str_to_target_ids(nrs, count, &nr_targets);
+	targets = str_to_target_ids(kbuf, count, &nr_targets);
 	if (!targets) {
 		ret = -ENOMEM;
 		goto out;
_

Patches currently in -mm which might be from sj@kernel.org are


