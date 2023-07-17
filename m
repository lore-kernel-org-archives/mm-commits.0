Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD34C001DC
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 19:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjGQTx7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 15:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjGQTx6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 15:53:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E79129;
        Mon, 17 Jul 2023 12:53:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50EB96123D;
        Mon, 17 Jul 2023 19:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C4DC433C7;
        Mon, 17 Jul 2023 19:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689623636;
        bh=ZSlOPK0CDBVMRBuDrIhQInXHcmuvoyYGNU7EX94fRKg=;
        h=Date:To:From:Subject:From;
        b=hUOIpWLpOzg8P6ac1cy+/5vfVIycw5MYTVr1AbOcse6w58/36eJRflWbW6PamPpp2
         qV+vjcSIFZz5T3Rn61KSbL8nYFgxM6FclBrp8a8VJtrq4nz75a0czJ51OCE97N0QwS
         ht8HRIk+WhCONmxzkChYqCmufT7YKKcSAn4fU+NE=
Date:   Mon, 17 Jul 2023 12:53:55 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        ryan.roberts@arm.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mlock-fix-vma-iterator-conversion-of-apply_vma_lock_flags.patch removed from -mm tree
Message-Id: <20230717195356.A4C4DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mlock: fix vma iterator conversion of apply_vma_lock_flags()
has been removed from the -mm tree.  Its filename was
     mm-mlock-fix-vma-iterator-conversion-of-apply_vma_lock_flags.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mlock: fix vma iterator conversion of apply_vma_lock_flags()
Date: Tue, 11 Jul 2023 13:50:20 -0400

apply_vma_lock_flags() calls mlock_fixup(), which could merge the VMA
after where the vma iterator is located.  Although this is not an issue,
the next iteration of the loop will check the start of the vma to be equal
to the locally saved 'tmp' variable and cause an incorrect failure
scenario.  Fix the error by setting tmp to the end of the vma iterator
value before restarting the loop.

There is also a potential of the error code being overwritten when the
loop terminates early.  Fix the return issue by directly returning when an
error is encountered since there is nothing to undo after the loop.

Link: https://lkml.kernel.org/r/20230711175020.4091336-1-Liam.Howlett@oracle.com
Fixes: 37598f5a9d8b ("mlock: convert mlock to vma iterator")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
  Link: https://lore.kernel.org/linux-mm/50341ca1-d582-b33a-e3d0-acb08a65166f@arm.com/
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/mlock.c~mm-mlock-fix-vma-iterator-conversion-of-apply_vma_lock_flags
+++ a/mm/mlock.c
@@ -477,7 +477,6 @@ static int apply_vma_lock_flags(unsigned
 {
 	unsigned long nstart, end, tmp;
 	struct vm_area_struct *vma, *prev;
-	int error;
 	VMA_ITERATOR(vmi, current->mm, start);
 
 	VM_BUG_ON(offset_in_page(start));
@@ -498,6 +497,7 @@ static int apply_vma_lock_flags(unsigned
 	nstart = start;
 	tmp = vma->vm_start;
 	for_each_vma_range(vmi, vma, end) {
+		int error;
 		vm_flags_t newflags;
 
 		if (vma->vm_start != tmp)
@@ -511,14 +511,15 @@ static int apply_vma_lock_flags(unsigned
 			tmp = end;
 		error = mlock_fixup(&vmi, vma, &prev, nstart, tmp, newflags);
 		if (error)
-			break;
+			return error;
+		tmp = vma_iter_end(&vmi);
 		nstart = tmp;
 	}
 
-	if (vma_iter_end(&vmi) < end)
+	if (tmp < end)
 		return -ENOMEM;
 
-	return error;
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch

