Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB22E94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbjJFVrT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbjJFVrM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9017CBE
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9F8C433C9;
        Fri,  6 Oct 2023 21:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628830;
        bh=hE9rIg0VyboHN3s7ngghtaBUNPeZyaPT6/5bB0Gx7Lo=;
        h=Date:To:From:Subject:From;
        b=yTOR75uGp0svYRFNmF41AwUEq8nTrpGa9vG4VLtHxotfF2xJ4QufVHRNTDFi4+Mw0
         h+lEAubXHchEAiC8J7OyO/OKk7ja2MlfT+eHuoSRqUZUTnKanOhUD+MMaIYMNfNwiN
         06WVj+wD/r/jGfDOrZ+6dMT0y3gSC9Xy+rdPwgN4=
Date:   Fri, 06 Oct 2023 14:47:07 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, riel@surriel.com,
        hannes@cmpxchg.org, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-ksm-add-smart-page-scanning-mode-fix.patch removed from -mm tree
Message-Id: <20231006214709.8C9F8C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-ksm-add-smart-page-scanning-mode-fix
has been removed from the -mm tree.  Its filename was
     mm-ksm-add-smart-page-scanning-mode-fix.patch

This patch was dropped because it was folded into mm-ksm-add-smart-page-scanning-mode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-ksm-add-smart-page-scanning-mode-fix
Date: Tue Sep 26 05:46:29 PM PDT 2023

make ksm_smart_scan default true, for testing

Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-add-smart-page-scanning-mode-fix
+++ a/mm/ksm.c
@@ -287,8 +287,9 @@ static unsigned int zero_checksum __read
 /* Whether to merge empty (zeroed) pages with actual zero pages */
 static bool ksm_use_zero_pages __read_mostly;
 
-/* Skip pages that couldn't be de-duplicated previously  */
-static bool ksm_smart_scan;
+/* Skip pages that couldn't be de-duplicated previously */
+/* Default to true at least temporarily, for testing */
+static bool ksm_smart_scan = true;
 
 /* The number of zero pages which is placed by KSM */
 unsigned long ksm_zero_pages;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-ksm-add-smart-page-scanning-mode.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch

