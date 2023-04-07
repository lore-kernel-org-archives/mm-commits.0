Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E34C76196
	for <mm-commits@archiver.kernel.org>; Fri,  7 Apr 2023 22:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjDGWU2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Apr 2023 18:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjDGWUY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2023 18:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB59CC23
        for <mm-commits@vger.kernel.org>; Fri,  7 Apr 2023 15:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCFC7654F0
        for <mm-commits@vger.kernel.org>; Fri,  7 Apr 2023 22:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38294C433EF;
        Fri,  7 Apr 2023 22:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680906000;
        bh=0wCZjoA6g1gPz6vBJmOGBWfOXYs1nCCT09kstKdDjTM=;
        h=Date:To:From:Subject:From;
        b=YsbwXSP/mrOzZJF8E+gZZvcDaiDRTzV7/HDlOoTsTROyYBoAIyVp0ICBfIAyod/C3
         rGz933Is6KPmaHl5GuSvO4A/yQmEMvfMFYgjEUzYeTnzVCtQf+L+AJiN5JJulXVayg
         x2ywmSzwso4Qnuhjtrqr0Dtd0qth9JGmNU6HzvW0=
Date:   Fri, 07 Apr 2023 15:19:59 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, riel@surriel.com,
        mhocko@suse.com, hannes@cmpxchg.org, david@redhat.com,
        bagasdotme@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-add-new-api-to-enable-ksm-per-process-fix.patch removed from -mm tree
Message-Id: <20230407222000.38294C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-add-new-api-to-enable-ksm-per-process-fix
has been removed from the -mm tree.  Its filename was
     mm-add-new-api-to-enable-ksm-per-process-fix.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-new-api-to-enable-ksm-per-process-fix
Date: Thu Apr  6 04:22:50 PM PDT 2023

fix build by removing errant ksm_add_mm() stub

Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/ksm.h~mm-add-new-api-to-enable-ksm-per-process-fix
+++ a/include/linux/ksm.h
@@ -62,10 +62,6 @@ void folio_migrate_ksm(struct folio *new
 
 #else  /* !CONFIG_KSM */
 
-static inline int ksm_add_mm(struct mm_struct *mm)
-{
-}
-
 static inline void ksm_add_vma(struct vm_area_struct *vma)
 {
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-treewide-redefine-max_order-sanely-fix-fix-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch

