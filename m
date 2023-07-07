Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB82EEB64D9
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 19:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbjGGTbW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 15:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjGGT3V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 15:29:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26A82680
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 12:29:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40D0461A53
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 19:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F23C433C9;
        Fri,  7 Jul 2023 19:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688758159;
        bh=zNVEj9OkVGve9TGWL5gdEfCayCqV4UQjxZni1UhIswM=;
        h=Date:To:From:Subject:From;
        b=ABXISzgnCzNU5knUCoY0LLRG+QkSM73bMAVTxuqzSfVgaN1oEazcXoe9/eD2dPSLa
         lH/zV9JQ1PDXxz0s/wZmnqZ7sZu8ttz2EwyImMiIsQXnjoDOfEH/4I2k1uR8pZD+zS
         CSLDmyQ0UobpOmKFvoLdo91HDHs4Oxlf6Le2ncjk=
Date:   Fri, 07 Jul 2023 12:29:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shakeelb@google.com, rientjes@google.com,
        punit.agrawal@bytedance.com, peterx@redhat.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, ldufour@linux.ibm.com, jannh@google.com,
        hughd@google.com, hannes@cmpxchg.org, gthelen@google.com,
        david@redhat.com, dave@stgolabs.net, axelrasmussen@google.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lock-a-vma-before-stack-expansion.patch added to mm-unstable branch
Message-Id: <20230707192919.92F23C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: lock a vma before stack expansion
has been added to the -mm mm-unstable branch.  Its filename is
     mm-lock-a-vma-before-stack-expansion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lock-a-vma-before-stack-expansion.patch

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
Subject: mm: lock a vma before stack expansion
Date: Thu, 6 Jul 2023 21:32:10 -0700

With recent changes necessitating mmap_lock to be held for write while
expanding a stack, per-VMA locks should follow the same rules and be
write-locked to prevent page faults into the VMA being expanded.  Add the
necessary locking.

Link: https://lkml.kernel.org/r/20230707043211.3682710-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mmap.c~mm-lock-a-vma-before-stack-expansion
+++ a/mm/mmap.c
@@ -1977,6 +1977,8 @@ static int expand_upwards(struct vm_area
 		return -ENOMEM;
 	}
 
+	/* Lock the VMA before expanding to prevent concurrent page faults */
+	vma_start_write(vma);
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
 	 * is required to hold the mmap_lock in read mode.  We need the
@@ -2064,6 +2066,8 @@ int expand_downwards(struct vm_area_stru
 		return -ENOMEM;
 	}
 
+	/* Lock the VMA before expanding to prevent concurrent page faults */
+	vma_start_write(vma);
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
 	 * is required to hold the mmap_lock in read mode.  We need the
_

Patches currently in -mm which might be from surenb@google.com are

fork-lock-vmas-of-the-parent-process-when-forking.patch
mm-disable-config_per_vma_lock-until-its-fixed.patch
swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch
mm-lock-a-vma-before-stack-expansion.patch
mm-lock-newly-mapped-vma-which-can-be-modified-after-it-becomes-visible.patch

