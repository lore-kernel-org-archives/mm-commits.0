Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34B2C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbjAZAaq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbjAZAap (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:30:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D46B64DAF
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88F1C616F3
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF0CC433EF;
        Thu, 26 Jan 2023 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674693021;
        bh=qh33iDzVvZU5/l+Y7d8jJsn85YlMXdzGoewww29LLps=;
        h=Date:To:From:Subject:From;
        b=NVP+ZPuDVJKtHNILOK+frDCzgfCim1P2VxnATmZDHv9oXJIFhRH2L585Ue58u3U4J
         B1xpbhaJcl7IJpspamy4Gglkwoof97r4wko3KJvoTmdZefRgmXAZ+CJ+qO1JfRYqsl
         70xwwkVdjDkjKqE4dYrWVwNw4hNMzr6yunJ1/N+4=
Date:   Wed, 25 Jan 2023 16:30:20 -0800
To:     mm-commits@vger.kernel.org, mhocko@suse.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-vma-vm_flags-wrapper-functions.patch added to mm-unstable branch
Message-Id: <20230126003020.DEF0CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce vma->vm_flags wrapper functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-vma-vm_flags-wrapper-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-vma-vm_flags-wrapper-functions.patch

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
Subject: mm: introduce vma->vm_flags wrapper functions
Date: Wed, 25 Jan 2023 15:35:49 -0800

vm_flags are among VMA attributes which affect decisions like VMA merging
and splitting.  Therefore all vm_flags modifications are performed after
taking exclusive mmap_lock to prevent vm_flags updates racing with such
operations.  Introduce modifier functions for vm_flags to be used whenever
flags are updated.  This way we can better check and control correct
locking behavior during these updates.

Link: https://lkml.kernel.org/r/20230125233554.153109-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-introduce-vma-vm_flags-wrapper-functions
+++ a/include/linux/mm.h
@@ -627,6 +627,43 @@ static inline void vma_init(struct vm_ar
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 }
 
+/* Use when VMA is not part of the VMA tree and needs no locking */
+static inline void init_vm_flags(struct vm_area_struct *vma,
+				 vm_flags_t flags)
+{
+	ACCESS_PRIVATE(vma, __vm_flags) = flags;
+}
+
+/* Use when VMA is part of the VMA tree and modifications need coordination */
+static inline void reset_vm_flags(struct vm_area_struct *vma,
+				  vm_flags_t flags)
+{
+	mmap_assert_write_locked(vma->vm_mm);
+	init_vm_flags(vma, flags);
+}
+
+static inline void set_vm_flags(struct vm_area_struct *vma,
+				vm_flags_t flags)
+{
+	mmap_assert_write_locked(vma->vm_mm);
+	ACCESS_PRIVATE(vma, __vm_flags) |= flags;
+}
+
+static inline void clear_vm_flags(struct vm_area_struct *vma,
+				  vm_flags_t flags)
+{
+	mmap_assert_write_locked(vma->vm_mm);
+	ACCESS_PRIVATE(vma, __vm_flags) &= ~flags;
+}
+
+static inline void mod_vm_flags(struct vm_area_struct *vma,
+				vm_flags_t set, vm_flags_t clear)
+{
+	mmap_assert_write_locked(vma->vm_mm);
+	ACCESS_PRIVATE(vma, __vm_flags) |= set;
+	ACCESS_PRIVATE(vma, __vm_flags) &= ~clear;
+}
+
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
 {
 	vma->vm_ops = NULL;
--- a/include/linux/mm_types.h~mm-introduce-vma-vm_flags-wrapper-functions
+++ a/include/linux/mm_types.h
@@ -491,7 +491,15 @@ struct vm_area_struct {
 	 * See vmf_insert_mixed_prot() for discussion.
 	 */
 	pgprot_t vm_page_prot;
-	unsigned long vm_flags;		/* Flags, see mm.h. */
+
+	/*
+	 * Flags, see mm.h.
+	 * To modify use {init|reset|set|clear|mod}_vm_flags() functions.
+	 */
+	union {
+		const vm_flags_t vm_flags;
+		vm_flags_t __private __vm_flags;
+	};
 
 	/*
 	 * For areas with an address space and backing store,
_

Patches currently in -mm which might be from surenb@google.com are

kernel-fork-convert-vma-assignment-to-a-memcpy.patch
mm-introduce-vma-vm_flags-wrapper-functions.patch
mm-replace-vm_locked_clear_mask-with-vm_locked_mask.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls.patch
mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch
mm-introduce-mod_vm_flags_nolock-and-use-it-in-untrack_pfn.patch
mm-export-dump_mm.patch

