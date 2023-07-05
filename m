Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DDFEB64DA
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jul 2023 15:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbjGEPsL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbjGEPsJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2023 11:48:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCCA1730;
        Wed,  5 Jul 2023 08:48:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C8916160D;
        Wed,  5 Jul 2023 15:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FF1C433C7;
        Wed,  5 Jul 2023 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688572087;
        bh=YEltOy5kLCSnNjMIKORxERugiqEPl1lEeXw34YPJpCM=;
        h=Date:To:From:Subject:From;
        b=KWIbfSpcIdtG3cekK8cQZ4h4fgtiXVNh3xbr4CBAhOG1yYbFpmLaPl9esnqpkNgkj
         Oz1ARluwFwJla46hz0+/SF4PoSLL0DXTxhlIuydp1NDJpoBWJ4irQMYb6VXj8rlqr2
         XuCXHydbI/a9xyoqx5GSUUIPCOfFbAagTMes2ikQ=
Date:   Wed, 05 Jul 2023 08:48:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, stable@vger.kernel.org, songliubraving@fb.com,
        shakeelb@google.com, rppt@kernel.org, rientjes@google.com,
        regressions@lists.linux.dev, punit.agrawal@bytedance.com,
        peterz@infradead.org, peterx@redhat.com, paulmck@kernel.org,
        mingo@redhat.com, minchan@google.com, michel@lespinasse.org,
        mhocko@suse.com, mgorman@techsingularity.net, luto@kernel.org,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, ldufour@linux.ibm.com,
        kent.overstreet@linux.dev, joelaf@google.com, jirislaby@kernel.org,
        jannh@google.com, jacobly.alt@gmail.com, hughd@google.com,
        holger@applied-asynchrony.com, hdegoede@redhat.com,
        hannes@cmpxchg.org, gthelen@google.com, gregkh@linuxfoundation.org,
        edumazet@google.com, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, chriscli@google.com, bigeasy@linutronix.de,
        bagasdotme@gmail.com, axelrasmussen@google.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-lock-vmas-of-the-parent-process-when-forking.patch added to mm-hotfixes-unstable branch
Message-Id: <20230705154807.73FF1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fork: lock VMAs of the parent process when forking
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fork-lock-vmas-of-the-parent-process-when-forking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-lock-vmas-of-the-parent-process-when-forking.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: fork: lock VMAs of the parent process when forking
Date: Tue, 4 Jul 2023 23:37:10 -0700

Patch series "Avoid memory corruption caused by per-VMA locks", v2.

A memory corruption was reported in [1] with bisection pointing to the
patch [2] enabling per-VMA locks for x86.  Based on the reproducer
provided in [1] we suspect this is caused by the lack of VMA locking while
forking a child process.

Patch 1/2 in the series implements proper VMA locking during fork.  I
tested the fix locally using the reproducer and was unable to reproduce
the memory corruption problem.

This fix can potentially regress some fork-heavy workloads.  Kernel build
time did not show noticeable regression on a 56-core machine while a
stress test mapping 10000 VMAs and forking 5000 times in a tight loop
shows ~5% regression.  If such fork time regression is unacceptable,
disabling CONFIG_PER_VMA_LOCK should restore its performance.  Further
optimizations are possible if this regression proves to be problematic.

Patch 2/2 disabled per-VMA locks until the fix is tested and verified.


This patch (of 2):

When forking a child process, parent write-protects an anonymous page and
COW-shares it with the child being forked using copy_present_pte(). 
Parent's TLB is flushed right before we drop the parent's mmap_lock in
dup_mmap().  If we get a write-fault before that TLB flush in the parent,
and we end up replacing that anonymous page in the parent process in
do_wp_page() (because, COW-shared with the child), this might lead to some
stale writable TLB entries targeting the wrong (old) page.  Similar issue
happened in the past with userfaultfd (see flush_tlb_page() call inside
do_wp_page()).

Lock VMAs of the parent process when forking a child, which prevents
concurrent page faults during fork operation and avoids this issue.  This
fix can potentially regress some fork-heavy workloads.  Kernel build time
did not show noticeable regression on a 56-core machine while a stress
test mapping 10000 VMAs and forking 5000 times in a tight loop shows ~5%
regression.  If such fork time regression is unacceptable, disabling
CONFIG_PER_VMA_LOCK should restore its performance.  Further optimizations
are possible if this regression proves to be problematic.

Link: https://lkml.kernel.org/r/20230705063711.2670599-1-surenb@google.com
Link: https://lkml.kernel.org/r/20230705063711.2670599-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://lore.kernel.org/all/dbdef34c-3a07-5951-e1ae-e9c6e3cdf51b@kernel.org/
Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Closes: https://lore.kernel.org/all/b198d649-f4bf-b971-31d0-e8433ec2a34c@applied-asynchrony.com/
Reported-by: Jacob Young <jacobly.alt@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D217624
Fixes: 0bff0aaea03e ("x86/mm: try VMA lock-based page fault handling first")
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: <regressions@lists.linux.dev>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <peterz@infradead.org>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/fork.c~fork-lock-vmas-of-the-parent-process-when-forking
+++ a/kernel/fork.c
@@ -686,6 +686,7 @@ static __latent_entropy int dup_mmap(str
 	for_each_vma(old_vmi, mpnt) {
 		struct file *file;
 
+		vma_start_write(mpnt);
 		if (mpnt->vm_flags & VM_DONTCOPY) {
 			vm_stat_account(mm, mpnt->vm_flags, -vma_pages(mpnt));
 			continue;
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
mm-disable-config_per_vma_lock-by-default-until-its-fixed.patch

