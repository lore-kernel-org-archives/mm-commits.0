Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4369CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355633AbiCYBgP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357440AbiCYBfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E5E2657E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DE74B81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385FEC340EC;
        Fri, 25 Mar 2022 01:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171995;
        bh=XaHK+KonUc0QAZEyRCj2eLTRzdHCSFwQv0ZnbVHg070=;
        h=Date:To:From:Subject:From;
        b=Axkbr5BlNzYbgea6a3AhO/erzBD0o2+pc1RlxBJnNgOx53WGxRMJ8+WkS8CdwwdPa
         2ujV/pOJGv38Pw1U5HPivvomXR3dm8hPqxGXVgx6HpNsWDEtsk3UCsWdtM6o4P/HRb
         5kIHL9LPXjYNLIKizB1yFi68GeS8s6M92I6arNe8=
Date:   Thu, 24 Mar 2022 18:33:14 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch removed from -mm tree
Message-Id: <20220325013315.385FEC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr,vaddr: register themselves to DAMON in subsys_initcall
has been removed from the -mm tree.  Its filename was
     mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


