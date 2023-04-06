Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92FA1C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjDFCs5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbjDFCsA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:48:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367A4A27D
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16D396421A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D425C433EF;
        Thu,  6 Apr 2023 02:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749138;
        bh=Jj9yja7IokC8ThHWFYhjomKAAMbgkKtfhg3WpqkcxB0=;
        h=Date:To:From:Subject:From;
        b=Sj+rlC6N+sQC5zPol8/XXeHaBlinuADiMYbuFdntFd/9P4hpMufaFzMuodyu2R/v9
         aYswHYZa5hIhvuHzmw7rYleTk5GCacVJ6Sq+sJwWEyHTBNvAwwyOSvfKuHl/685Gf2
         zjkml1sxUuT0kTKw9PFIHnNSrgjs65XnxXZAmemA=
Date:   Wed, 05 Apr 2023 19:45:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vernon2gm@gmail.com, vbabka@suse.cz, Liam.Howlett@oracle.com,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-fold-curr-next-assignment-logic.patch removed from -mm tree
Message-Id: <20230406024538.6D425C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: fold curr, next assignment logic
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-fold-curr-next-assignment-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/mmap/vma_merge: fold curr, next assignment logic
Date: Wed, 22 Mar 2023 20:18:58 +0000

Use find_vma_intersection() and vma_lookup() to both simplify the logic
and to fold the end == next->vm_start condition into one block.

This groups all of the simple range checks together and establishes the
invariant that, if prev, curr or next are non-NULL then their positions
are as expected.

This has no functional impact.

Link: https://lkml.kernel.org/r/c6d960641b4ba58fa6ad3d07bf68c27d847963c8.1679516210.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-fold-curr-next-assignment-logic
+++ a/mm/mmap.c
@@ -917,15 +917,14 @@ struct vm_area_struct *vma_merge(struct
 	if (vm_flags & VM_SPECIAL)
 		return NULL;
 
-	curr = find_vma(mm, prev ? prev->vm_end : 0);
-	if (curr && curr->vm_end == end)		/* cases 6, 7, 8 */
-		next = find_vma(mm, curr->vm_end);
-	else
-		next = curr;
+	/* Does the input range span an existing VMA? (cases 5 - 8) */
+	curr = find_vma_intersection(mm, prev ? prev->vm_end : 0, end);
 
-	/* In cases 1 - 4 there's no CCCC vma */
-	if (curr && end <= curr->vm_start)
-		curr = NULL;
+	if (!curr ||			/* cases 1 - 4 */
+	    end == curr->vm_end)	/* cases 6 - 8, adjacent VMA */
+		next = vma_lookup(mm, end);
+	else
+		next = NULL;		/* case 5 */
 
 	/* verify some invariant that must be enforced by the caller */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
@@ -946,11 +945,10 @@ struct vm_area_struct *vma_merge(struct
 		}
 	}
 	/* Can we merge the successor? */
-	if (next && end == next->vm_start &&
-			mpol_equal(policy, vma_policy(next)) &&
-			can_vma_merge_before(next, vm_flags,
-					     anon_vma, file, pgoff+pglen,
-					     vm_userfaultfd_ctx, anon_name)) {
+	if (next && mpol_equal(policy, vma_policy(next)) &&
+	    can_vma_merge_before(next, vm_flags,
+				 anon_vma, file, pgoff+pglen,
+				 vm_userfaultfd_ctx, anon_name)) {
 		merge_next = true;
 	}
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are


