Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B04C0015E
	for <mm-commits@archiver.kernel.org>; Sat,  5 Aug 2023 16:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjHEQ4J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Aug 2023 12:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjHEQ4J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 5 Aug 2023 12:56:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75544207
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 09:56:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4680A60C17
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 16:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96408C433C7;
        Sat,  5 Aug 2023 16:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691254566;
        bh=UVVpyBBpfnlh0i1D5jT/Yy3RFK91YqLbENFpSCRkMDA=;
        h=Date:To:From:Subject:From;
        b=SFSDZyryJOcVmAdon97rOtcLsyAJ8V9JXQliASp5x55bUrwSf4374iH0act6yXs8J
         oQV4QmM+WCOyPQhFRVMgr9DnPECA8xmXNdVm8cXJJNqmdq9lUr3lyfMp3+s0qZ0Ui2
         WeRDga6WeMsriYcWaitQUGGGvbizhMCGYY4sTUJg=
Date:   Sat, 05 Aug 2023 09:56:05 -0700
To:     mm-commits@vger.kernel.org, torvalds@linuxfoundation.org,
        Liam.Howlett@oracle.com, jannh@google.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap.patch added to mm-unstable branch
Message-Id: <20230805165606.96408C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: for !CONFIG_PER_VMA_LOCK equate write lock assertion for vma and mmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap.patch

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
Subject: mm: for !CONFIG_PER_VMA_LOCK equate write lock assertion for vma and mmap
Date: Fri, 4 Aug 2023 08:27:20 -0700

When CONFIG_PER_VMA_LOCK=n, vma_assert_write_locked() should be equivalent
to mmap_assert_write_locked().

Link: https://lkml.kernel.org/r/20230804152724.3090321-3-surenb@google.com
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap
+++ a/include/linux/mm.h
@@ -761,7 +761,8 @@ static inline bool vma_start_read(struct
 		{ return false; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
-static inline void vma_assert_write_locked(struct vm_area_struct *vma) {}
+static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+		{ mmap_assert_write_locked(vma->vm_mm); }
 static inline void vma_mark_detached(struct vm_area_struct *vma,
 				     bool detached) {}
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-enable-page-walking-api-to-lock-vmas-during-the-walk.patch
swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch
mm-handle-userfaults-under-vma-lock-fix.patch
mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap.patch
mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma.patch
mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once.patch
mm-always-lock-new-vma-before-inserting-into-vma-tree.patch
mm-move-vma-locking-out-of-vma_prepare-and-dup_anon_vma.patch

