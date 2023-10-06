Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC5FE94125
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbjJFVrY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbjJFVrS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE35F1
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D318FC433C9;
        Fri,  6 Oct 2023 21:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628833;
        bh=ZkL8dg8orLG2WM/ntWFnCNWS7CB4Smr2TI0mea5P9y8=;
        h=Date:To:From:Subject:From;
        b=hk4njDxm1d3TYwZIxe8YPZNL5ZjL38PPyGOQF1MXPc4JH9vA6AedV24GOhsPTsGEZ
         YXjDB2EyeA2isiZwdJJg0SI6e+U+3ns0+YJ4k6JWcY/saJiW11rkR9jmHqPfucDFCR
         caoRIzrVkjEuMMF2ZEBFkq2ox1FwbWXJmf5TvUoI=
Date:   Fri, 06 Oct 2023 14:47:10 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, riel@surriel.com,
        hannes@cmpxchg.org, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-ksm-document-smart-scan-mode-fix-2.patch removed from -mm tree
Message-Id: <20231006214712.D318FC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-ksm-document-smart-scan-mode-fix
has been removed from the -mm tree.  Its filename was
     mm-ksm-document-smart-scan-mode-fix-2.patch

This patch was dropped because it was folded into mm-ksm-document-smart-scan-mode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-ksm-document-smart-scan-mode-fix
Date: Tue Sep 26 05:48:29 PM PDT 2023

document that smart_scan defaults to on

Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-ksm-document-smart-scan-mode-fix-2
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -156,12 +156,12 @@ stable_node_chains_prune_millisecs
         ``max_page_sharing`` yet.
 
 smart_scan
-        By default KSM checks every candidate page for each scan. It does
-        not take into account historic information. When smart scan is
+        Historically KSM checked every candidate page for each scan. It did
+        not take into account historic information.  When smart scan is
         enabled, pages that have previously not been de-duplicated get
         skipped. How often these pages are skipped depends on how often
         de-duplication has already been tried and failed. By default this
-        optimization is disabled. The ``pages_skipped`` metric shows how
+        optimization is enabled.  The ``pages_skipped`` metric shows how
         effective the setting is.
 
 The effectiveness of KSM and MADV_MERGEABLE is shown in ``/sys/kernel/mm/ksm/``:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-ksm-document-smart-scan-mode.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch

