Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B816C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiAVBXo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:23:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50816 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiAVBXo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:23:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28D1061AA5
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758C2C340E1;
        Sat, 22 Jan 2022 01:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814623;
        bh=GMkXmSdw8dAcIHkXvCfnPYIL58hJoflv1jn5skjgK+k=;
        h=Date:From:To:Subject:From;
        b=PJpszzY0WAuKYQTsrAKqStFQsV3FNAAhQdmXiIOtBRSAqczGpYOtJmBZ67dW6CG4f
         9ylPzzq86xBKRPCT47lNZln1XmbAuxyu0zzJbEGugbEEzZ67C1Oy2UQqK6b0Nun2NP
         EsBVlRIdoEEANQIwuSCVqm72Krb7qE7rkJrc1QHI=
Date:   Fri, 21 Jan 2022 17:23:43 -0800
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz
Subject:  [folded-merged]
 =?US-ASCII?Q?lib-stackdepot-allow-optional-init-and-stack=5Ftable-allo?=
 =?US-ASCII?Q?cation-by-kvmalloc-fix.patch?= removed from -mm tree
Message-ID: <20220122012343.3exqRx8fR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: fix spelling mistake and grammar in pr_err message
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix.patch

This patch was dropped because it was folded into lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: lib/stackdepot: fix spelling mistake and grammar in pr_err message

There is a spelling mistake of the work allocation so fix this and
re-phrase the message to make it easier to read.

Link: https://lkml.kernel.org/r/20211015104159.11282-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix
+++ a/lib/stackdepot.c
@@ -186,7 +186,7 @@ __ref int stack_depot_init(void)
 			for (i = 0; i < STACK_HASH_SIZE;  i++)
 				stack_table[i] = NULL;
 		} else {
-			pr_err("Stack Depot failed hash table allocationg, disabling\n");
+			pr_err("Stack Depot hash table allocation failed, disabling\n");
 			stack_depot_disable = true;
 			mutex_unlock(&stack_depot_init_mutex);
 			return -ENOMEM;
_

Patches currently in -mm which might be from colin.king@canonical.com are

lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch

