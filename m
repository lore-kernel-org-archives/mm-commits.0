Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9BCC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbjDFDAg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbjDFDAg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:00:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5878A5FCF
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:00:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E58F56412C
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490C1C433A0;
        Thu,  6 Apr 2023 03:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750034;
        bh=BO6k8Af0mh8hwRI+v5DqU1b4MOt4EC1N9u69qM51Xr8=;
        h=Date:To:From:Subject:From;
        b=kDXA/2F9qxQC+4XoQeAfppUdB/5Jkv7MGR/sPI+idAx28X//3lEM50Z6dtd5A9PTp
         8IWD6uLOBJmpypAsH0PFD828NeILtMADBxi+GgUAf61Fi1Ea3nrMRvvvu+qyAkWiUU
         T81QIvKRg2jqtYNLQ9inUTEy8GxEGONOHf5DA+pk=
Date:   Wed, 05 Apr 2023 20:00:33 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        sachinp@linux.ibm.com, ldufour@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] powerc-mm-try-vma-lock-based-page-fault-handling-first-fix.patch removed from -mm tree
Message-Id: <20230406030034.490C1C433A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/mm: fix mmap_lock bad unlock
has been removed from the -mm tree.  Its filename was
     powerc-mm-try-vma-lock-based-page-fault-handling-first-fix.patch

This patch was dropped because it was folded into powerc-mm-try-vma-lock-based-page-fault-handling-first.patch

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

 arch/powerpc/mm/fault.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/arch/powerpc/mm/fault.c~powerc-mm-try-vma-lock-based-page-fault-handling-first-fix
+++ a/arch/powerpc/mm/fault.c
@@ -484,17 +484,13 @@ static int ___do_page_fault(struct pt_re
 
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

