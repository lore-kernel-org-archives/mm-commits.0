Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DEDC41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbjHKWew (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjHKWev (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FC71FED
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7D2C674F0
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2A8C433C7;
        Fri, 11 Aug 2023 22:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691793290;
        bh=XYl9mtHtaUe6YytdeeBpe30sSXpHNkUGjGbFcq2RLNA=;
        h=Date:To:From:Subject:From;
        b=Wg0XGZMXsMgf74w1eTDDSRpUnzleaulwRvMGQXHEc/WHJlm30MQBb0PyLbiITQjMO
         eH49h7pdlD98H+w8FM8X1MOZVzohCSeLYzOJ9Fgm/Ob4hdXQSY4Xf/kl5ISdXNIL9Z
         eV6K556EG5e7k4M03ydFZtDMV9D+TUGIISS46Uc4=
Date:   Fri, 11 Aug 2023 15:34:49 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        muchun.song@linux.dev, glider@google.com, elver@google.com,
        dvyukov@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch removed from -mm tree
Message-Id: <20230811223450.4A2A8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-kfence-allocate-kfence_metadata-at-runtime-fix
has been removed from the -mm tree.  Its filename was
     mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch

This patch was dropped because it was folded into mm-kfence-allocate-kfence_metadata-at-runtime.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kfence-allocate-kfence_metadata-at-runtime-fix
Date: Tue Jul 18 10:20:11 AM PDT 2023

restore newline, per Marco

Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kfence/core.c~mm-kfence-allocate-kfence_metadata-at-runtime-fix
+++ a/mm/kfence/core.c
@@ -912,6 +912,7 @@ static int kfence_init_late(void)
 
 #ifdef CONFIG_CONTIG_ALLOC
 	struct page *pages;
+
 	pages = alloc_contig_pages(nr_pages_pool, GFP_KERNEL, first_online_node,
 				   NULL);
 	if (!pages)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
mm-kfence-allocate-kfence_metadata-at-runtime.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
mm-remove-redundant-k-macro-definition-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch
drm-i915-move-abs_diff-to-mathh-fix-fix.patch
nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch

