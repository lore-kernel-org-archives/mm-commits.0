Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80D9C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbiCVVu3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236925AbiCVVuZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00A263CB
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D387B81DAB
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3696C340EE;
        Tue, 22 Mar 2022 21:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985733;
        bh=tOQnzJ88rpOy/7gqFaTnVjvoh2gUiMPmtDcK0bJDp/E=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=jr9JdEtgvbT762Anr/iQDJ2MKgpLMVIBSbvkitCkSJLoG9oe6jJLOE4jJsSJl8vZJ
         B9t/3s90d1qpvNLEH6kmRnuDxJRc4dNAC6lbxXKX90YLlUnl39SA36Bjs5Q8Pi7Vlt
         dwCxTybF+82YJA/EKu/IvDXc6NGiHDSjnj2UyQKY=
Date:   Tue, 22 Mar 2022 14:48:52 -0700
To:     xhao@linux.alibaba.com, rientjes@google.com, sj@kernel.org,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 204/227] mm/damon/paddr,vaddr: register themselves to DAMON in subsys_initcall
Message-Id: <20220322214852.E3696C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
