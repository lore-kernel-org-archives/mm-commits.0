Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D603C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 24 Dec 2022 22:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiLXWQC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 24 Dec 2022 17:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLXWQB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 24 Dec 2022 17:16:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A382E631D
        for <mm-commits@vger.kernel.org>; Sat, 24 Dec 2022 14:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46CBD609E9
        for <mm-commits@vger.kernel.org>; Sat, 24 Dec 2022 22:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D829C433D2;
        Sat, 24 Dec 2022 22:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671920159;
        bh=BFKoGcDO2IiyFARvslmY5+6fANtm244wDp+vTMdna/M=;
        h=Date:To:From:Subject:From;
        b=I5u1qMASJZbcuKq3EAXdr4EP22JPXAmsOPs+yjiwaOUw6jIkfa6/WAxouSc9t+8Ki
         lfzSUJBJJ4SWygYg5AZxF0/9jPMeC6KIse2boiv742UlEj9sJyfpkLStel3TSldxrv
         modvlCQYclqqu1xleZ1iLz+f5Z/DXZEstoY7Oc5k=
Date:   Sat, 24 Dec 2022 14:15:57 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch added to mm-unstable branch
Message-Id: <20221224221559.9D829C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup: mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
Date: Sat, 24 Dec 2022 15:02:36 +0100

No need for additional harmless checks if we're wr-protecting either way.

Link: https://lkml.kernel.org/r/71412742-a71f-9c74-865f-773ad83db7a5@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/userfaultfd.c~mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix
+++ a/mm/userfaultfd.c
@@ -727,7 +727,7 @@ void uffd_wp_range(struct mm_struct *dst
 	 * to be write-protected as default whenever protection changes.
 	 * Try upgrading write permissions manually.
 	 */
-	if (vma_wants_manual_pte_write_upgrade(dst_vma))
+	if (!enable_wp && vma_wants_manual_pte_write_upgrade(dst_vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	tlb_gather_mmu(&tlb, dst_mm);
 	change_protection(&tlb, dst_vma, start, start + len, vma->vm_page_prot,
_

Patches currently in -mm which might be from david@redhat.com are

mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch

