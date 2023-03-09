Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412C4C64EC4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Mar 2023 01:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjCIBm0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 20:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCIBmZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 20:42:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D42793E0A
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 17:42:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A89CF618D2
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 01:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A03C433D2;
        Thu,  9 Mar 2023 01:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678326143;
        bh=mv4oBHxs3XG7lkZ95j94ct1eNQ//ZJJuJyjGnyHW3OU=;
        h=Date:To:From:Subject:From;
        b=MNdwmyyQHm2Bfx2sgbCZO2e4NwEkmHDcF4KBZ2XVticbzyi1vfVXZVf7yp1p4N6sY
         pSszUWXcbN6CkfRPgKrYggnYtRBzQpIUy7JgvYijs4yibEfTTYNMFOwHmP2cQOoSan
         FFE5e2TvLlGVhfiHEMA0gnJhrsqA58wGy/rWLpfQ=
Date:   Wed, 08 Mar 2023 17:42:22 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        sachinp@linux.ibm.com, ldufour@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerc-mm-try-vma-lock-based-page-fault-handling-first-fix.patch added to mm-unstable branch
Message-Id: <20230309014223.00A03C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: fix mmap_lock bad unlock
has been added to the -mm mm-unstable branch.  Its filename is
     powerc-mm-try-vma-lock-based-page-fault-handling-first-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerc-mm-try-vma-lock-based-page-fault-handling-first-fix.patch

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
From: Laurent Dufour <ldufour@linux.ibm.com>
Subject: powerpc/mm: fix mmap_lock bad unlock
Date: Mon, 6 Mar 2023 16:42:44 +0100

When page fault is tried holding the per VMA lock, bad_access_pkey() and
bad_access() should not be called because it is assuming the mmap_lock is
held.  In the case a bad access is detected, fall back to the default
path, grabbing the mmap_lock to handle the fault and report the error.

Link: https://lkml.kernel.org/r/20230306154244.17560-1-ldufour@linux.ibm.com
Fixes: 169db3bb4609 ("powerc/mm: try VMA lock-based page fault handling first")
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
  Link: https://lore.kernel.org/linux-mm/842502FB-F99C-417C-9648-A37D0ECDC9CE@linux.ibm.com
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/powerpc/mm/fault.c~powerc-mm-try-vma-lock-based-page-fault-handling-first-fix
+++ a/arch/powerpc/mm/fault.c
@@ -479,17 +479,13 @@ static int ___do_page_fault(struct pt_re
 
 	if (unlikely(access_pkey_error(is_write, is_exec,
 				       (error_code & DSISR_KEYFAULT), vma))) {
-		int rc = bad_access_pkey(regs, address, vma);
-
 		vma_end_read(vma);
-		return rc;
+		goto lock_mmap;
 	}
 
 	if (unlikely(access_error(is_write, is_exec, vma))) {
-		int rc = bad_access(regs, address);
-
 		vma_end_read(vma);
-		return rc;
+		goto lock_mmap;
 	}
 
 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
_

Patches currently in -mm which might be from ldufour@linux.ibm.com are

powerc-mm-try-vma-lock-based-page-fault-handling-first.patch
powerc-mm-try-vma-lock-based-page-fault-handling-first-fix.patch

