Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E051C77B78
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 19:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjEBTOl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 15:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjEBTOh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 15:14:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D251FDD
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 12:14:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF849621DB
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 19:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E92BC433EF;
        Tue,  2 May 2023 19:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683054870;
        bh=34qm5gWAOOFkX/WpnSAldTwnIue99Qu9IvvRhP8YnUo=;
        h=Date:To:From:Subject:From;
        b=zeWCiui5wM9zbYLyN/jO6F3GGja41mLE757yy+lR61a18aGC5bSgK1HYniY9pe4Rx
         uh3G0jk5KubcbyFg79h06WwZMyyEPBEs2fox1Szt4GQcHtHgbHujJbYy8QGRubRS5C
         QbTIJU5eehT0giftahcW+TswHLC3A62TpNuzZCQg=
Date:   Tue, 02 May 2023 12:14:29 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        Liam.Howlett@oracle.com, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-always-check-invariants.patch added to mm-hotfixes-unstable branch
Message-Id: <20230502191430.0E92BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: always check invariants
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap-vma_merge-always-check-invariants.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-always-check-invariants.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-mempolicy-correctly-update-prev-when-policy-is-equal-on-mbind.patch
mm-mmap-vma_merge-always-check-invariants.patch
mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch

