Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5B8C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 00:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiLPAlY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 19:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiLPAlS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 19:41:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3828936C49
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 16:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA40261F97
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 00:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269DBC433F0;
        Fri, 16 Dec 2022 00:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671151276;
        bh=uGI2u7yT+rbl+5ZAG9+5+hvhPNCK8WoaXWVdaqrs16A=;
        h=Date:To:From:Subject:From;
        b=hRI6kLNH16BM4hMketHWC/fu3nw1HVOUOywTmnfaFdDsUWlL4rmM0nPHTJeUlFKoy
         AKHaKGwZpoH+m7uzoyQEKLxy5E60ChL8YRVDF51Gwz28c8Vdg+TcjAucpW2hYI+Q9k
         d2OxqbPeKEPIQSBd0OzsPuO5fWbEG1Otd6II0ks8=
Date:   Thu, 15 Dec 2022 16:41:15 -0800
To:     mm-commits@vger.kernel.org, wangyufen@huawei.com, vbabka@suse.cz,
        peterz@infradead.org, ojeda@kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, isabbasso@riseup.net,
        dan.j.williams@intel.com, akinobu.mita@gmail.com,
        weiyongjun1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fault-injection-make-some-stack-filter-attrs-more-readable.patch removed from -mm tree
Message-Id: <20221216004116.269DBC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fault-injection: make some stack filter attrs more readable
has been removed from the -mm tree.  Its filename was
     fault-injection-make-some-stack-filter-attrs-more-readable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: fault-injection: make some stack filter attrs more readable
Date: Wed, 17 Aug 2022 08:03:31 +0000

Attributes of stack filter are show as unsigned decimal, such as
'require-start', 'require-end'.  This patch change to show them as
unsigned hexadecimal for more readable.

Before:
  $ echo 0xffffffffc0257000 > /sys/kernel/debug/failslab/require-start
  $ cat /sys/kernel/debug/failslab/require-start
  18446744072638263296

After:
  $ echo 0xffffffffc0257000 > /sys/kernel/debug/failslab/require-start
  $ cat /sys/kernel/debug/failslab/require-start
  0xffffffffc0257000

[wangyufen@huawei.com: use debugfs_create_xul() instead of debugfs_create_xl()]
  Link: https://lkml.kernel.org/r/1664331299-4976-1-git-send-email-wangyufen@huawei.com
Link: https://lkml.kernel.org/r/20220817080332.1052710-4-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Isabella Basso <isabbasso@riseup.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/fault-inject.c~fault-injection-make-some-stack-filter-attrs-more-readable
+++ a/lib/fault-inject.c
@@ -226,10 +226,10 @@ struct dentry *fault_create_debugfs_attr
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 	debugfs_create_stacktrace_depth("stacktrace-depth", mode, dir,
 					&attr->stacktrace_depth);
-	debugfs_create_ul("require-start", mode, dir, &attr->require_start);
-	debugfs_create_ul("require-end", mode, dir, &attr->require_end);
-	debugfs_create_ul("reject-start", mode, dir, &attr->reject_start);
-	debugfs_create_ul("reject-end", mode, dir, &attr->reject_end);
+	debugfs_create_xul("require-start", mode, dir, &attr->require_start);
+	debugfs_create_xul("require-end", mode, dir, &attr->require_end);
+	debugfs_create_xul("reject-start", mode, dir, &attr->reject_start);
+	debugfs_create_xul("reject-end", mode, dir, &attr->reject_end);
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 	attr->dname = dget(dir);
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are


