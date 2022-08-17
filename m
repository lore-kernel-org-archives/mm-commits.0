Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA23C3F6B0
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbiHQPya (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237992AbiHQPy2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:54:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629039C1C8
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:54:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDF06B81E1C
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B40DC433C1;
        Wed, 17 Aug 2022 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660751661;
        bh=YzKhTnTJiuo4ISV+Bf5ZiZjvIAZmUBFUHXoe11rCJOQ=;
        h=Date:To:From:Subject:From;
        b=nlgaFT5KMtcYLsQFEHtvz/Tstagop82IqK0q2qIsnfQ9zBEFSYwmoZwwjNPDor/JL
         XHgJ5FGp7QH9PIW3OqndNoaiMDV8JrUrwDTS/ucO8O7CoeV4aWX6IdXSjuQXsPJrUz
         uFC7GZxvUW9DFmSYuSuDa4EUHN9KqNrKjb4PBMU4=
Date:   Wed, 17 Aug 2022 08:54:20 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, isabbasso@riseup.net,
        dan.j.williams@intel.com, akinobu.mita@gmail.com,
        weiyongjun1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-injection-make-some-stack-filter-attrs-more-readable.patch added to mm-nonmm-unstable branch
Message-Id: <20220817155421.8B40DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fault-injection: make some stack filter attrs more readable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-injection-make-some-stack-filter-attrs-more-readable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-injection-make-some-stack-filter-attrs-more-readable.patch

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

Link: https://lkml.kernel.org/r/20220817080332.1052710-4-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
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

 lib/fault-inject.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/lib/fault-inject.c~fault-injection-make-some-stack-filter-attrs-more-readable
+++ a/lib/fault-inject.c
@@ -179,6 +179,14 @@ static void debugfs_create_ul(const char
 
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 
+DEFINE_SIMPLE_ATTRIBUTE(fops_xl, debugfs_ul_get, debugfs_ul_set, "0x%llx\n");
+
+static void debugfs_create_xl(const char *name, umode_t mode,
+			      struct dentry *parent, unsigned long *value)
+{
+	debugfs_create_file(name, mode, parent, value, &fops_xl);
+}
+
 static int debugfs_stacktrace_depth_set(void *data, u64 val)
 {
 	*(unsigned long *)data =
@@ -223,10 +231,10 @@ struct dentry *fault_create_debugfs_attr
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 	debugfs_create_stacktrace_depth("stacktrace-depth", mode, dir,
 					&attr->stacktrace_depth);
-	debugfs_create_ul("require-start", mode, dir, &attr->require_start);
-	debugfs_create_ul("require-end", mode, dir, &attr->require_end);
-	debugfs_create_ul("reject-start", mode, dir, &attr->reject_start);
-	debugfs_create_ul("reject-end", mode, dir, &attr->reject_end);
+	debugfs_create_xl("require-start", mode, dir, &attr->require_start);
+	debugfs_create_xl("require-end", mode, dir, &attr->require_end);
+	debugfs_create_xl("reject-start", mode, dir, &attr->reject_start);
+	debugfs_create_xl("reject-end", mode, dir, &attr->reject_end);
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 	attr->dname = dget(dir);
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are

fault-injection-allow-stacktrace-filter-for-x86-64.patch
fault-injection-skip-stacktrace-filtering-by-default.patch
fault-injection-make-some-stack-filter-attrs-more-readable.patch
fault-injection-make-stacktrace-filter-works-as-expected.patch

