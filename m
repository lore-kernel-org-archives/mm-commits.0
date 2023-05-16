Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8B8C77B7A
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 22:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjEPWEL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 18:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjEPWEK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 18:04:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0DF1BC7
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 15:04:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12F7A6366C
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 22:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B02C433EF;
        Tue, 16 May 2023 22:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684274648;
        bh=LHOEqDSiYw5IAREK4ASZOgOs4TheE2PkBLDTRBm88mI=;
        h=Date:To:From:Subject:From;
        b=NP4xf8h9HWjLez6ylPzcAvDTqCfTY8mdoufGYqvb/mif/LtmrH8lswrCW/9HLet9l
         yXoWwPS0oJsT3/LoLUig/tOnmReDjfDzWZYuNHOGxYSiiSvEBELsUa2H/dPNg9K6KR
         2HzAsnRm57/HnEGLA6HTeQouOmM9JY/7FPxYV4ac=
Date:   Tue, 16 May 2023 15:04:07 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        anders.roxell@linaro.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230516220408.61B02C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix
Date: Tue May 16 02:56:04 PM PDT 2023

fix unused var warning

Reported-by: Anders Roxell <anders.roxell@linaro.org>
  Link: https://lkml.kernel.org/r/20230516094919.GA411@mutt
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix
+++ a/mm/memory.c
@@ -5605,11 +5605,11 @@ int __access_remote_vm(struct mm_struct
 							     gup_flags, &vma);
 
 		if (IS_ERR_OR_NULL(page)) {
-			int ret = 0;
-
 #ifndef CONFIG_HAVE_IOREMAP_PROT
 			break;
 #else
+			int res = 0;
+
 			/*
 			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
 			 * we can access using slightly different code.
@@ -5617,11 +5617,11 @@ int __access_remote_vm(struct mm_struct
 			if (!vma)
 				break;
 			if (vma->vm_ops && vma->vm_ops->access)
-				ret = vma->vm_ops->access(vma, addr, buf,
+				res = vma->vm_ops->access(vma, addr, buf,
 							  len, write);
-			if (ret <= 0)
+			if (res <= 0)
 				break;
-			bytes = ret;
+			bytes = res;
 #endif
 		} else {
 			bytes = len;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch
mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix.patch

