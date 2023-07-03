Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB51C001B3
	for <mm-commits@archiver.kernel.org>; Mon,  3 Jul 2023 18:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjGCS1E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Jul 2023 14:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjGCS1D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jul 2023 14:27:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF14E5F
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 11:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1BEC60FF1
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 18:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C20C433C8;
        Mon,  3 Jul 2023 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688408819;
        bh=j9PL1F89pFjSpmmY0YCEWLET/Yuc0t+KrpV1neagjOY=;
        h=Date:To:From:Subject:From;
        b=oIsYXdZLacGlHf3CwhLHW5W7NQ9zBsmTTAGg0vILjI0ouHbQe4+hNekYgC8BVokeV
         N3MnSy+VoRmNwe3ybjAXmuFvkeYYCkcDklBm4oqX9nD099JdLVAEb02kyykPc5yFIb
         Jj2HQTh47pMHY2b8TsNTQa5QWz5NLZnjEB2/bGIM=
Date:   Mon, 03 Jul 2023 11:26:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, songliubraving@fb.com, shakeelb@google.com,
        rppt@kernel.org, rientjes@google.com, punit.agrawal@bytedance.com,
        peterz@infradead.org, peterx@redhat.com, paulmck@kernel.org,
        mingo@redhat.com, minchan@google.com, michel@lespinasse.org,
        mhocko@suse.com, mgorman@techsingularity.net, luto@kernel.org,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, ldufour@linux.ibm.com,
        kent.overstreet@linux.dev, joelaf@google.com, jirislaby@kernel.org,
        jannh@google.com, jacobly.alt@gmail.com, hughd@google.com,
        holger@applied-asynchrony.com, gthelen@google.com,
        edumazet@google.com, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, chriscli@google.com, bigeasy@linutronix.de,
        axelrasmussen@google.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-disable-config_per_vma_lock-by-default-until-its-fixed.patch added to mm-unstable branch
Message-Id: <20230703182659.42C20C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable CONFIG_PER_VMA_LOCK by default until its fixed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-disable-config_per_vma_lock-by-default-until-its-fixed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-disable-config_per_vma_lock-by-default-until-its-fixed.patch

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
Subject: mm: disable CONFIG_PER_VMA_LOCK by default until its fixed
Date: Mon, 3 Jul 2023 11:21:50 -0700

A memory corruption was reported in [1] with bisection pointing to the
patch [2] enabling per-VMA locks for x86.
Disable per-VMA locks config to prevent this issue while the problem is
being investigated. This is expected to be a temporary measure.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=217624
[2] https://lore.kernel.org/all/20230227173632.3292573-30-surenb@google.com

Link: https://lkml.kernel.org/r/20230703182150.2193578-1-surenb@google.com
Fixes: 0bff0aaea03e ("x86/mm: try VMA lock-based page fault handling first")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Reported-by: Jacob Young <jacobly.alt@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Holger Hoffstätte <holger@applied-asynchrony.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-disable-config_per_vma_lock-by-default-until-its-fixed
+++ a/mm/Kconfig
@@ -1227,7 +1227,7 @@ config ARCH_SUPPORTS_PER_VMA_LOCK
        def_bool n
 
 config PER_VMA_LOCK
-	def_bool y
+	bool "Enable per-vma locking during page fault handling."
 	depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
 	help
 	  Allow per-vma locking during page fault handling.
_

Patches currently in -mm which might be from surenb@google.com are

swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch
mm-disable-config_per_vma_lock-by-default-until-its-fixed.patch

