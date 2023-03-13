Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9F1C6FD19
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 17:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjCMRi0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 13:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjCMRiW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 13:38:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9263376A9
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 10:38:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F28B61451
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 17:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E125C433D2;
        Mon, 13 Mar 2023 17:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678729100;
        bh=HCR5macut0fHfIWhpBt1d6GODBcEh4XWUscR+676KI4=;
        h=Date:To:From:Subject:From;
        b=amLD9n6VNZJLW7vFPY3EHmHkTh7Ohc8L3IP+1Hy3qtqPWvQ2rlrZ1aWs/f/vyJCSo
         a0ub0K+Py1rAQIqVosVr5qHoRIsykZ9ZXbWHA6/7+Cc++dAHPxHTHJQYCrUuLCEMw0
         IRTIkRlToRkEM/t5zW4mOSvGNRJZrNzEVNbSweto=
Date:   Mon, 13 Mar 2023 10:38:19 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, riel@surriel.com,
        mhocko@suse.com, hannes@cmpxchg.org, david@redhat.com,
        bagasdotme@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-new-api-to-enable-ksm-per-process-fix.patch added to mm-unstable branch
Message-Id: <20230313173820.7E125C433D2@smtp.kernel.org>
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
Date: Mon Mar 13 10:37:16 AM PDT 2023

fix build, per Johannes

Link: https://lkml.kernel.org/r/20230313162603.GA965640@cmpxchg.org
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/ksm.c~mm-add-new-api-to-enable-ksm-per-process-fix
+++ a/mm/ksm.c
@@ -551,11 +551,11 @@ static bool vma_ksm_compatible(struct vm
 		return false;
 
 #ifdef VM_SAO
-	if (*vm_flags & VM_SAO)
+	if (vma->vm_flags & VM_SAO)
 		return false;
 #endif
 #ifdef VM_SPARC_ADI
-	if (*vm_flags & VM_SPARC_ADI)
+	if (vma->vm_flags & VM_SPARC_ADI)
 		return false;
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch

