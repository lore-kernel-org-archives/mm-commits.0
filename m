Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ADAEC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 23:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbhLHXcM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Dec 2021 18:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbhLHXcM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2021 18:32:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A87C061746
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 15:28:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88DBFB822BD
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 23:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67BDC00446;
        Wed,  8 Dec 2021 23:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639006117;
        bh=iIaRdlycVf1cOoEV93ZHy0mV62Z5yexfcP6MFs9ILCo=;
        h=Date:From:To:Subject:From;
        b=kHmutY1kyQXAC6nxBPcLR0CBfU4fDxg0sQChut1wOyewuILa6DmIRQyvW6Ir9pqXy
         Lpc/jwPvTOf0xukrNi6Xmn1/oRli0TtFssWWaojdC4vPIfbAjT9ZjEySEXeoExUoZr
         co+VkQhruVfS9BxWEj4Xvi95asjq3B+qN1aaEahA=
Date:   Wed, 08 Dec 2021 15:28:36 -0800
From:   akpm@linux-foundation.org
To:     andrealmeid@collabora.com, dave@stgolabs.net, dvhart@infradead.org,
        jsavitz@redhat.com, longman@redhat.com, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, npache@redhat.com,
        peterz@infradead.org, tglx@linutronix.de
Subject:  +
 =?US-ASCII?Q?mm-oom=5Fkill-wake-futex-waiters-before-annihilating-victi?=
 =?US-ASCII?Q?m-shared-mutex.patch?= added to -mm tree
Message-ID: <20211208232836.jf3vMh3CL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: wake futex waiters before annihilating victim shared mutex
has been added to the -mm tree.  Its filename is
     mm-oom_kill-wake-futex-waiters-before-annihilating-victim-shared-mutex.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-wake-futex-waiters-before-annihilating-victim-shared-mutex.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-wake-futex-waiters-before-annihilating-victim-shared-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joel Savitz <jsavitz@redhat.com>
Subject: mm/oom_kill: wake futex waiters before annihilating victim shared mutex

In the case that two or more processes share a futex located within a
shared mmaped region, such as a process that shares a lock between itself
and a number of child processes, we have observed that when a process
holding the lock is oom killed, at least one waiter is never alerted to
this new development and simply continues to wait.

This is visible via pthreads by checking the __owner field of the
pthread_mutex_t structure within a waiting process, perhaps with gdb.

We identify reproduction of this issue by checking a waiting process of a
test program and viewing the contents of the pthread_mutex_t, taking note
of the value in the owner field, and then checking dmesg to see if the
owner has already been killed.

This issue can be tricky to reproduce, but with the modifications of this
small patch, I have found it to be impossible to reproduce.  There may be
additional considerations that I have not taken into account in this patch
and I welcome any comments and criticism.

Link: https://lkml.kernel.org/r/20211208181714.880312-1-jsavitz@redhat.com
Co-developed-by: Nico Pache <npache@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Andr Almeida <andrealmeid@collabora.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/oom_kill.c~mm-oom_kill-wake-futex-waiters-before-annihilating-victim-shared-mutex
+++ a/mm/oom_kill.c
@@ -44,6 +44,7 @@
 #include <linux/kthread.h>
 #include <linux/init.h>
 #include <linux/mmu_notifier.h>
+#include <linux/futex.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -886,6 +887,11 @@ static void __oom_kill_process(struct ta
 	memcg_memory_event_mm(mm, MEMCG_OOM_KILL);
 
 	/*
+	 * We call futex_exit_release() on the victim task to ensure any waiters on any
+	 * process-shared futexes held by the victim task are woken up.
+	 */
+	futex_exit_release(victim);
+	/*
 	 * We should send SIGKILL before granting access to memory reserves
 	 * in order to prevent the OOM victim from depleting the memory
 	 * reserves from the user space under its control.
@@ -930,6 +936,12 @@ static void __oom_kill_process(struct ta
 		 */
 		if (unlikely(p->flags & PF_KTHREAD))
 			continue;
+		/*
+		 * We call futex_exit_release() on any task p sharing the
+		 * victim->mm to ensure any waiters on any
+		 * process-shared futexes held by task p are woken up.
+		 */
+		futex_exit_release(p);
 		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
 	}
 	rcu_read_unlock();
_

Patches currently in -mm which might be from jsavitz@redhat.com are

mm-oom_kill-wake-futex-waiters-before-annihilating-victim-shared-mutex.patch

