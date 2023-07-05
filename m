Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9BEEEB64DA
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jul 2023 15:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjGEP7w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbjGEP7o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2023 11:59:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED7D1995
        for <mm-commits@vger.kernel.org>; Wed,  5 Jul 2023 08:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C8AD61495
        for <mm-commits@vger.kernel.org>; Wed,  5 Jul 2023 15:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5ABC433C8;
        Wed,  5 Jul 2023 15:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688572743;
        bh=mwp8BY/d0JPXsd9L4n0s87fcXnP4O990zrFUsdRhDAc=;
        h=Date:To:From:Subject:From;
        b=PTr2oiVMM9RyR5FCq5xdNTJ9lWXRfOCx2bUB+6z5mk3X1kjvXTqjO58EXHu0otxtX
         LgBzVWfQon8QoK5KEPkDozOvQO9/qncygiyzeMakUEaj73A8V+hA7Y44MMmyv35+Kp
         rnjIFwDyeobvCYqlTlH8PVgCV4bJFxx0rTkEWRdQ=
Date:   Wed, 05 Jul 2023 08:59:03 -0700
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
Subject: [alternative-merged] mm-disable-config_per_vma_lock-by-default-until-its-fixed.patch removed from -mm tree
Message-Id: <20230705155903.AD5ABC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: disable CONFIG_PER_VMA_LOCK by default until its fixed
has been removed from the -mm tree.  Its filename was
     mm-disable-config_per_vma_lock-by-default-until-its-fixed.patch

This patch was dropped because an alternative patch was or shall be merged

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
Acked-by: David Rientjes <rientjes@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
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

fork-lock-vmas-of-the-parent-process-when-forking.patch
mm-disable-config_per_vma_lock-until-its-fixed.patch
swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch

