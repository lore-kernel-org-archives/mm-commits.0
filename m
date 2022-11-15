Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A291C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiKOWLf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiKOWLd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:11:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C4C2FC1D
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:11:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66ACEB81B61
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9D3C433D6;
        Tue, 15 Nov 2022 22:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668550290;
        bh=OIy5zthl3d9V04I1NuLUk3cX6YK3YdWZ9o4xCtoqRfQ=;
        h=Date:To:From:Subject:From;
        b=2chvmJkCQnFNmoJi8kD0acyJpYgA/NpUFE7BGiUjz0MIRTXInSG6e6hoENckin/LS
         dH4UnNEiZlHQZ+tDbLLOKGlWl8Cij1o/QK+vPYARr7BNUlK6pWeic00CHZ3mgKYLv6
         4fYNxxkm87LW4Ak2qM3HBJ16tS9BmJyWHl/R3TnQ=
Date:   Tue, 15 Nov 2022 14:11:29 -0800
To:     mm-commits@vger.kernel.org, weiyongjun1@huawei.com,
        akinobu.mita@gmail.com, wangyufen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fault-injection-make-some-stack-filter-attrs-more-readable-fix.patch removed from -mm tree
Message-Id: <20221115221130.0A9D3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fault-injection: use debugfs_create_xul() instead of debugfs_create_xl()
has been removed from the -mm tree.  Its filename was
     fault-injection-make-some-stack-filter-attrs-more-readable-fix.patch

This patch was dropped because it was folded into fault-injection-make-some-stack-filter-attrs-more-readable.patch

------------------------------------------------------
From: Wang Yufen <wangyufen@huawei.com>
Subject: fault-injection: use debugfs_create_xul() instead of debugfs_create_xl()
Date: Wed, 28 Sep 2022 10:14:59 +0800

Use debugfs_create_xul() instead of debugfs_create_xl(), and del the local
define debugfs_create_xl().

Link: https://lkml.kernel.org/r/1664331299-4976-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Suggested-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/lib/fault-inject.c~fault-injection-make-some-stack-filter-attrs-more-readable-fix
+++ a/lib/fault-inject.c
@@ -179,14 +179,6 @@ static void debugfs_create_ul(const char
 
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 
-DEFINE_SIMPLE_ATTRIBUTE(fops_xl, debugfs_ul_get, debugfs_ul_set, "0x%llx\n");
-
-static void debugfs_create_xl(const char *name, umode_t mode,
-			      struct dentry *parent, unsigned long *value)
-{
-	debugfs_create_file(name, mode, parent, value, &fops_xl);
-}
-
 static int debugfs_stacktrace_depth_set(void *data, u64 val)
 {
 	*(unsigned long *)data =
@@ -231,10 +223,10 @@ struct dentry *fault_create_debugfs_attr
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 	debugfs_create_stacktrace_depth("stacktrace-depth", mode, dir,
 					&attr->stacktrace_depth);
-	debugfs_create_xl("require-start", mode, dir, &attr->require_start);
-	debugfs_create_xl("require-end", mode, dir, &attr->require_end);
-	debugfs_create_xl("reject-start", mode, dir, &attr->reject_start);
-	debugfs_create_xl("reject-end", mode, dir, &attr->reject_end);
+	debugfs_create_xul("require-start", mode, dir, &attr->require_start);
+	debugfs_create_xul("require-end", mode, dir, &attr->require_end);
+	debugfs_create_xul("reject-start", mode, dir, &attr->reject_start);
+	debugfs_create_xul("reject-end", mode, dir, &attr->reject_end);
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 	attr->dname = dget(dir);
_

Patches currently in -mm which might be from wangyufen@huawei.com are

fault-injection-make-some-stack-filter-attrs-more-readable.patch

