Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3DAC636D3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 00:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjBCAIO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Feb 2023 19:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbjBCAIM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2023 19:08:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9FF70996
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 16:08:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9C7161D11
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 00:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFD4C433EF;
        Fri,  3 Feb 2023 00:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675382890;
        bh=j3+VlHFdfa5YEyNsF5aa0DshXqts2ixwXrlDjSC/MaM=;
        h=Date:To:From:Subject:From;
        b=hAQ+B+pDIREdVAAXRX6fPNYYvQP3meDOK57835Kv1tcXqHE2AHvF5gQovcQqWrrSE
         CVBs5A4+oxTTy1agSrIhlERkybtH/X6jPCXLW3VVM2DJfYN8MXGq3vkiepc5RYMfPn
         P3QW8KQbAClCmYao87LSEYC7T2lIbun2ghvhzoIY=
Date:   Thu, 02 Feb 2023 16:08:09 -0800
To:     mm-commits@vger.kernel.org, mhocko@suse.com, 42.hyeyoo@gmail.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-vm_flags_reset_once-to-replace-write_once-vm_flags-updates.patch added to mm-unstable branch
Message-Id: <20230203000810.2AFD4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce vm_flags_reset_once to replace WRITE_ONCE vm_flags updates
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-vm_flags_reset_once-to-replace-write_once-vm_flags-updates.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-vm_flags_reset_once-to-replace-write_once-vm_flags-updates.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: introduce vm_flags_reset_once to replace WRITE_ONCE vm_flags updates
Date: Tue, 31 Jan 2023 16:01:16 -0800

Provide vm_flags_reset_once() and replace the vm_flags updates which used
WRITE_ONCE() to prevent compiler optimizations.

Link: https://lkml.kernel.org/r/20230201000116.1333160-1-surenb@google.com
Fixes: 0cce31a0aa0e ("mm: replace vma->vm_flags direct modifications with modifier calls")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-introduce-vm_flags_reset_once-to-replace-write_once-vm_flags-updates
+++ a/include/linux/mm.h
@@ -648,6 +648,13 @@ static inline void vm_flags_reset(struct
 	vm_flags_init(vma, flags);
 }
 
+static inline void vm_flags_reset_once(struct vm_area_struct *vma,
+				       vm_flags_t flags)
+{
+	mmap_assert_write_locked(vma->vm_mm);
+	WRITE_ONCE(ACCESS_PRIVATE(vma, __vm_flags), flags);
+}
+
 static inline void vm_flags_set(struct vm_area_struct *vma,
 				vm_flags_t flags)
 {
--- a/mm/mlock.c~mm-introduce-vm_flags_reset_once-to-replace-write_once-vm_flags-updates
+++ a/mm/mlock.c
@@ -380,7 +380,7 @@ static void mlock_vma_pages_range(struct
 	 */
 	if (newflags & VM_LOCKED)
 		newflags |= VM_IO;
-	vm_flags_reset(vma, newflags);
+	vm_flags_reset_once(vma, newflags);
 
 	lru_add_drain();
 	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
@@ -388,7 +388,7 @@ static void mlock_vma_pages_range(struct
 
 	if (newflags & VM_IO) {
 		newflags &= ~VM_IO;
-		vm_flags_reset(vma, newflags);
+		vm_flags_reset_once(vma, newflags);
 	}
 }
 
_

Patches currently in -mm which might be from surenb@google.com are

kernel-fork-convert-vma-assignment-to-a-memcpy.patch
mm-introduce-vma-vm_flags-wrapper-functions.patch
mm-replace-vm_locked_clear_mask-with-vm_locked_mask.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls.patch
mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch
mm-introduce-__vm_flags_mod-and-use-it-in-untrack_pfn.patch
mm-export-dump_mm.patch
mm-introduce-vm_flags_reset_once-to-replace-write_once-vm_flags-updates.patch

