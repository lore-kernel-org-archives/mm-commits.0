Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BB0CDB472
	for <mm-commits@archiver.kernel.org>; Wed, 11 Oct 2023 17:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjJKRyz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Oct 2023 13:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbjJKRyy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2023 13:54:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDB593
        for <mm-commits@vger.kernel.org>; Wed, 11 Oct 2023 10:54:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC275C433C7;
        Wed, 11 Oct 2023 17:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697046893;
        bh=D501XVm+AePSFy5vXS8VaUDAHSDbACsj6NakuaIOwIo=;
        h=Date:To:From:Subject:From;
        b=lqaO3DE9BkSQpW19L1lZvwHJgKhLnJgWzBdYGjxbXZDywHPHp8+9MHcGV+0mc1Qot
         MBCQ7hxNmND46Sc/NwO0K47Trk0xImUfgR28H9kCryFoNT/Piv73P2ZHBqp9eYxr4n
         GTbhjEZ4NqKcKC7q8zI1lvIrukoPX572FCG/PSDU=
Date:   Wed, 11 Oct 2023 10:54:40 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, lstoakes@gmail.com, Liam.Howlett@oracle.com,
        brauner@kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al-fix.patch added to mm-unstable branch
Message-Id: <20231011175451.BC275C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al-fix.patch

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
Subject: mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al-fix
Date: Wed Oct 11 10:40:28 AM PDT 2023

fix userfaultfd_unregister() error return, per Vlastimil

Link: https://lkml.kernel.org/r/7b94fcb3-9ffe-1fc8-3f9d-6a7176069aeb@suse.cz
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/userfaultfd.c~mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al-fix
+++ a/fs/userfaultfd.c
@@ -1654,7 +1654,7 @@ static int userfaultfd_unregister(struct
 		vma = vma_modify_flags_uffd(&vmi, prev, vma, start, vma_end,
 					    new_flags, NULL_VM_UFFD_CTX);
 		if (IS_ERR(vma)) {
-			ret = PTR_ERR(prev);
+			ret = PTR_ERR(vma);
 			break;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch
mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al-fix.patch
mark-stuff-as-__ro_after_init-checkpatch-fixes.patch

