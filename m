Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50633C77B71
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 19:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjDNTyG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 15:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjDNTyF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 15:54:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8932855A6
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 12:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17FDC61DCF
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 19:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCD4C433D2;
        Fri, 14 Apr 2023 19:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681502033;
        bh=D+J08/eZyZiIJYbonPnY1m45aloHUdfGeOYFqfIU0OQ=;
        h=Date:To:From:Subject:From;
        b=cTLHVA3QsWUP2h4QhfzRN3EuON/kgssol7P3oGpfSixicN4ERtAu/MEAibzgJjKG9
         cKTmgqzEyMbQysxSQXxqMkfXSaXYfvXgW+psBWDAWnBmB3TvG0wv4QrGxePnJ9nuQn
         /iciGUNyfHj8VIGdJ+3oZsUZgngkU8YhNPv/DZcM=
Date:   Fri, 14 Apr 2023 12:53:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        punit.agrawal@bytedance.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@Oracle.com, ldufour@linux.ibm.com,
        laurent.dufour@fr.ibm.com, josef@toxicpanda.com, jack@suse.cz,
        hannes@cmpxchg.org, dave@stgolabs.net, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-increment-pgfault-stats-when-page-fault-handler-retries.patch added to mm-unstable branch
Message-Id: <20230414195353.6FCD4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not increment pgfault stats when page fault handler retries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-do-not-increment-pgfault-stats-when-page-fault-handler-retries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-increment-pgfault-stats-when-page-fault-handler-retries.patch

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
Subject: mm: do not increment pgfault stats when page fault handler retries
Date: Fri, 14 Apr 2023 10:54:44 -0700

If the page fault handler requests a retry, we will count the fault
multiple times.  This is a relatively harmless problem as the retry paths
are not often requested, and the only user-visible problem is that the
fault counter will be slightly higher than it should be.  Nevertheless,
userspace only took one fault, and should not see the fact that the kernel
had to retry the fault multiple times.

Link: https://lkml.kernel.org/r/20230414175444.1837474-1-surenb@google.com
Fixes: d065bd810b6d ("mm: retry page fault when blocking on disk transfer")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@android.com
Cc: Laurent Dufour <laurent.dufour@fr.ibm.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-do-not-increment-pgfault-stats-when-page-fault-handler-retries
+++ a/mm/memory.c
@@ -5197,17 +5197,16 @@ vm_fault_t handle_mm_fault(struct vm_are
 
 	__set_current_state(TASK_RUNNING);
 
-	count_vm_event(PGFAULT);
-	count_memcg_event_mm(vma->vm_mm, PGFAULT);
-
 	ret = sanitize_fault_flags(vma, &flags);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (!arch_vma_access_permitted(vma, flags & FAULT_FLAG_WRITE,
 					    flags & FAULT_FLAG_INSTRUCTION,
-					    flags & FAULT_FLAG_REMOTE))
-		return VM_FAULT_SIGSEGV;
+					    flags & FAULT_FLAG_REMOTE)) {
+		ret = VM_FAULT_SIGSEGV;
+		goto out;
+	}
 
 	/*
 	 * Enable the memcg OOM handling for faults triggered in user
@@ -5238,6 +5237,11 @@ vm_fault_t handle_mm_fault(struct vm_are
 	}
 
 	mm_account_fault(regs, address, flags, ret);
+out:
+	if (!(ret & VM_FAULT_RETRY)) {
+		count_vm_event(PGFAULT);
+		count_memcg_event_mm(vma->vm_mm, PGFAULT);
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from surenb@google.com are

mm-do-not-increment-pgfault-stats-when-page-fault-handler-retries.patch

