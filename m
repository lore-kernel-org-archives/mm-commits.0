Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB3FC77B7F
	for <mm-commits@archiver.kernel.org>; Sat, 13 May 2023 00:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240678AbjEMAKm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 20:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240627AbjEMAKk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 20:10:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551042101
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 17:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDD3E64F79
        for <mm-commits@vger.kernel.org>; Sat, 13 May 2023 00:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F53CC433D2;
        Sat, 13 May 2023 00:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683936637;
        bh=Hsdr1aDIrr41wtbwaXhXWpJ8z4nuFEikySQVFt6kSK0=;
        h=Date:To:From:Subject:From;
        b=OEzdkod71skIyVjYcJ4eTmrWdsg6UAdPeon2g+KgcrbzB2Bl2OxLpovFaPPcMAX6r
         suKo36gzPXkyPAj9lmsKsvT1CgSYf6snJbftiH9KK9Fo8yjO3UtdlVlj5kiQo42JQn
         IlNPMszoxsVePDMAeoyTFFVNNwXS58o9djrA38kA=
Date:   Fri, 12 May 2023 17:10:36 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch added to mm-unstable branch
Message-Id: <20230513001037.3F53CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: move sysctl register in memory_failure_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: move sysctl register in memory_failure_init()
Date: Mon, 8 May 2023 19:41:28 +0800

There is already a memory_failure_init(), don't add a new initcall, move
register_sysctl_init() into it to cleanup a bit.

Link: https://lkml.kernel.org/r/20230508114128.37081-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-move-sysctl-register-in-memory_failure_init
+++ a/mm/memory-failure.c
@@ -123,7 +123,6 @@ const struct attribute_group memory_fail
 	.attrs = memory_failure_attr,
 };
 
-#ifdef CONFIG_SYSCTL
 static struct ctl_table memory_failure_table[] = {
 	{
 		.procname	= "memory_failure_early_kill",
@@ -146,14 +145,6 @@ static struct ctl_table memory_failure_t
 	{ }
 };
 
-static int __init memory_failure_sysctl_init(void)
-{
-	register_sysctl_init("vm", memory_failure_table);
-	return 0;
-}
-late_initcall(memory_failure_sysctl_init);
-#endif /* CONFIG_SYSCTL */
-
 /*
  * Return values:
  *   1:   the page is dissolved (if needed) and taken off from buddy,
@@ -2441,6 +2432,8 @@ static int __init memory_failure_init(vo
 		INIT_WORK(&mf_cpu->work, memory_failure_work_func);
 	}
 
+	register_sysctl_init("vm", memory_failure_table);
+
 	return 0;
 }
 core_initcall(memory_failure_init);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch
mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch

