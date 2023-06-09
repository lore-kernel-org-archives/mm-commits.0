Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61E0C83005
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjFIX2I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbjFIX1f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A433A87
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC19563EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B754C433EF;
        Fri,  9 Jun 2023 23:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353244;
        bh=ijxxijGiJGRXsJlLY8Y9Oa0qUWlHsIehC2/4N0NbEVg=;
        h=Date:To:From:Subject:From;
        b=2q3P4ERsQgB1kNFN2ke9taj2AI2w11ism8lAa4O4OzknhlJSgggpMrPdyMlMagdg0
         +wHdowZCCGZyRTSD2hE5pHxVpl6Gk+cjVbCkMraWKRZAV3eljitThWhxPPKaEBsDhZ
         Y3I5gfImBWr6+QiKrxZXOu9/eFcMqsImqxLT2x/Q=
Date:   Fri, 09 Jun 2023 16:27:23 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch removed from -mm tree
Message-Id: <20230609232724.4B754C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: move sysctl register in memory_failure_init()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


