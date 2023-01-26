Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B632EC54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjAZXJf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAZXJe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:09:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D627523C7F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:09:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6868B6191F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C64C433EF;
        Thu, 26 Jan 2023 23:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674774571;
        bh=MYCUdA+wYVXsX8EWUt3BEBr88DO4becPkPWHQNveR50=;
        h=Date:To:From:Subject:From;
        b=RZUOG6iD4lIIwCQ9mrtVl6RPW+IIMAVFccqDxVY/bESrhrObZiBCVoIDiVZklxNmd
         2INxQjwoSChWTBWNRwgaAQBFibQ8hASZ6vhZGIHvy+zsDm7KDfJC3IbjGE9bek51i2
         f9imJoY/FxM+g3UKbg5qQKah0Sufot9bK6VFblzc=
Date:   Thu, 26 Jan 2023 15:09:31 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, songliubraving@fb.com, soheil@google.com,
        shakeelb@google.com, sebastian.reichel@collabora.com,
        rppt@kernel.org, rientjes@google.com, punit.agrawal@bytedance.com,
        posk@google.com, peterz@infradead.org, peterx@redhat.com,
        paulmck@kernel.org, mingo@redhat.com, minchan@google.com,
        mhocko@suse.com, mgorman@techsingularity.net, luto@kernel.org,
        lstoakes@gmail.com, Liam.Howlett@Oracle.com, ldufour@linux.ibm.com,
        kent.overstreet@linux.dev, joelaf@google.com, jannh@google.com,
        hughd@google.com, hannes@cmpxchg.org, gthelen@google.com,
        edumazet@google.com, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, bigeasy@linutronix.de, axelrasmussen@google.com,
        arjunroy@google.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fork-convert-vma-assignment-to-a-memcpy.patch added to mm-unstable branch
Message-Id: <20230126230931.B3C64C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork: convert vma assignment to a memcpy
has been added to the -mm mm-unstable branch.  Its filename is
     kernel-fork-convert-vma-assignment-to-a-memcpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fork-convert-vma-assignment-to-a-memcpy.patch

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
Subject: kernel/fork: convert vma assignment to a memcpy
Date: Thu, 26 Jan 2023 11:37:46 -0800

Patch series "introduce vm_flags modifier functions", v4.

This patchset was originally published as a part of per-VMA locking [1]
and was split after suggestion that it's viable on its own and to
facilitate the review process.  It is now a preprequisite for the next
version of per-VMA lock patchset, which reuses vm_flags modifier functions
to lock the VMA when vm_flags are being updated.

VMA vm_flags modifications are usually done under exclusive mmap_lock
protection because this attrubute affects other decisions like VMA merging
or splitting and races should be prevented.  Introduce vm_flags modifier
functions to enforce correct locking.


This patch (of 7):

Convert vma assignment in vm_area_dup() to a memcpy() to prevent compiler
errors when we add a const modifier to vma->vm_flags.

Link: https://lkml.kernel.org/r/20230126193752.297968-1-surenb@google.com
Link: https://lkml.kernel.org/r/20230126193752.297968-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Oskolkov <posk@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~kernel-fork-convert-vma-assignment-to-a-memcpy
+++ a/kernel/fork.c
@@ -472,7 +472,7 @@ struct vm_area_struct *vm_area_dup(struc
 		 * orig->shared.rb may be modified concurrently, but the clone
 		 * will be reinitialized.
 		 */
-		*new = data_race(*orig);
+		data_race(memcpy(new, orig, sizeof(*new)));
 		INIT_LIST_HEAD(&new->anon_vma_chain);
 		dup_anon_vma_name(orig, new);
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

