Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E367C76196
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 23:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbjDFXab (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 19:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjDFXaa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 19:30:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29679EC5
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 16:30:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DCBC6498D
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 23:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20CAC433EF;
        Thu,  6 Apr 2023 23:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680823828;
        bh=hv+y/o+kr+LQWqtchDDaiuo3DoprlBLyxrgkc3XvMC4=;
        h=Date:To:From:Subject:From;
        b=dCpTT11P7PusI/cMY/chY1MmHFyKAc5uWeEcCYsbvgVpxyPYr5twEJutKtUBw/7KM
         h57F5SwFoNEWeW6KZGdjyC+grd12H5gUR2MwyoPW5r8y+7TfIwPdZWPC4zD3RBpOlZ
         8IkBCpSK5Hmmaw69Aama1sZbY5mTJpv1mnCbBP9w=
Date:   Thu, 06 Apr 2023 16:30:28 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, riel@surriel.com,
        mhocko@suse.com, hannes@cmpxchg.org, david@redhat.com,
        bagasdotme@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-new-api-to-enable-ksm-per-process-fix.patch added to mm-unstable branch
Message-Id: <20230406233028.C20CAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-new-api-to-enable-ksm-per-process-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-new-api-to-enable-ksm-per-process-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-new-api-to-enable-ksm-per-process-fix.patch

This patch will later appear in the mm-unstable branch at
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
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch

