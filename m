Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCC3C61DA4
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 23:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBWXQL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 18:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBWXQL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 18:16:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1213E6012B
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 15:15:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A56ACB81B58
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 23:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E9AC433D2;
        Thu, 23 Feb 2023 23:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677194155;
        bh=ehs+lHR+rSIg+66xPsvj3YDKYdbkApzBGSB0aeBWnmA=;
        h=Date:To:From:Subject:From;
        b=Fjhw2x6ZlbJu4udC8epNeqU25r+mcNcB1no24TesJFe9UR5QjXnCc2TBdA9T6t0+y
         Il6xJ8hzflLeHKtVtXFq2woFeWno+xxYVRFLNmCkQJAVUtIyk6oTcRFx+00DfaI/jf
         BZIepMFq7hR55I+kV4CF4rsRw/WY1TRb1CE764ZY=
Date:   Thu, 23 Feb 2023 15:15:54 -0800
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        pgofman@codeweavers.com, peterx@redhat.com, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230223231555.57E9AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-userfaultfd-support-wp-on-multiple-vmas-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: mm-userfaultfd-support-wp-on-multiple-vmas-fix
Date: Thu Feb 23 03:13:06 PM PST 2023

s/VM_WARN_ON_ONCE/VM_WARN_ONCE/ to fix build

Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Paul Gofman <pgofman@codeweavers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/userfaultfd.c~mm-userfaultfd-support-wp-on-multiple-vmas-fix
+++ a/mm/userfaultfd.c
@@ -717,7 +717,7 @@ long uffd_wp_range(struct mm_struct *dst
 	struct mmu_gather tlb;
 	long ret;
 
-	VM_WARN_ON_ONCE(start < dst_vma->vm_start || start + len > dst_vma->vm_end,
+	VM_WARN_ONCE(start < dst_vma->vm_start || start + len > dst_vma->vm_end,
 			"The address range exceeds VMA boundary.\n");
 	if (enable_wp)
 		mm_cp_flags = MM_CP_UFFD_WP;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch

