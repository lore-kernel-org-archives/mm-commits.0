Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABBBFC11F6A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A2CD61480
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbhGAB7R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238579AbhGAB7H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D929F61469;
        Thu,  1 Jul 2021 01:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104598;
        bh=oygytOw7VDumW93VzYSF4Gu6w91eRl9BB8m8m5UI6w0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wW99Dzkhy3gHaDSqymtYneCbzJBNPo4+fORql8ZGxpIia36NvemApbg0Cnuy7z+DA
         yPIKqsX/u7jY4FGuUOe9MHDTEMs+l5YiCm+PpBO95g9tRQdB/kXdMJCJxNiyEMqTGO
         aS9FhfIairdoqAO5DCbAXdSJqHDo0sLwmxeZ1DCE=
Date:   Wed, 30 Jun 2021 18:56:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        torvalds@linux-foundation.org
Subject:  [patch 179/192] hfsplus: remove unnecessary oom message
Message-ID: <20210701015637.LXYhTDzFj%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
