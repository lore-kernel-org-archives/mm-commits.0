Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37755C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 20:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244229AbiBOU54 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 15:57:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbiBOU5z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 15:57:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1A5E096
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 12:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CEAD618D1
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 20:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03AEC340EB;
        Tue, 15 Feb 2022 20:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644958663;
        bh=wiIDYfn3z82IJrtE5oou2OUlBG66XQ3yyqPi1XTbLEQ=;
        h=Date:To:From:Subject:From;
        b=bacIEpCoXYYKoFQL/s1x85ctEphy6z5C0iRtjujfG9POrzQcuRgStVLoenEGzy73k
         TW+EiZyq8rsmfV2RsRWEONgycwfuCkx3istf9k035f2b82EONgLzexJkI/MPoZzOUJ
         FejblDfd45mfVAQ4XSI/SmlIDdhj+5G5y3YdJqgs=
Date:   Tue, 15 Feb 2022 12:57:43 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch added to -mm tree
Message-Id: <20220215205743.D03AEC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr,vaddr: register themselves to DAMON in subsys_initcall
has been added to the -mm tree.  Its filename is
     mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr,vaddr: register themselves to DAMON in subsys_initcall

This commit makes the monitoring operations for the physical address space
and virtual address spaces register themselves to DAMON in the
subsys_initcall step.  Later, in-kernel DAMON user code can use them via
damon_select_ops() without have to unnecessarily depend on all possible
monitoring operations implementations.

Link: https://lkml.kernel.org/r/20220215184603.1479-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   20 ++++++++++++++++++++
 mm/damon/vaddr.c |   20 ++++++++++++++++++++
 2 files changed, 40 insertions(+)

--- a/mm/damon/paddr.c~mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall
+++ a/mm/damon/paddr.c
@@ -273,3 +273,23 @@ void damon_pa_set_operations(struct damo
 	ctx->ops.apply_scheme = damon_pa_apply_scheme;
 	ctx->ops.get_scheme_score = damon_pa_scheme_score;
 }
+
+static int __init damon_pa_initcall(void)
+{
+	struct damon_operations ops = {
+		.id = DAMON_OPS_PADDR,
+		.init = NULL,
+		.update = NULL,
+		.prepare_access_checks = damon_pa_prepare_access_checks,
+		.check_accesses = damon_pa_check_accesses,
+		.reset_aggregated = NULL,
+		.target_valid = damon_pa_target_valid,
+		.cleanup = NULL,
+		.apply_scheme = damon_pa_apply_scheme,
+		.get_scheme_score = damon_pa_scheme_score,
+	};
+
+	return damon_register_ops(&ops);
+};
+
+subsys_initcall(damon_pa_initcall);
--- a/mm/damon/vaddr.c~mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall
+++ a/mm/damon/vaddr.c
@@ -752,4 +752,24 @@ void damon_va_set_operations(struct damo
 	ctx->ops.get_scheme_score = damon_va_scheme_score;
 }
 
+static int __init damon_va_initcall(void)
+{
+	struct damon_operations ops = {
+		.id = DAMON_OPS_VADDR,
+		.init = damon_va_init,
+		.update = damon_va_update,
+		.prepare_access_checks = damon_va_prepare_access_checks,
+		.check_accesses = damon_va_check_accesses,
+		.reset_aggregated = NULL,
+		.target_valid = damon_va_target_valid,
+		.cleanup = NULL,
+		.apply_scheme = damon_va_apply_scheme,
+		.get_scheme_score = damon_va_scheme_score,
+	};
+
+	return damon_register_ops(&ops);
+};
+
+subsys_initcall(damon_va_initcall);
+
 #include "vaddr-test.h"
_

Patches currently in -mm which might be from sj@kernel.org are

mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2.patch
mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch
mm-damon-rename-damon_primitives-to-damon_operations.patch
mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
mm-damon-dbgfs-test-fix-is_target_id-change.patch
mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch

