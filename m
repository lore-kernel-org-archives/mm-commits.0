Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212F2E784BE
	for <mm-commits@archiver.kernel.org>; Mon,  2 Oct 2023 15:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238124AbjJBPdf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237779AbjJBPdf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2023 11:33:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2734B8
        for <mm-commits@vger.kernel.org>; Mon,  2 Oct 2023 08:33:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A281C433C8;
        Mon,  2 Oct 2023 15:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696260812;
        bh=adI1YwR03cFSCUVYMb5mxTt3EdlFbOq7zS2i48JyMH8=;
        h=Date:To:From:Subject:From;
        b=a0u9nzweHXdYux5UrCIpWLRPkYcwMy33E77MDRoFLUEp7dg8LxELDYZexX5Z+ubGu
         z0niXjX+6zUuw2YFf/vYVct+tE/I1SMO+Qqo4wlLsXY9ceoGZoWnywL0yxIsSLtUB9
         bxsvmKAmwl2fPUog8nhT6k9f5UJ44XHEmrt/FCkw=
Date:   Mon, 02 Oct 2023 08:33:31 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, riel@surriel.com,
        hannes@cmpxchg.org, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-add-smart-page-scanning-mode-fix.patch added to mm-unstable branch
Message-Id: <20231002153332.4A281C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-ksm-add-smart-page-scanning-mode-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-add-smart-page-scanning-mode-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-add-smart-page-scanning-mode-fix.patch

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
mm-shrinker-convert-shrinker_rwsem-to-mutex-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-ksm-add-smart-page-scanning-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix.patch
kthread-add-kthread_stop_put-v2-fix.patch

