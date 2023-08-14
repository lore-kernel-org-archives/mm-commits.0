Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD0BEB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 19:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjHNTPi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 15:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbjHNTP3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 15:15:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F6712E
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 12:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F1D662091
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 19:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9756DC433C9;
        Mon, 14 Aug 2023 19:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692040527;
        bh=UiAjKpXEW+QMFOElGUjS/ocSZBApzPJIBCSBV1WYk9w=;
        h=Date:To:From:Subject:From;
        b=eGV8vkmGHzvIuBgyR6bdWezVPIBlja9aSWIRcY4U29JUcw/X53bPVIS9V0t0xnsrm
         7vL8cp2tcYt9Rh200s5Y0M/YBv19XDf4ThKxgI5Qck2QFiknrgoHo16QfabJ6IHVnQ
         PHRRmfpx0305MTRa8dkxpaQr8Ow5BG7AvM7oeiLU=
Date:   Mon, 14 Aug 2023 12:15:26 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        Liam.Howlett@oracle.com, jannh@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-always-lock-new-vma-before-inserting-into-vma-tree-fix.patch added to mm-unstable branch
Message-Id: <20230814191527.9756DC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-always-lock-new-vma-before-inserting-into-vma-tree-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-always-lock-new-vma-before-inserting-into-vma-tree-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-always-lock-new-vma-before-inserting-into-vma-tree-fix.patch

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
Subject: mm-always-lock-new-vma-before-inserting-into-vma-tree-fix
Date: Mon Aug 14 12:13:22 PM PDT 2023

fix reject fixing in vma_link(), per Jann

Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-always-lock-new-vma-before-inserting-into-vma-tree-fix
+++ a/mm/mmap.c
@@ -401,10 +401,10 @@ static int vma_link(struct mm_struct *mm
 	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
-	vma_iter_store(&vmi, vma);
-
 	vma_start_write(vma);
 
+	vma_iter_store(&vmi, vma);
+
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
 		i_mmap_lock_write(mapping);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
mm-remove-redundant-k-macro-definition-fix.patch
mm-always-lock-new-vma-before-inserting-into-vma-tree-fix.patch

