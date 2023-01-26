Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33782C27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjAZBsO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjAZBsN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:48:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1796B5C0CB
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:48:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FA1D616FD
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28ECC4339B;
        Thu, 26 Jan 2023 01:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674697692;
        bh=7ay9zrcV+RlfB0UJMeoMGmixe9lgRZ7nUpVcpaBEoyU=;
        h=Date:To:From:Subject:From;
        b=h4IS8X4IWdXgAItG4jVLVPvkiAmjgu2APcO4p+F/UzcgKFEnu2vZQlXJEQcNvFhAE
         Uw+a9REifnqbyZ60uyPcqKqbPv9pvleeKaRYzQHpPXDuP5wdbsMp5hTF16LaEdrCIP
         qdH1Q8yP8MyWB1QHkAr8CHMcWAvXKtrXMXaq9XcM=
Date:   Wed, 25 Jan 2023 17:48:11 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com, mhocko@suse.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch added to mm-unstable branch
Message-Id: <20230126014811.F28ECC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch

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
Subject: mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix
Date: Wed Jan 25 05:47:16 PM PST 2023

fix mm/nommu.c

Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/nommu.c~mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix
+++ a/mm/nommu.c
@@ -951,7 +951,7 @@ static int do_mmap_private(struct vm_are
 	atomic_long_add(total, &mmap_pages_allocated);
 
 	set_vm_flags(vma, VM_MAPPED_COPY);
-	region->vm_flags = vma->flags;
+	region->vm_flags = vma->vm_flags;
 	region->vm_start = (unsigned long) base;
 	region->vm_end   = region->vm_start + len;
 	region->vm_top   = region->vm_start + (total << PAGE_SHIFT);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch

