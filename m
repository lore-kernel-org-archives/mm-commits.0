Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5F7C77B75
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjEEWnE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjEEWnE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:43:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CD05262
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:43:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E13761579
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82896C433D2;
        Fri,  5 May 2023 22:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326581;
        bh=dEsLyE491vg1ZIyB9TYZk8sNynw7vPdRckKoSsUcAho=;
        h=Date:To:From:Subject:From;
        b=H9sjrZXlFxcfU3nBsRtOkyqSUvACdMRR2GXUQXl4Nh/r0um2Mvbhi+p0ZXsVYYqK9
         7SFMi21QAkz2DeAHEjp2NQTwQ+zmoA8f8mNLBLSTre2mUMHoVFPEHiE+A6J7vtudtK
         4z5xhwsgxkc7cP3KXPrauIEc5ND4b/Aanov4bQsE=
Date:   Fri, 05 May 2023 15:43:00 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        Liam.Howlett@oracle.com, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-vma_merge-always-check-invariants.patch removed from -mm tree
Message-Id: <20230505224301.82896C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: always check invariants
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-always-check-invariants.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/mmap/vma_merge: always check invariants
Date: Sun, 30 Apr 2023 21:19:17 +0100

We may still have inconsistent input parameters even if we choose not to
merge and the vma_merge() invariant checks are useful for checking this
with no production runtime cost (these are only relevant when
CONFIG_DEBUG_VM is specified).

Therefore, perform these checks regardless of whether we merge.

This is relevant, as a recent issue (addressed in commit "mm/mempolicy:
Correctly update prev when policy is equal on mbind") in the mbind logic
was only picked up in the 6.2.y stable branch where these assertions are
performed prior to determining mergeability.

Had this remained the same in mainline this issue may have been picked up
faster, so moving forward let's always check them.

Link: https://lkml.kernel.org/r/df548a6ae3fa135eec3b446eb3dae8eb4227da97.1682885809.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-always-check-invariants
+++ a/mm/mmap.c
@@ -960,17 +960,17 @@ struct vm_area_struct *vma_merge(struct
 		merge_next = true;
 	}
 
+	/* Verify some invariant that must be enforced by the caller. */
+	VM_WARN_ON(prev && addr <= prev->vm_start);
+	VM_WARN_ON(curr && (addr != curr->vm_start || end > curr->vm_end));
+	VM_WARN_ON(addr >= end);
+
 	if (!merge_prev && !merge_next)
 		return NULL; /* Not mergeable. */
 
 	res = vma = prev;
 	remove = remove2 = adjust = NULL;
 
-	/* Verify some invariant that must be enforced by the caller. */
-	VM_WARN_ON(prev && addr <= prev->vm_start);
-	VM_WARN_ON(curr && (addr != curr->vm_start || end > curr->vm_end));
-	VM_WARN_ON(addr >= end);
-
 	/* Can we merge both the predecessor and the successor? */
 	if (merge_prev && merge_next &&
 	    is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL)) {
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch

