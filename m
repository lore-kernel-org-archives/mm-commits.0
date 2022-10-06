Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C26AC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  6 Oct 2022 20:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiJFU1i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Oct 2022 16:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiJFU12 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2022 16:27:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29ADEBEAFA
        for <mm-commits@vger.kernel.org>; Thu,  6 Oct 2022 13:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 104F261AE4
        for <mm-commits@vger.kernel.org>; Thu,  6 Oct 2022 20:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7F0C433C1;
        Thu,  6 Oct 2022 20:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665088039;
        bh=7WiCIEodz8SZIN3k3nx5Vk8ULhD5mefxWAkRY4GEc78=;
        h=Date:To:From:Subject:From;
        b=iaXJ8lacxIMx/qOZs0TYJS1GU25lX5ZHYijF3CevEFzCeNesX+wH3Fshvx0T4gDam
         CE3RBX0PWC8xRb47kuDVxNSSL4hpOOfFCiofVIMYLUQtfOkJCvNOIR8933GOGla9a/
         i7CLcy8Zxd8DKgx+0GC/hzNAXjYjPhF80icm+gZg=
Date:   Thu, 06 Oct 2022 13:27:18 -0700
To:     mm-commits@vger.kernel.org, weiyongjun1@huawei.com,
        akinobu.mita@gmail.com, wangyufen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-injection-make-some-stack-filter-attrs-more-readable-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20221006202719.5E7F0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fault-injection: use debugfs_create_xul() instead of debugfs_create_xl()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-injection-make-some-stack-filter-attrs-more-readable-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-injection-make-some-stack-filter-attrs-more-readable-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

fault-injection-make-some-stack-filter-attrs-more-readable-fix.patch

