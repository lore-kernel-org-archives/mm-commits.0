Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2813C07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB07F61CA8
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhGFTZt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230003AbhGFTZs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6709161CAB;
        Tue,  6 Jul 2021 19:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599389;
        bh=giv+dOXUw+hiyzrk1RbBxYct00ZqqtEjDF9+kFQBsCY=;
        h=Date:From:To:Subject:From;
        b=Hd8Do3mnbYLsD+p1eetLvDW6QJpHY4HQe7bGfH7JN3HhZcR4zZA3PKvk/Y9VQO0YC
         7O8yVr5Gp5iGQoATMVUdtMQDy3Q2/IpRO1Qv5eH8m8J44HaE2Rzf3rrX6q6WiiITFb
         ooLUBKjJcx7LXqMbZqX3S5T/rCS2o4BbWsxmAqds=
Date:   Tue, 06 Jul 2021 12:23:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com
Subject:  [merged] hfsplus-remove-unnecessary-oom-message.patch
 removed from -mm tree
Message-ID: <20210706192309.nnpUnGdkb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: remove unnecessary oom message
has been removed from the -mm tree.  Its filename was
     hfsplus-remove-unnecessary-oom-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: hfsplus: remove unnecessary oom message

Fixes scripts/checkpatch.pl warning:
WARNING: Possible unnecessary 'out of memory' message

Remove it can help us save a bit of memory.

Link: https://lkml.kernel.org/r/20210617084944.1279-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/hfsplus/xattr.c~hfsplus-remove-unnecessary-oom-message
+++ a/fs/hfsplus/xattr.c
@@ -204,7 +204,6 @@ check_attr_tree_state_again:
 
 	buf = kzalloc(node_size, GFP_NOFS);
 	if (!buf) {
-		pr_err("failed to allocate memory for header node\n");
 		err = -ENOMEM;
 		goto end_attr_file_creation;
 	}
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

lib-test-fix-spelling-mistakes.patch
lib-fix-spelling-mistakes.patch
lib-fix-spelling-mistakes-in-header-files.patch
mm-fix-spelling-mistakes-in-header-files.patch

