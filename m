Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1754DEB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 18:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjGKSPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 14:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGKSPX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 14:15:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10959E0;
        Tue, 11 Jul 2023 11:15:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C229615A5;
        Tue, 11 Jul 2023 18:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4374C433C7;
        Tue, 11 Jul 2023 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689099320;
        bh=a1W3QR7NQvYR0EAyNfTG/HrtT2WYT/vN1rWF91X8zsg=;
        h=Date:To:From:Subject:From;
        b=fg1fW/4qxeQ6PpBeMhMFqPwQp5bIhV6k43pZD3kz0kfYlSKJh1H7LoRDygCd0mnAr
         eZCATKwzZw2Im0hqrTOgHBwTEpzwzXhcO7+JR98GBTcPZD32Myij0ebTAHmvjVqM0g
         Grva+wx0a8sIaZASasaWq2ZEO8Mij6vQklmpAsM4=
Date:   Tue, 11 Jul 2023 11:15:20 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        ryan.roberts@arm.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-fix-vma-iterator-conversion-of-apply_vma_lock_flags.patch added to mm-hotfixes-unstable branch
Message-Id: <20230711181520.C4374C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: fix vma iterator conversion of apply_vma_lock_flags()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mlock-fix-vma-iterator-conversion-of-apply_vma_lock_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-fix-vma-iterator-conversion-of-apply_vma_lock_flags.patch

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

mm-mlock-fix-vma-iterator-conversion-of-apply_vma_lock_flags.patch

